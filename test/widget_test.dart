import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chillgym/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App boots into the Home tab with hero + next-up cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChillGymApp()));
    await tester.pumpAndSettle();

    // The streak hero card always shows the ON FIRE eyebrow (prefixed by a
    // bullet glyph), the NEXT UP card the NEXT UP eyebrow — both present
    // even with zero history.
    expect(find.textContaining('ON FIRE'), findsOneWidget);
    expect(find.textContaining('NEXT UP'), findsOneWidget);
  });

  testWidgets('Tapping Calendar tab shows the heatmap legend',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChillGymApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('LESS'), findsOneWidget);
    expect(find.text('MORE'), findsOneWidget);
  });

  testWidgets('Starting a fresh session from the next-up card opens Active',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChillGymApp()));
    await tester.pumpAndSettle();

    // No templates seeded → next-up card headline reads "Open session".
    await tester.tap(find.text('Open session'));
    await tester.pumpAndSettle();

    expect(find.text('Active workout'), findsOneWidget);
    expect(find.text('Add exercise'), findsOneWidget);
  });
}
