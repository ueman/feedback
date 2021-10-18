import 'package:feedback/src/feedback_controller.dart';
import 'package:flutter/material.dart';

class FeedbackData extends InheritedWidget {
  const FeedbackData({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  final FeedbackController controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }
}
