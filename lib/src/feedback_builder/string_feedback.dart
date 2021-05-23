import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget simpleFeedbackBuilder(BuildContext context, OnSubmit onSubmit) =>
    StringFeedback(onSubmit: onSubmit);

/// A form that prompts the user for feedback with a single text field.
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
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            children: <Widget>[
              Text(
                FeedbackLocalizations.of(context).feedbackDescriptionText,
                maxLines: 2,
                style: FeedbackTheme.of(context).bottomSheetDescriptionStyle,
              ),
              TextField(
                key: const Key('text_input_field'),
                maxLines: 2,
                minLines: 2,
                controller: controller,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        TextButton(
          key: const Key('submit_feedback_button'),
          child: Text(
            FeedbackLocalizations.of(context).submitButtonText,
          ),
          onPressed: () => widget.onSubmit(controller.text),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
