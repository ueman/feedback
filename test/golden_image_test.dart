import 'dart:io';

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
      await expectLater(
          find.byType(BetterFeedback),
          matchesGoldenFile(
              'golden_images/closed_feedback-$_platformString.png'));
    }, skip: _platformString == null);

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

      await expectLater(
          find.byType(BetterFeedback),
          matchesGoldenFile(
              'golden_images/open_feedback-$_platformString.png'));
    }, skip: _platformString == null);
  });
}

String? get _platformString {
  if (Platform.isWindows) {
    return 'windows';
  }
  if (Platform.isMacOS) {
    return 'macos';
  }
  return null;
}

// TODO(caseycrogers): the `skip` argument for [group] is currently ignored by
// TestWidget. This bug was fixed in Flutter version 2.1 which is not yet out on
// stable. Once it is, we should remove the `skip` arguments from `testWidgets`
// and move them to `group`.
// See: https://github.com/flutter/flutter/pull/76174
// ignore: unused_element
String get _skipMessage =>
    'Golden image tests are platform specific. $_platformString is not '
    'currently supported. Please create a PR against '
    'https://github.com/ueman/feedback to add golden images for your platform.';
