// ignore_for_file: public_member_api_docs

import 'package:feedback/src/feedback_controller.dart';
import 'package:material_ui/material_ui.dart';

class FeedbackData extends InheritedWidget {
  const FeedbackData({
    super.key,
    required super.child,
    required this.controller,
  });

  final FeedbackController controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }
}
