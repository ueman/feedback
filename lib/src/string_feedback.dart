import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget getStringFeedback(OnSubmit onSubmit) =>
    StringFeedback(onSubmit: onSubmit);

/// A form and submit button that prompts the user for feedback with a single
/// text field.
/// This is the default feedback widget used by [BetterFeedback].
class StringFeedback extends StatefulWidget {
  const StringFeedback({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final OnSubmit onSubmit;

  @override
  _StringFeedbackState createState() => _StringFeedbackState();
}

class _StringFeedbackState extends State<StringFeedback> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ColoredBox(
          color: FeedbackTheme.of(context).feedbackSheetColor,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  FeedbackLocalizations.of(context).feedbackDescriptionText,
                  maxLines: 2,
                  style: FeedbackTheme.of(context).bottomSheetDescriptionStyle,
                ),
                Material(
                  child: TextField(
                    maxLines: 2,
                    minLines: 2,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                TextButton(
                  key: const Key('submit_feedback_button'),
                  child: Text(
                    FeedbackLocalizations.of(context).submitButtonText,
                  ),
                  onPressed: () {
                    widget.onSubmit(controller.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
