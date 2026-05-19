# ChillGym App Icons

Production PNGs for iOS App Store and Google Play.

## Files

| File | Size | Purpose |
|---|---|---|
| `icon_ios_1024.png` | 1024×1024 | iOS App Store / `flutter_launcher_icons` `image_path` |
| `icon_play_512.png` | 512×512 | Google Play store listing icon |
| `icon_android_foreground_1024.png` | 1024×1024 | Android adaptive icon **foreground** (transparent, 66% safe zone) |
| `icon_android_background_1024.png` | 1024×1024 | Android adaptive icon **background** (solid amber gradient) |

## Flutter Launcher Icons

Drop the iOS PNG into `assets/icon/chillgym_icon.png` and the foreground/background into the same folder, then in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon_ios_1024.png"
  remove_alpha_ios: true
  adaptive_icon_background: "assets/icon/icon_android_background_1024.png"
  adaptive_icon_foreground: "assets/icon/icon_android_foreground_1024.png"
```

Then run:

```bash
dart run flutter_launcher_icons
```

## Brand color

Primary background: **#E0A82E** (warm amber). Used as the `adaptive_icon_background` solid if you prefer a flat color over the gradient PNG.
