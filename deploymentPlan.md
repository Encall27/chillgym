# ChillGym Deployment Plan

This is the practical, end-to-end checklist for taking the current Flutter web build to **Android (Google Play)** and **iOS (App Store)**, with GitHub Actions for CI. Read top-to-bottom once; it's structured roughly in the order you'll execute.

## 0. Reality check before anything else

You are on **Windows 10**. Two structural facts that decide your toolchain:

1. **iOS builds require macOS.** Apple's signing tools (`xcodebuild`, `codesign`, `xcrun altool`) only run on Macs. There is no supported way around this. Your three options:
   - Borrow / buy a Mac (cheapest viable: a used Mac mini M1, ~US$400). Best DX.
   - **Codemagic** (codemagic.io) — Flutter-friendly CI service that gives you cloud Macs. Free tier: 500 build minutes/month. **Recommended for you.**
   - **GitHub Actions `macos-latest` runners** — works for IPA builds, but you'll lack a local Mac for live debugging the iOS app on the iOS Simulator before submission.
2. **Android works fully on Windows.** You can develop, build, sign, and ship Android on your existing machine. Start there to gain confidence, then add iOS via Codemagic or a borrowed Mac.

This plan is laid out in that order: **Android first, iOS second.**

## 0.5. Where you are right now (2026-05-08)

The app is feature-complete for v1 logging:

- Full session lifecycle (start, log sets, finish, share card)
- Templates, custom exercises (with equipment type), workout rename
- Calendar with monthly + yearly views, day pop-out, scope-filtered sessions list
- Progress with featured-lift hero, per-exercise detail, day-changes (body photos + bodyweight)
- Streaks, inactivity nudge, rest-timer notifications
- Bodyweight quick-log on Progress and Profile
- Two themes (Warm Editorial + Dark Performance), three locales (en, zh, zh_HK)
- Local-only persistence, JSON export/import

**Not yet wired** (intentional, see §8.3 and §7.5 below):
- SSO / cloud sync
- IndexedDB for web body-photo blobs (still localStorage → ~5MB cap)
- Real app icon and splash assets
- Privacy policy URL
- Store screenshots and copy

**Practical next-step order**, before §1 cleanup:

1. Hand-test the build on web in **release mode** (`flutter run -d chrome --release`) — debug mode masks layout assertions like the borderRadius bug we hit. Walk every tab, log a session, take a body photo, finish the workout, share, switch theme + language.
2. Decide local-only vs Firebase using §7.5 below. Default answer: local-only for v1.
3. Then start §1 (rename + icons + privacy URL).

## 0.7. Testing flow before each store upload

Treat this as a checklist you run end-to-end on a clean install before tagging a release. It catches the boring 80% of rejection causes.

### A. Smoke test (every device you target)
- Web release mode: `flutter run -d chrome --release`
- Android release on a real phone: `flutter run --release`
- iOS release on a real iPhone (via Codemagic TestFlight if you don't have a Mac)

For each, do this exact path:
1. Cold-launch the app. Welcome lands on Home with no errors in console.
2. Start a fresh workout. Add 3 exercises (1 cardio, 2 strength). Log sets. Finish. Share card opens, "Save" works, "Share" opens the system sheet on mobile.
3. Open Calendar. Tap today (or the day you just trained). Pop-out shows. Close it. Switch to Yearly view. Tap a month → returns to Monthly.
4. Open Progress. Switch between Lifts and Day Changes. Tap "Pick a lift" — centered dialog. Log a bodyweight from the Day Changes button.
5. Open a session in History. Edit details (rename, add a friend), Save. Verify the rename appears in Home recent + Calendar pop-out.
6. Profile → Theme: toggle Light / Dark. Profile → Language: toggle en ↔ zh_HK. No copy clipped, no obvious untranslated keys.
7. Profile → Data → Export JSON, then Import the same JSON back. Counts match before/after.
8. **Mobile only:** rest-timer notification fires after a logged set when phone is locked. Inactivity nudge fires after the configured days (set to 2d to test).
9. **Web only:** add a body photo. Quota error doesn't appear at < 5 photos. (This will eventually need IndexedDB; tracked.)

If any step throws a red exception screen, **don't tag the release** — fix and re-run.

### B. Static checks (CI runs this; also run locally before tagging)
```bash
flutter analyze         # must report "No issues found"
flutter test            # all widget tests pass
dart format --set-exit-if-changed lib test
```

### C. Pre-store bundle checks
- `flutter build appbundle --release` succeeds on Windows
- `flutter build ipa --release` succeeds on Codemagic (or your Mac)
- AAB size < 50 MB (Play tolerates more, but anything over is a smell)
- IPA opens in TestFlight without "Invalid Binary" email after upload

### D. Store-listing dry run
Before clicking Submit:
- Privacy policy URL returns 200
- Screenshots match the actual UI (no Figma mockups)
- Description doesn't promise features that aren't shipped (no SSO, no Firebase, etc.)
- Data-safety form matches §7.5 — say "all data stored on device" *only* if it's true

## 1. Pre-launch repo cleanup (do this first — none of it is optional)

The scaffolded Android/iOS configs still say `gymwhenyouready`. Fix these *before* you generate signing keys, because the bundle identifier becomes the immutable identity of your app on each store and renaming after publish is a brand-new app.

### 1.1. Choose your bundle identifier

Pick a reverse-DNS string you control. Examples:

- If you own a domain `chillgym.app` → `app.chillgym.mobile`
- Else → `com.<yourgithubusername>.chillgym` (e.g. `com.encall27.chillgym`)

This same string is used for **both** Android `applicationId` and iOS `PRODUCT_BUNDLE_IDENTIFIER`. Keep them identical to make CI scripts simpler.

### 1.2. Rename Android

Edit `android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.encall27.chillgym"          // <-- change
    ...
    defaultConfig {
        applicationId = "com.encall27.chillgym"  // <-- change
    }
}
```

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="ChillGym"   <!-- was "gymwhenyouready" -->
    ...>
```

The folder under `android/app/src/main/kotlin/` is currently `com/gymwhenyouready/gymwhenyouready/MainActivity.kt`. **Move** it to `com/encall27/chillgym/MainActivity.kt` and update the `package` line at the top of `MainActivity.kt`. (PowerShell: `git mv` to preserve history.)

### 1.3. Rename iOS

Open `ios/Runner.xcodeproj/project.pbxproj` (it's a text file, edit in any editor). Find every occurrence of `com.gymwhenyouready.gymwhenyouready` and replace with `com.encall27.chillgym`. There are five matches across debug/release/profile + RunnerTests.

Edit `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>ChillGym</string>     <!-- was "Gymwhenyouready" -->
<key>CFBundleName</key>
<string>ChillGym</string>     <!-- was "gymwhenyouready" -->
```

### 1.4. **Critical:** add iOS usage descriptions (or the app crashes on first photo pick)

`image_picker`, `health`, and `flutter_local_notifications` all need declared usage strings on iOS. Add these inside the top-level `<dict>` in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>ChillGym uses the camera to capture exercise and body progress photos you choose to attach.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>ChillGym lets you attach existing photos from your library to exercises and body progress entries.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>ChillGym saves shared workout cards to your photo library when you tap Save.</string>
<key>NSHealthShareUsageDescription</key>
<string>ChillGym reads your bodyweight and heart-rate data from Apple Health if you enable the integration.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>ChillGym writes finished workouts to Apple Health when the integration is enabled.</string>
<key>NSUserNotificationsUsageDescription</key>
<string>ChillGym uses notifications for the rest timer and inactivity nudges.</string>
```

Without these the App Store will **reject** your binary, and the app will hard-crash the moment the user taps "Take photo".

### 1.5. App icon

Default Flutter icons get auto-rejected by Apple. Use [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons):

```bash
flutter pub add --dev flutter_launcher_icons
```

Add to `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/chillgym_icon.png"   # 1024×1024 PNG, no alpha for iOS
  remove_alpha_ios: true
  adaptive_icon_background: "#FFE0A82E"          # warm yellow brand
  adaptive_icon_foreground: "assets/icon/chillgym_foreground.png"
```

Drop a 1024×1024 PNG into `assets/icon/`, then:

```bash
dart run flutter_launcher_icons
```

Commit the generated `mipmap-*` and `AppIcon.appiconset/*` files.

### 1.6. Splash screen

Use [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash):

```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: "assets/icon/chillgym_splash.png"
  color_dark: "#1F1A14"
  android_12:
    image: "assets/icon/chillgym_splash.png"
    color: "#FFFFFF"
```

```bash
dart run flutter_native_splash:create
```

### 1.7. Version it

In `pubspec.yaml`:

```yaml
version: 0.1.0+1
```

The number after `+` is the build number. Bump the **build number** every store upload (Play and App Store both reject duplicates). Bump the **version string** for user-facing releases. CI scripts below will inject these from git tags.

### 1.8. Privacy policy URL

Both stores require one. Even a single-page URL on a free GitHub Pages or `chillgym.app/privacy` is fine. Must cover: what data you collect (just local storage today), whether you share it (no), retention, and contact email. There are MIT-style templates online. **You cannot submit without this.**

## 2. Accounts & one-time setup

Create these in advance — both have approval delays.

| Account | Cost | Time to active | Notes |
|---|---|---|---|
| **Google Play Console** | US$25 one-time | Same day, sometimes ~48h verification | https://play.google.com/console |
| **Apple Developer Program** | US$99/year | Up to 48h identity check; can be longer for individuals without a D-U-N-S | https://developer.apple.com/programs |
| **Codemagic** *(recommended for iOS CI)* | Free tier | Instant | https://codemagic.io |
| **GitHub** repo with Actions enabled | Free | Already done | — |

For Apple specifically:
- Choose **Individual** enrollment if it's just you, **Organization** if you want "ChillGym Inc." as the seller name (requires a D-U-N-S number, takes ~2 weeks).
- Once enrolled, in **Apple Developer → Certificates, Identifiers & Profiles**: register your bundle ID (`com.encall27.chillgym`), create an **App Store distribution certificate**, and create an **App Store provisioning profile** for that bundle ID.

## 3. Local Android build & test (Windows, today)

### 3.1. Tools

```bash
flutter doctor            # confirm Android toolchain green
```

Install **Android Studio**, accept all SDK licenses (`flutter doctor --android-licenses`).

### 3.2. Run on an emulator

```bash
flutter emulators --launch Pixel_7_API_34   # or any AVD you've created
flutter run -d emulator-5554
```

Test the full flow: log a workout, attach a photo, finish → share card, body diagram, language toggle. Photos via the emulator's fake camera should work — image_picker will fall back to gallery if camera fails.

### 3.3. Run on a physical device

1. Enable **Developer options** on the phone (tap Build number 7 times).
2. Enable **USB debugging** under Developer options.
3. Plug in via USB.
4. `flutter devices` should list it.
5. `flutter run -d <device-id>` (use `--release` for a real-world performance check).

This is also where you verify notifications and Apple Health-equivalent (Health Connect on Android) actually fire on a real OS.

### 3.4. Generate the upload keystore (one-time)

```bash
keytool -genkey -v -keystore $env:USERPROFILE\chillgym-upload.jks `
  -keyalg RSA -keysize 2048 -validity 10000 -alias chillgym
```

You'll be asked for a keystore password and key password. **Store these in a password manager**; if you lose them, you lose the ability to push updates and have to publish as a new app. (Google Play also lets you opt into **Play App Signing**, where Google holds the signing key and you only manage the upload key — strongly recommended; enable it on first upload.)

Create `android/key.properties` (this is **gitignored** — never commit):

```properties
storePassword=...
keyPassword=...
keyAlias=chillgym
storeFile=C:/Users/Encall/chillgym-upload.jks
```

Add `key.properties` and `*.jks` to `.gitignore` if not already.

Wire signing into `android/app/build.gradle.kts`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    signingConfigs {
        create("release") {
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 3.5. Build the App Bundle (the file Play wants)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`. This is what you upload to Play Console — *not* an APK.

If you want an APK for sideloading testers:

```bash
flutter build apk --release --split-per-abi
```

## 4. Local iOS build & test (requires macOS)

If you don't have a Mac, **skip to section 6 (Codemagic)** and let CI build your IPA. You can still TestFlight test on a real iPhone without ever touching a Mac yourself.

If you do have/borrow a Mac:

```bash
# On the Mac, after cloning:
cd ios && pod install && cd ..
open ios/Runner.xcworkspace      # NOT .xcodeproj
```

In Xcode:
- Select the **Runner** target → **Signing & Capabilities**.
- Sign in with your Apple Developer account.
- Pick your **Team** in the dropdown.
- Verify **Bundle Identifier** matches the one you registered (`com.encall27.chillgym`).
- Add the **HealthKit** capability if you want the Health integration to work.
- Add the **Push Notifications** capability if you want server-side pushes (local notifications don't need this, but it's worth setting up early).

Run on iOS Simulator:
```bash
open -a Simulator
flutter run -d iPhone
```

Run on a real iPhone:
1. Plug it in via USB.
2. Trust the Mac when iOS prompts.
3. `flutter devices` lists it.
4. `flutter run -d <device-id>`.
5. On the iPhone: **Settings → General → VPN & Device Management → trust your developer profile.**

Build a release IPA:
```bash
flutter build ipa --release
# Output: build/ios/ipa/ChillGym.ipa
```

That IPA goes through **Transporter.app** (Mac App Store) or `xcrun altool --upload-app` to reach App Store Connect.

## 5. CI/CD with GitHub Actions

This is the workflow you want once renaming is done. Save as `.github/workflows/release.yml`:

```yaml
name: Release builds
on:
  push:
    tags: ['v*']           # tag a release: git tag v0.1.0 && git push --tags
  workflow_dispatch:

jobs:
  android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'
          channel: 'stable'
      - name: Decode keystore
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode \
            > android/app/chillgym-upload.jks
      - name: Write key.properties
        run: |
          cat > android/key.properties <<EOF
          storePassword=${{ secrets.ANDROID_STORE_PASSWORD }}
          keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}
          keyAlias=chillgym
          storeFile=chillgym-upload.jks
          EOF
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v4
        with:
          name: chillgym-android
          path: build/app/outputs/bundle/release/app-release.aab

  ios:
    runs-on: macos-latest        # requires macOS runner
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'
          channel: 'stable'
      - name: Install Apple certs & profile
        uses: apple-actions/import-codesign-certs@v3
        with:
          p12-file-base64: ${{ secrets.APPLE_DIST_CERT_P12 }}
          p12-password: ${{ secrets.APPLE_DIST_CERT_PASSWORD }}
      - uses: apple-actions/download-provisioning-profiles@v3
        with:
          bundle-id: com.encall27.chillgym
          issuer-id: ${{ secrets.APPLE_APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPLE_APPSTORE_KEY_ID }}
          api-private-key: ${{ secrets.APPLE_APPSTORE_PRIVATE_KEY }}
      - run: cd ios && pod install
      - run: flutter pub get
      - run: flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
      - uses: actions/upload-artifact@v4
        with:
          name: chillgym-ios
          path: build/ios/ipa/*.ipa
      - name: Upload to TestFlight
        run: |
          xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios \
            --apiKey ${{ secrets.APPLE_APPSTORE_KEY_ID }} \
            --apiIssuer ${{ secrets.APPLE_APPSTORE_ISSUER_ID }}
```

**Secrets to add in GitHub → Settings → Secrets and variables → Actions:**

| Secret | How to get |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\Users\Encall\chillgym-upload.jks"))` in PowerShell |
| `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_PASSWORD` | The passwords you chose in §3.4 |
| `APPLE_DIST_CERT_P12` | Export your distribution cert from Keychain.app as `.p12`, base64 it |
| `APPLE_DIST_CERT_PASSWORD` | The password you set on the .p12 |
| `APPLE_APPSTORE_ISSUER_ID`, `APPLE_APPSTORE_KEY_ID`, `APPLE_APPSTORE_PRIVATE_KEY` | Generated in App Store Connect → Users and Access → Keys → App Store Connect API |

For an **IPA without a Mac at all**, **Codemagic** is dramatically simpler — connect the GitHub repo, paste your bundle ID, upload your distribution cert, and it builds + uploads to TestFlight on every push. Their default Flutter workflow handles certificates without the `import-codesign-certs` dance.

## 6. Google Play Store launch

1. **Play Console → Create app**: name "ChillGym", default language English, app type "App", "Free", accept declarations.
2. **App content** (left sidebar) — work top-to-bottom; nothing else unblocks until these are green:
   - Privacy policy URL (from §1.8)
   - App access (no login needed today, declare so)
   - Ads (none)
   - Content rating questionnaire — answer truthfully, you'll get an "Everyone" rating
   - Target audience and content (13+ minimum since you log fitness data)
   - Data safety form: declare that you collect Photos, Health/fitness, App activity → all stored only on device, never shared, no third parties
3. **Production → Create new release** (or use **Internal testing** track first, recommended):
   - Upload `app-release.aab`
   - Release name: `0.1.0 (1)`
   - Release notes per language
4. **Store listing**:
   - Short description (80 char), full description (4000 char)
   - 2 screenshots minimum per device type (phone, tablet) — generate with `flutter screenshot` from a release build, or use the simulator
   - Feature graphic (1024×500)
   - App icon (512×512)
5. **Submit for review.** Internal testing approves in minutes; Production typically takes 1–7 days for first review, then hours for updates.

For ongoing OTA-ish updates, Play handles distribution automatically once approved — bump `versionCode` and `versionName`, push to a track, and users get the update.

## 7. Apple App Store launch

1. **App Store Connect → My Apps → +**: bundle ID picker shows the one you registered, name "ChillGym", primary language English, SKU `chillgym-001` (any unique string).
2. **App Information**: category Health & Fitness, content rights, age rating questionnaire.
3. **Pricing & Availability**: Free, all territories.
4. **App Privacy**: same disclosures as Play (data on device only, no third-party sharing). Apple is stricter — they may flag image_picker access; the usage strings you added in §1.4 are what they reference.
5. **Build**: arrives via TestFlight after the CI upload completes processing (~10–30 min). Add it to a TestFlight **internal group** (you + up to 99 testers, no Apple review needed) for quick iteration.
6. **TestFlight external testing** (>100 testers) requires Apple review — usually <24h.
7. **App Store submission**:
   - Screenshots: 6.7" iPhone (mandatory) and 5.5" iPhone (mandatory if you don't show iPhone-only behaviour). Generate via `flutter run` on Simulator → ⌘S.
   - Description, keywords, support URL, marketing URL, promotional text
   - Build version: pick the latest TestFlight build
   - **Submit for review** — first review takes 1–3 days, often faster.

Common rejection causes for a fitness logger like this:
- Missing usage strings (you've fixed that)
- Crashes on first launch in their environment (they always test in Airplane mode + new account)
- "App is too similar to a website" — having both web and native is fine, but the native build needs to do something the web can't (you have local notifications and Health Connect, that's enough)
- Privacy policy URL returns 404

## 7.5. Storage decision: Firebase vs. local-only

This is the single biggest call you have to make before the first store submission, because it affects the data-safety form, the privacy policy, and the user-facing description in both stores. Locking it in late means re-doing those copies.

### What's stored today

| Type | Volume | Where it lives now |
|---|---|---|
| Sessions, sets, templates, custom exercises, prefs | Small (< 1 MB / year) | `shared_preferences` (KV strings) |
| Bodyweight entries, body progress photos | Photos: ~50–200 KB each, web compresses to 800px @ q50 | localStorage on web; Documents dir on iOS/Android |
| Exercise photos attached to entries | Same | Same |
| Share-card PNGs | Generated on demand, written to Documents on save | Local only |

Nothing leaves the device. There is no backend.

### Option A — keep it local-only (recommended for v1)

**Pros**
- Zero backend cost. Zero ops. No outage page to write.
- Privacy story is the simplest possible: "We don't collect anything." Both stores rubber-stamp this on the data-safety form.
- No latency, no offline mode to design, no auth UX. Ship in days not weeks.
- iOS / Android automatic backups (iCloud / Google Drive) cover the data on most users' devices for free.

**Cons**
- **Cross-device** doesn't work — install on iPhone and iPad, you have two separate logs. This is the #1 thing users will email you about.
- **Web localStorage cap is ~5 MB.** Body progress photos blow this fast. You already hit the QuotaExceededError once. On native it's effectively unlimited but you'll still want a rotation policy eventually.
- A factory reset / app delete = data gone unless they used your JSON export.

**What you must add before shipping local-only**
1. **Visible JSON export + import** in Profile → Data (already wired). Make sure the Import flow is documented in the App Store description so users feel safe.
2. **Switch web body-photo storage from localStorage to IndexedDB** via `idb_shim` or `hive` w/ web. localStorage is the wrong tool for blob storage. Until that's done, web users will hit quota errors after ~10 photos. *This is in the v1 missing list and should land before public launch.*
3. **Make "Backup before delete" a confirmation dialog** on Profile → Delete all data, with a one-tap "Export first" button.

### Option B — add Firebase (Auth + Firestore + Storage)

What you'd actually get for the work:

| Sub-product | What it stores | Free tier (Spark plan, no card) | Realistic monthly cost at 1k DAU |
|---|---|---|---|
| Firebase Auth | User identity (Apple / Google / Email) | Unlimited users | Free |
| Cloud Firestore | Sessions, sets, templates, prefs, bodyweight | 1 GiB / 50k reads / 20k writes per day | ~US$5–20 |
| Firebase Storage | Photos (exercise, body, share cards) | 5 GB / 1 GB-day egress | ~US$10–30 |
| Cloud Functions (optional) | Server-side logic, webhooks | 125k invocations/day | Free at this scale |

So at "couple hundred users" the cost is **$0**. You only start paying once you have real traction, and at that point hosting is the cheapest part of your problem.

**When Firebase actually pays off**
- Multi-device sync — user installs on phone + tablet and sees the same data within seconds.
- Recovery — phone lost or stolen, user signs in on new device, history is intact.
- Sharing — you'll eventually want gym buddies to see each other's PRs. That requires a server.
- Analytics — you can see "30% of users never reach session 3" and fix it.
- A foundation for **paid features later** — Firebase Auth makes a "ChillGym Pro" subscription a config change, not a rebuild.

**What it costs you in engineering time**
- 1 day: Auth wiring (Apple + Google + Email/Password, sign-in screen, sign-out, account deletion route). Apple **requires** an in-app account-deletion flow if you have sign-in.
- 1 day: Firestore schema + repositories. Replace `SharedPreferences*Repository` with `Firestore*Repository` behind the same interfaces — your domain layer doesn't change.
- 1 day: Storage migration for photos. Upload on save, signed download URLs cached on the client.
- 0.5 day: Offline cache via `cloud_firestore`'s built-in persistence (free, just turn it on).
- 0.5 day: Privacy policy rewrite + data-safety form for both stores, listing Firebase as your processor.

So roughly **a focused week** to migrate from local-only to Firebase, end-to-end.

### My recommendation

**Ship v1 local-only. Plan Firebase for v1.1.**

Reasoning:
- Your first 50 users won't use ChillGym on multiple devices. They'll use it on one phone for two months and decide whether to keep using it. Cross-device sync solves a problem they don't have yet.
- You **already** have a deferred SSO milestone in this plan (§8.3). Layer Firebase Auth + Firestore on at the same time you ship SSO — you'd be doing the auth wiring anyway, and migrating data while a stable schema is hardening is much safer than migrating mid-iteration.
- A privacy story of "nothing leaves your phone" is the strongest possible launch positioning. Don't dilute it on day one.
- The local-only IndexedDB swap (web body-photos) is genuinely needed regardless — fix that first.

Concrete phasing:

| Milestone | Storage | Privacy line on stores |
|---|---|---|
| **v1.0** (now → first launch) | Local-only, IndexedDB for web blobs | "All data stored on your device. We don't collect anything." |
| **v1.1** (≈4 weeks after launch) | Firebase Auth + Firestore for tabular data; Firebase Storage for photos | "Optional account; data sync via Firebase. You can stay fully local if you don't sign in." |
| **v1.2+** | + Cloud Functions for shareable PR feeds, in-app subscription | — |

### If you decide to go Firebase now anyway

Do these in order:

1. `flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage`
2. `flutterfire configure` — interactive CLI, registers the Android + iOS apps with Firebase, drops `google-services.json` and `GoogleService-Info.plist` in the right places.
3. Enable **App Check** (`flutter pub add firebase_app_check`) before going live. Without it, anyone with your `google-services.json` (which ships in your APK) can hit your Firestore directly.
4. Write Firestore **security rules**: only the authenticated user can read/write `users/{uid}/...`. Default-deny everything else. Test with the Firestore emulator before deploying.
5. Add the **account-deletion** route (Apple's rule 5.1.1(v)). Firebase has a one-call delete; surface a "Delete my account" button in Profile that signs out and removes the doc tree.

## 8. Post-launch

### 8.1. Crash reporting

Add **Sentry** (recommended) or Firebase Crashlytics before going public. Sentry has a clean Flutter SDK and is free up to 5k events/month. Five-minute setup; you'll see every release-build crash with stack traces.

### 8.2. Update cadence

- **Hot updates** (Dart-only fixes): not allowed by Apple's policy. You ship a new binary every time.
- **Bumping**: increment `versionCode`/`build_number` every upload, `versionName` per user-facing release.
- **Tag-driven release**: `git tag v0.1.1 && git push --tags` triggers the Actions workflow → both stores get an artifact. Manual promotion in each console (you don't usually want auto-publish to production).

### 8.3. What's still missing for v1.0 (separate from this plan, but track them)

- SSO + cloud sync (deferred per your earlier decision)
- IndexedDB-backed image storage on web (so body photos don't blow localStorage)
- Real screenshots and a marketing description for the listings
- A small landing page on `chillgym.app` with privacy policy + store badges

## 9. Suggested order of execution

| Day | Task |
|---|---|
| 1 | §1 repo cleanup: rename, usage strings, icon, splash, privacy URL |
| 2 | §3 Android: keystore, AAB build, install on your phone in release mode |
| 3 | Sign up Apple Developer + Google Play Console (start the clocks) |
| 4 | §5 GitHub Actions Android pipeline working end-to-end |
| 5 | Codemagic or GitHub Actions iOS pipeline → first TestFlight build |
| 6 | §6 Play internal testing track — invite yourself by Gmail, install via Play |
| 7 | §7 TestFlight install, fix anything that surfaces |
| 8–10 | Screenshots, store copy, privacy policy, submit to both stores |

Most of the time-sink isn't code — it's the store paperwork (screenshots, privacy policy wording, content rating quizzes). Block out a focused half-day for it.

## 10. Apple App Store review preflight (2026-05-09 audit)

This is a code-and-config audit of the current build against the App Store
Review Guidelines that fitness loggers most often trip over. Items marked
**FIXED** were applied in this commit; items marked **TODO** still need your
hand before submission.

### 10.1. Permissions & Info.plist — **FIXED**

Added all required usage strings to `ios/Runner/Info.plist`. Without these the
app *will* hard-crash on the first photo pick / Health toggle / notification
prompt and the binary will be auto-rejected:

- `NSCameraUsageDescription` — for `image_picker` camera capture
- `NSPhotoLibraryUsageDescription` — for `image_picker` gallery selection
- `NSPhotoLibraryAddUsageDescription` — for share-card "Save" → photos
- `NSHealthShareUsageDescription` + `NSHealthUpdateUsageDescription` — for
  the optional Apple Health integration

Also added:

- `CFBundleDisplayName` / `CFBundleName` → `ChillGym` (was the dev name)
- `LSApplicationCategoryType` → `public.app-category.healthcare-fitness`
- `CFBundleLocalizations` → `[en, zh-Hans, zh-Hant]` so the App Store listing
  can advertise translations
- `ITSAppUsesNonExemptEncryption=false` → skips the export-compliance form on
  every release. Safe because we use only HTTPS / OS-level cipher use.

Note `NSUserNotificationsUsageDescription` is **not** a real Apple key. iOS
shows a generic "App would like to send you notifications" prompt and reads
nothing from Info.plist. The deploymentPlan §1.4 recommendation was wrong on
that one and has been corrected.

### 10.2. Privacy manifest — **FIXED**

Added `ios/Runner/PrivacyInfo.xcprivacy`. Apple has required this since iOS 17
(May 2024) for any app that uses "required reason APIs" — Flutter and several
official plugins do, transitively. Declared:

- `NSPrivacyTracking = false`
- `NSPrivacyCollectedDataTypes = []` (we don't collect anything off-device)
- `NSPrivacyAccessedAPITypes` for `UserDefaults` (CA92.1), `FileTimestamp`
  (C617.1), `DiskSpace` (E174.1), `SystemBootTime` (35F9.1)

**Xcode integration TODO:** when you build on a Mac / Codemagic, drag
`PrivacyInfo.xcprivacy` into the Runner target in Xcode so it ends up in the
Copy-Bundle-Resources phase. Without that step the file won't ship inside the
.app and App Store Connect will warn on upload. Equivalent edit in
`ios/Runner.xcodeproj/project.pbxproj` if you prefer command-line.

### 10.3. Account deletion — OK for now

Apple's rule **5.1.1(v)** requires an in-app account deletion path *if the app
supports account creation*. ChillGym currently has no SSO, so the rule
doesn't apply. The existing **Profile → Data → Delete all data** flow already
satisfies the spirit of the guideline (clear path to remove user data).

When SSO lands in v1.1 you must add a "Delete my account" route that:
1. Signs out
2. Deletes the user's Firestore tree + Storage objects
3. Calls `FirebaseAuth.instance.currentUser?.delete()`

Reviewers test this. If "Delete account" buries account-deletion under more
than one tap from the main settings screen, the build is rejected.

### 10.4. Sign in with Apple — N/A

Apple's rule **4.8** requires "Sign in with Apple" to be offered if you also
offer Google / Facebook / other-third-party login. ChillGym has none of those
yet, so nothing to do. When SSO lands, Apple SSO must be one of the buttons
on iOS — non-negotiable.

### 10.5. Tracking & ATT — N/A

App Tracking Transparency (`NSUserTrackingUsageDescription`) is only needed
if you read the IDFA or share user-level identifiers off-device. ChillGym
does neither. **Do not** add an ATT prompt — Apple flags apps that ask for
tracking permission when they don't actually track.

### 10.6. Notifications — partially **FIXED**

- Localized the notification title and body strings (`notifRestTitle`,
  `notifRestBody`, `notifInactivityTitle`, `notifInactivityBody`). The
  hard-coded English strings were a 4.1 (App Completeness) risk in non-English
  markets.
- Added `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`
  to `android/app/src/main/AndroidManifest.xml` for Android 13+.

iOS needs no extra entitlement for *local* notifications (the kind we send).
If you ever add server pushes you'll need the `aps-environment` entitlement
in Xcode → Signing & Capabilities.

### 10.7. Storage of user content — code review

The four storage surfaces named in the user request:

| What | Where | Apple-relevant risk | Status |
|---|---|---|---|
| Session JSON, prefs | `shared_preferences` (UserDefaults on iOS) | Declared in PrivacyInfo (CA92.1). Stays on device. | OK |
| Body / exercise photos | App Documents directory via `path_provider` | Sandboxed — no permission needed for own-app file IO. | OK |
| Exported JSON backup | Documents dir + share sheet | User-initiated, flagged with `NSPhotoLibraryAddUsageDescription`. | OK |
| Generated share-card PNG | Captured from RepaintBoundary, written via `share_plus` | No camera / photo lib touched unless user taps Save. | OK |
| **Video generation** | Not implemented; deferred to phase 3 in README | Don't claim it in App Store description. The current app description must match reality or rejection per 2.3.1. | Watch |

### 10.8. Things to fix or watch before submission — **TODO**

1. **`google_fonts` runtime fetch.** The `google_fonts` package downloads
   Inter and Fraunces from Google's CDN on first launch. Apple has rejected
   apps for "downloading executable code at runtime"; fonts are in a grey
   area, but it does mean the first launch makes a network request and the
   `App Privacy → Data Linked to You` form may need to declare the IP address
   that Google's CDN sees.
   **Fix:** download the .ttf files once, drop them in `assets/fonts/`,
   declare them in `pubspec.yaml`, and set
   `GoogleFonts.config.allowRuntimeFetching = false`. This also eliminates
   the offline-first-launch bug where text renders in fallback fonts until
   network arrives.
2. **App icon.** Default Flutter icon is one of the most common rejection
   reasons. See §1.5.
3. **App Store description.** Don't describe features that are deferred.
   Current README mentions InBody OCR, image-recognition exercise tracking,
   and progress video generation as Phase 3 — none of these can appear in
   the App Store screenshots, description, or marketing copy for v1.
4. **Screenshot review.** Every screenshot must come from the real running
   app on the actual device size. Figma mockups → instant rejection per
   guideline 2.3.10.
5. **Privacy policy URL.** Required even if you collect nothing. See §1.8.
6. **TestFlight smoke test in Airplane mode + new account.** Apple reviewers
   always test offline first. Confirm nothing crashes when the OS denies
   every permission.
7. **Account-deletion path** must remain available even before SSO — keep
   "Delete all data" reachable from a max-2-tap path inside Profile.
8. **Health Connect manifest entries (Android).** When you turn on the Health
   integration on Android, you'll need the full block of
   `<uses-permission android:name="android.permission.health.*">` lines from
   the `health` package README plus the rationale activity. Out of scope
   for the iOS preflight.

### 10.9. What was changed in code (this commit)

- `ios/Runner/Info.plist` — usage strings, encryption flag, localizations,
  app category, display name
- `ios/Runner/PrivacyInfo.xcprivacy` — new privacy manifest (must be added
  to Xcode target's Copy Bundle Resources phase)
- `android/app/src/main/AndroidManifest.xml` — `POST_NOTIFICATIONS`
- `lib/services/notification_service.dart`, `notification_io.dart`,
  `notification_io_stub.dart` — accept localized title/body
- `lib/features/log/active_session_screen.dart` — pass localized strings
  through to scheduling
- `lib/state/active_session_controller.dart` — `finishSession` accepts
  localized inactivity strings
- `lib/l10n/app_en.arb`, `app_zh.arb`, `app_zh_HK.arb` — added 4 notification
  strings × 3 locales

### 10.10. Realistic outcome

With everything in this section applied, an Airplane-mode-clean,
no-claims-of-deferred-features build of ChillGym should clear App Review on
the first or second pass. Most rejections come from the boring things:
mismatched description, missing privacy URL, generic icon, hard-crash on
permission denial. The crash class is now closed.

---

**Owner:** Encall  
**Last updated:** 2026-05-09
