import 'dart:math';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

void main() {
  group('BetterFeedback', () {
    testWidgets('can open feedback with default settings', (tester) async {
      final widget = BetterFeedback(
        child: Builder(
          builder: (context) {
            return const MyTestApp();
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // feedback is closed
      var userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.text('open feedback');
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      userInputFields = find.byKey(const Key('feedback_bottom_sheet'));
      final activeDrawingColor = getActiveColorButton();

      expect(userInputFields, findsOneWidget);
      expect(activeDrawingColor, findsNothing);
    });

    testWidgets('can open feedback in drawing mode', (tester) async {
      final widget = BetterFeedback(
        mode: FeedbackMode.draw,
        child: Builder(
          builder: (context) {
            return const MyTestApp();
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // feedback is closed
      var userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.text('open feedback');
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      userInputFields = find.byKey(const Key('feedback_bottom_sheet'));
      final activeDrawingColor = getActiveColorButton();

      expect(userInputFields, findsOneWidget);
      expect(activeDrawingColor.evaluate().length, 4);
    });

    testWidgets('can close feedback', (tester) async {
      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // feedback is closed
      final userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      expect(userInputFields, findsOneWidget);

      // close feedback again
      final closeFeedbackButton =
          find.byKey(const Key('close_controls_column'));
      await tester.tap(closeFeedbackButton);
      await tester.pumpAndSettle();

      expect(userInputFields, findsNothing);
    });

    testWidgets('feedback callback gets called', (tester) async {
      String? submittedText;
      Uint8List? submittedScreenshot;

      final widget = BetterFeedback(
        child: MyTestApp(
          onFeedback: (text, screenshot) {
            submittedText = text as String;
            submittedScreenshot = screenshot;
          },
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final feedbackWidgetState =
          tester.state<FeedbackWidgetState>(find.byType(FeedbackWidget));
      feedbackWidgetState.screenshotController = MockScreenshotController();

      // feedback is closed
      final userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      // write text
      final textField = find.byKey(const Key('text_input_field'));
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'This app is lame, 2/10.');
      await tester.pumpAndSettle();

      // submit feedback
      final submitFeedbackButton =
          find.byKey(const Key('submit_feedback_button'));

      await tester.tap(submitFeedbackButton);
      await tester.pumpAndSettle();

      expect(submittedText, 'This app is lame, 2/10.');
      expect(submittedScreenshot, isNotNull);
    });
  });

  testWidgets('feedback callback gets called with custom feedback content',
      (tester) async {
    _TestFeedback? submittedFeedback;

    final widget = BetterFeedback(
      child: MyTestApp(
        onFeedback: (feedback, screenshot) {
          submittedFeedback = feedback as _TestFeedback;
        },
      ),
      getFeedback: (onSubmit) => TextButton(
        key: const Key('custom_submit_feedback_button'),
        onPressed: () {
          onSubmit(_TestFeedback(1, 'garbage!'));
        },
        child: Container(),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    final feedbackWidgetState =
        tester.state<FeedbackWidgetState>(find.byType(FeedbackWidget));
    feedbackWidgetState.screenshotController = MockScreenshotController();

    // feedback is closed
    final userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

    expect(userInputFields, findsNothing);

    // open feedback
    final openFeedbackButton = find.byKey(const Key('open_feedback'));
    await tester.tap(openFeedbackButton);
    await tester.pumpAndSettle();

    // submit feedback
    final submitFeedbackButton =
        find.byKey(const Key('custom_submit_feedback_button'));

    await tester.tap(submitFeedbackButton);
    await tester.pumpAndSettle();

    expect(submittedFeedback, _TestFeedback(1, 'garbage!'));
  });

  test('feedback sendFeedback with high resolution', () async {
    var callbackWasCalled = false;
    final screenshotController = MockScreenshotController();
    void onFeedback(
      String feedback,
      Uint8List? feedbackScreenshot,
    ) {
      expect(feedback, 'Hello World!');
      expect(feedbackScreenshot?.length, 64);
      callbackWasCalled = true;
    }

    await FeedbackWidgetState.sendFeedback(
      onFeedback,
      screenshotController,
      'Hello World!',
      3,
      delay: const Duration(seconds: 0),
    );
    expect(callbackWasCalled, true);
  });

  test('feedback sendFeedback with low resolution', () async {
    var callbackWasCalled = false;
    final screenshotController = MockScreenshotController();
    void onFeedback(
      String feedback,
      Uint8List? feedbackScreenshot,
    ) {
      expect(feedback, 'Hello World!');
      expect(feedbackScreenshot?.length, 4);
      callbackWasCalled = true;
    }

    await FeedbackWidgetState.sendFeedback(
      onFeedback,
      screenshotController,
      'Hello World!',
      1,
      delay: const Duration(seconds: 0),
    );
    expect(callbackWasCalled, true);
  });
}

class MockScreenshotController extends ScreenshotController {
  @override
  Future<Uint8List> capture(
      {double pixelRatio = 1,
      Duration delay = const Duration(milliseconds: 20)}) {
    return Future.value(Uint8List.fromList(
      List.generate(pow(4, pixelRatio).ceil(), (number) => 1),
    ));
  }
}

Finder getActiveColorButton() {
  return find.byWidgetPredicate((widget) {
    if (widget is IconButton) {
      final IconButton selectButton = widget;
      return selectButton.color != null && selectButton.onPressed != null;
    } else {
      return false;
    }
  });
}

class _TestFeedback {
  _TestFeedback(this.rating, this.feedback);

  int rating;
  String feedback;

  @override
  bool operator ==(Object other) =>
      other is _TestFeedback &&
      rating == other.rating &&
      feedback == other.feedback;

  @override
  int get hashCode => rating.hashCode + feedback.hashCode;
}
