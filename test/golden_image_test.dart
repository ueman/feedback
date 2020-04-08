import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

void main() {
  group('Golden Image Test', () {
    testWidgets(' closed feedback', (tester) async {
      await setGoldenImageSurfaceSize(tester);

      final widget = BetterFeedback(
        child: const MyTestApp(),
        onFeedback: (
          BuildContext context,
          String feedbackText,
          Uint8List feedbackScreenshot,
        ) {},
      );

      await tester.pumpWidget(widget);
      await expectLater(find.byType(BetterFeedback),
          matchesGoldenFile('golden_images/closed_feedback.png'));
    });

    testWidgets(' open feedback', (tester) async {
      await setGoldenImageSurfaceSize(tester);

      final widget = BetterFeedback(
        child: const MyTestApp(),
        onFeedback: (
          BuildContext context,
          String feedbackText,
          Uint8List feedbackScreenshot,
        ) {},
      );

      await tester.pumpWidget(widget);

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      await expectLater(find.byType(BetterFeedback),
          matchesGoldenFile('golden_images/open_feedback.png'));
    });
  });
}

/// use a portrait format for golden images
Future<void> setGoldenImageSurfaceSize(WidgetTester tester) async {
  // iPhone 11 Pro Max, portrait
  const double width = 414;
  const double height = 896;
  const double pixelRation = 3;

  tester.binding.window.devicePixelRatioTestValue = pixelRation;
  await tester.binding.setSurfaceSize(const Size(width, height));
}
