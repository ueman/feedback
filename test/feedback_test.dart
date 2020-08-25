import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

void main() {
  group('BetterFeedback', () {
    testWidgets(' can open feedback', (tester) async {
      final widget = BetterFeedback(
        child: Builder(
          builder: (context) {
            return const MyTestApp();
          },
        ),
      );

      await tester.pumpWidget(widget);

      // feedback is closed
      var userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.text('open feedback');
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsOneWidget);
    });

    testWidgets(' can close feedback', (tester) async {
      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);

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

    // TODO(ju): figure out a way to test this
    testWidgets(' feedback callback gets called', (tester) async {
      const widget = BetterFeedback(
        child: MyTestApp(),
      );

      await tester.pumpWidget(widget);

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();

      // submit feedback
      final submitFeedbackButton =
          find.byKey(const Key('submit_feedback_button'));

      await tester.tap(submitFeedbackButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
    }, skip: true);
  });

  test(' feedback sendFeedback', () async {
    var callbackWasCalled = false;
    final textController = TextEditingController()..text = 'Hello World!';
    final screenshotController = MockScreenshotController();
    void onFeedback(
      String feedback,
      Uint8List feedbackScreenshot,
    ) {
      expect(feedback, 'Hello World!');
      expect(feedbackScreenshot, Uint8List.fromList([1, 1, 1, 1]));
      callbackWasCalled = true;
    }

    await FeedbackWidgetState.sendFeedback(
      null,
      onFeedback,
      screenshotController,
      textController,
      delay: const Duration(seconds: 0),
      showKeyboard: true,
    );

    expect(callbackWasCalled, true);
  });

  test(' assertions', () {
    // child must not be null
    expect(() {
      BetterFeedback(
        child: null,
      );
    }, throwsAssertionError);
  });
}

class MockScreenshotController implements ScreenshotController {
  @override
  Future<Uint8List> capture(
      {double pixelRatio = 1,
      Duration delay = const Duration(milliseconds: 20)}) {
    return Future.value(Uint8List.fromList([1, 1, 1, 1]));
  }
}
