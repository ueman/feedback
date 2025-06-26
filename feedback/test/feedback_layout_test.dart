import 'dart:math';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

class MockScreenshotController extends ScreenshotController {
  @override
  Future<Uint8List> capture({
    double pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) {
    return Future.value(Uint8List.fromList(
      List.generate(pow(4, pixelRatio).ceil(), (number) => 1),
    ));
  }
}

void main() {
  group('FeedbackLayoutDelegate', () {
    testWidgets('screenshot positioned at zero when feedback is closed',
        (tester) async {
      final widget = BetterFeedback(
        child: const MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Get the feedback widget state
      final feedbackWidgetState =
          tester.state<FeedbackWidgetState>(find.byType(FeedbackWidget));
      feedbackWidgetState.screenshotController = MockScreenshotController();

      // Initially, feedback is not visible
      // Find the screenshot widget - it's wrapped in a LayoutId
      final screenshotFinder = find.byWidgetPredicate(
        (widget) => widget is LayoutId && widget.id == 'screenshot_id',
      );

      expect(screenshotFinder, findsOneWidget);

      // Get the position - when feedback is closed, it should be at (0,0)
      final RenderBox screenshotBox =
          tester.firstRenderObject(screenshotFinder);
      final Offset initialPosition = screenshotBox.localToGlobal(Offset.zero);
      expect(initialPosition, equals(Offset.zero));

      // Open feedback
      final openFeedbackButton = find.text('open feedback');
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      // Verify feedback is open
      expect(find.byKey(const Key('feedback_bottom_sheet')), findsOneWidget);

      // Close feedback by tapping the close button
      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // After closing, verify the screenshot is back at Offset.zero
      // This is what the fix ensures
      final screenshotFinderAfterClose = find.byWidgetPredicate(
        (widget) => widget is LayoutId && widget.id == 'screenshot_id',
      );
      expect(screenshotFinderAfterClose, findsOneWidget);

      final RenderBox screenshotBoxAfterClose =
          tester.firstRenderObject(screenshotFinderAfterClose);
      final Offset positionAfterClose =
          screenshotBoxAfterClose.localToGlobal(Offset.zero);

      // This verifies the fix prevents the layout offset issue on Android devices
      expect(positionAfterClose, equals(Offset.zero));
    });

    testWidgets('screenshot fills screen when feedback closed', (tester) async {
      final widget = BetterFeedback(
        child: const MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Find the screenshot widget
      final screenshotFinder = find.byWidgetPredicate(
        (widget) => widget is LayoutId && widget.id == 'screenshot_id',
      );

      expect(screenshotFinder, findsOneWidget);

      // Get the size of the screenshot widget
      final RenderBox screenshotBox =
          tester.firstRenderObject(screenshotFinder);
      final Size screenSize =
          MediaQuery.of(tester.element(find.byType(MyTestApp))).size;

      // When feedback is not displayed, screenshot should fill the entire screen
      expect(screenshotBox.size, equals(screenSize));

      // And it should be positioned at (0, 0)
      final Offset position = screenshotBox.localToGlobal(Offset.zero);
      expect(position, equals(Offset.zero));
    });

    testWidgets('layout delegate performs layout correctly', (tester) async {
      // This test verifies the core fix - that performLayout calls
      // positionChild(_screenshotId, Offset.zero) when displayFeedback is false

      final widget = BetterFeedback(
        child: const MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final feedbackWidgetState =
          tester.state<FeedbackWidgetState>(find.byType(FeedbackWidget));

      // Feedback is initially not visible
      expect(feedbackWidgetState.widget.isFeedbackVisible, false);

      // Find screenshot and verify it's at origin
      final screenshotFinder = find.byWidgetPredicate(
        (widget) => widget is LayoutId && widget.id == 'screenshot_id',
      );

      final RenderBox screenshotBox =
          tester.firstRenderObject(screenshotFinder);
      expect(screenshotBox.localToGlobal(Offset.zero), Offset.zero);

      // Open and close feedback to test the fix
      await tester.tap(find.text('open feedback'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify screenshot returns to origin (the fix)
      final RenderBox screenshotBoxAfter =
          tester.firstRenderObject(screenshotFinder);
      expect(screenshotBoxAfter.localToGlobal(Offset.zero), Offset.zero);
    });
  });
}
