import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackBuilder,
    required this.onSubmit,
  }) : super(key: key);

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    // We need to supply a navigator so that the contents of the bottom sheet
    // have access to an overlay (overlays are used by many material widgets
    // such as `TextField` and `DropDownButton`.
    // Typically, the navigator would be provided by a `MaterialApp`, but
    // `BetterFeedback` is used above `MaterialApp` in the widget tree so that
    // the nested navigation in navigate mode works properly.
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => Material(
          color: FeedbackTheme.of(context).feedbackSheetColor,
          child: feedbackBuilder(context, onSubmit),
        ),
      ),
    );
  }
}
