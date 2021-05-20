import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
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
    // We need to supply a navigator so that the contents of the bottom sheet
    // have access to an overlay (overlays are used by many material widgets
    // such as `TextField`.
    // Typically, the navigator would be fetched from `MaterialApp`, but
    // `BetterFeedback` should be used above `MaterialApp` in the widget tree so
    // that the nested navigation in navigate mode works properly.
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => Material(
          color: FeedbackTheme.of(context).feedbackSheetColor,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: getFeedback(onSubmit),
            ),
          ),
        ),
      ),
    );
  }
}
