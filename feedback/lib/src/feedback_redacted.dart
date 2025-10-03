import 'dart:ui';

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/feedback_redaction_controller.dart';
import 'package:flutter/material.dart';

/// A widget that applies a blur effect to its child when the [BetterFeedback]
/// draw mode is active or the screenshot is being taken. This is useful for
/// redacting sensitive information from the screenshot.
class FeedbackRedacted extends StatefulWidget {
  /// Creates a [FeedbackRedacted] widget.
  const FeedbackRedacted({required this.child, this.blurAmount = 5, super.key});

  /// The child widget to which the blur effect will be applied.
  final Widget child;

  /// The amount of blur to apply when redaction mode is enabled.
  final double blurAmount;

  @override
  State<FeedbackRedacted> createState() => _FeedbackRedactedState();
}

class _FeedbackRedactedState extends State<FeedbackRedacted> {
  FeedbackRedactionController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure that the listener is only added once.
    controller ??= BetterFeedback.of(context).redactionController
      ..addListener(onUpdateOfController);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.removeListener(onUpdateOfController);
  }

  @override
  Widget build(BuildContext context) {
    if (controller?.isRedacted == true) {
      // Re-wrapping the child instead of just changing the sigma values makes
      // testing easier.
      return ImageFiltered(
        key: const Key('redaction_blur'),
        imageFilter: ImageFilter.blur(
          sigmaX: widget.blurAmount,
          sigmaY: widget.blurAmount,
        ),
        child: widget.child,
      );
    }

    return widget.child;
  }

  void onUpdateOfController() {
    setState(() {});
  }
}
