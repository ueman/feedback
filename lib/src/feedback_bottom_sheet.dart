import 'package:feedback/src/better_feedback.dart';
import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.getFeedback,
    required this.onSubmit,
  }) : super(key: key);

  final GetFeedback getFeedback;
  final OnSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return getFeedback(onSubmit);
          },
        ),
      ],
    );
  }
}
