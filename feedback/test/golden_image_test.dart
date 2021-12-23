import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';
import 'test_utils/utils.dart';

void main() {
  group('Golden Image Test', () {
    testWidgets(' closed feedback', (tester) async {
      await setGoldenImageSurfaceSize(tester);

      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await expectLater(find.byType(BetterFeedback),
          matchesGoldenFile('golden_images/closed_feedback.png'));
    });

    testWidgets(' open feedback', (tester) async {
      await setGoldenImageSurfaceSize(tester);

      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      await expectLater(find.byType(BetterFeedback),
          matchesGoldenFile('golden_images/open_feedback.png'));
    });
  });
}
