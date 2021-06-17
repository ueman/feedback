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
      expect(activeDrawingColor.evaluate().length, 4);
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

    testWidgets('can open feedback in navigation mode', (tester) async {
      final widget = BetterFeedback(
        mode: FeedbackMode.navigate,
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
          onFeedback: (feedback) {
            submittedText = feedback.text;
            submittedScreenshot = feedback.screenshot;
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

    testWidgets('feedback callback gets called with custom feedback content',
        (tester) async {
      UserFeedback? submittedFeedback;

      final widget = BetterFeedback(
        child: MyTestApp(
          onFeedback: (feedback) {
            submittedFeedback = feedback;
          },
        ),
        feedbackBuilder: (context, onSubmit) => TextButton(
          key: const Key('custom_submit_feedback_button'),
          onPressed: () {
            onSubmit('garbage!', extras: <String, dynamic>{'rating': 1});
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

      expect(submittedFeedback?.text, 'garbage!');
      expect(submittedFeedback?.extra, {'rating': 1});
    });

    testWidgets('screenshot navigation works', (tester) async {
      const widget = BetterFeedback(
        mode: FeedbackMode.navigate,
        child: MyTestApp(),
      );
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));
      await tester.tap(openFeedbackButton);
      await tester.pumpAndSettle();
      final userInputFields = find.byKey(const Key('feedback_bottom_sheet'));

      expect(userInputFields, findsOneWidget);

      // verify that we're in navigate mode
      final activeDrawingColor = getActiveColorButton();
      expect(activeDrawingColor.evaluate().length, 0);

      final testAppState =
          tester.state<MyTestPageState>(find.byType(MyTestPage));
      expect(testAppState.counter, 0);

      final incrementButton = find.byKey(const Key('increment_button'));
      expect(incrementButton, findsOneWidget);

      await tester.tap(incrementButton);
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      expect(testAppState.counter, 2);

      final changePage = find.byKey(const Key('change_page'));
      expect(changePage, findsOneWidget);
      await tester.tap(changePage);
      await tester.pumpAndSettle();

      Finder newPage = find.byKey(const Key('new_page'));
      expect(newPage, findsOneWidget);

      // ideally we should test pop behavior using the system back button but
      // flutter testing does not support simulated back button presses
      testAppState.popPage();
      await tester.pumpAndSettle();
      newPage = find.byKey(const Key('new_page'));
      expect(newPage, findsNothing);
    });
  });

  test('feedback sendFeedback with high resolution', () async {
    var callbackWasCalled = false;
    final screenshotController = MockScreenshotController();
    void onFeedback(UserFeedback feedback) {
      expect(feedback.text, 'Hello World!');
      expect(feedback.screenshot.length, 64);
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
      UserFeedback feedback,
    ) {
      expect(feedback.text, 'Hello World!');
      expect(feedback.screenshot.length, 4);
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
