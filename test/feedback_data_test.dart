import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackData ', () {
    test(' assertions', () {
      // controller must not be null
      expect(() {
        FeedbackData(
          controller: null,
          child: Container(),
        );
      }, throwsAssertionError);

      // child must not be null
      expect(() {
        FeedbackData(
          controller: FeedbackController(),
          child: null,
        );
      }, throwsAssertionError);
    });
  });
}
