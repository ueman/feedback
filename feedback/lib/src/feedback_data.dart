// ignore_for_file: public_member_api_docs

import 'package:feedback/src/feedback_controller.dart';
import 'package:flutter/material.dart';

class FeedbackData<T, R> extends InheritedWidget {
  const FeedbackData({
    super.key,
    required super.child,
    required this.controller,
  });

  final FeedbackController<T, R> controller;

  @override
  bool updateShouldNotify(FeedbackData<T, R> oldWidget) {
    return oldWidget.controller != controller;
  }
}
