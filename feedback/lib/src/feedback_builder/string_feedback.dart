import 'package:feedback/feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget simpleFeedbackBuilder(
  BuildContext context,
  OnSubmit? onSubmit,
  FeedbackFormController<UserFeedback> formController,
) =>
    StringFeedback(
      onSubmit: onSubmit,
      formController: formController,
    );

/// A form that prompts the user for feedback with a single text field.
/// This is the default feedback widget used by [BetterFeedback].
class StringFeedback extends StatefulWidget {
  /// Create a [StringFeedback].
  /// This is the default feedback bottom sheet, which is presented to the user.
  const StringFeedback({
    super.key,
    required this.onSubmit,
    required this.formController,
  });

  final OnSubmit? onSubmit;
  final FeedbackFormController<UserFeedback> formController;

  @override
  State<StringFeedback> createState() => _StringFeedbackState();
}

class _StringFeedbackState extends State<StringFeedback> {
  late TextEditingController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  Future<void>? submitting;

  FeedbackFormController<UserFeedback> get formController => widget.formController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: formController.scrollController,
                // Pad the top by 20 to match the corner radius if drag enabled.
                padding: EdgeInsets.fromLTRB(16, formController.scrollController != null ? 20 : 16, 16, 0),
                children: <Widget>[
                  Text(
                    FeedbackLocalizations.of(context).feedbackDescriptionText,
                    maxLines: 2,
                    style: FeedbackTheme.of(context).bottomSheetDescriptionStyle,
                  ),
                  TextField(
                    style: FeedbackTheme.of(context).bottomSheetTextInputStyle,
                    key: const Key('text_input_field'),
                    maxLines: 2,
                    minLines: 2,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) {
                      //print(_);
                    },
                  ),
                ],
              ),
              if (formController.scrollController != null) const FeedbackSheetDragHandle(),
            ],
          ),
        ),
        _FeedbackSubmitButton(
          onTap: () async {
            final Uint8List screenshot = await formController.takeScreenshot(context);
            if (!context.mounted) return;

            final feedback = UserFeedback(text: controller.text, screenshot: screenshot);
            await widget.onSubmit?.call(context, feedback);
            if (!context.mounted) return;

            BetterFeedback.simpleFeedbackOf(context).hide(feedback);
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _FeedbackSubmitButton extends StatefulWidget {
  const _FeedbackSubmitButton({required this.onTap});

  final AsyncCallback onTap;

  @override
  State<_FeedbackSubmitButton> createState() => _FeedbackSubmitButtonState();
}

class _FeedbackSubmitButtonState extends State<_FeedbackSubmitButton> {
  Future<void>? submitting;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: submitting,
      builder: (context, snap) {
        return TextButton(
          key: const Key('submit_feedback_button'),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            child: snap.connectionState == ConnectionState.waiting
                ? Container(
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: FeedbackTheme.of(context).activeFeedbackModeColor,
                    ),
                  )
                : Text(
                    FeedbackLocalizations.of(context).submitButtonText,
                    style: TextStyle(
                      color: FeedbackTheme.of(context).activeFeedbackModeColor,
                    ),
                  ),
          ),
          onPressed: () async {
            setState(() {
              submitting = widget.onTap();
            });
            await submitting;
          },
        );
      },
    );
  }
}
