import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

void main() {
  group('Golden Image Test', () {
    testWidgets(' closed feedback', (tester) async {
      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await expectLater(find.byType(BetterFeedback),
          matchesGoldenFile('golden_images/closed_feedback.png'));
    });

    group(' open feedback', () {
      testWidgets(' light mode', (tester) async {
        const widget = BetterFeedback(
          themeMode: ThemeMode.light,
          child: MyTestApp(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();
        // open feedback
        final openFeedbackButton = find.byKey(const Key('open_feedback'));
        await tester.tap(openFeedbackButton);
        await tester.pumpAndSettle();

        await expectLater(find.byType(BetterFeedback),
            matchesGoldenFile('golden_images/open_feedback_light_mode.png'));
      });

      testWidgets(' dark mode', (tester) async {
        const widget = BetterFeedback(
          themeMode: ThemeMode.dark,
          child: MyTestApp(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();
        // open feedback
        final openFeedbackButton = find.byKey(const Key('open_feedback'));
        await tester.tap(openFeedbackButton);
        await tester.pumpAndSettle();

        await expectLater(find.byType(BetterFeedback),
            matchesGoldenFile('golden_images/open_feedback_dark_mode.png'));
      });
    });
  });
}
