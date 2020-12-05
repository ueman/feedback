import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

typedef OnSubmit = void Function(BuildContext context, String feedback);

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  FeedbackBottomSheet({Key? key, required this.onSubmit})
      : _controller = TextEditingController(),
        super(key: key);

  final OnSubmit onSubmit;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
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
                          FeedbackLocalizations.of(context)
                              .feedbackDescriptionText,
                          maxLines: 2,
                          style: FeedbackTheme.of(context)
                              .bottomSheetDescriptionStyle,
                        ),
                        Material(
                          child: TextField(
                            maxLines: 2,
                            minLines: 2,
                            controller: _controller,
                          ),
                        ),
                        FlatButton(
                          key: const Key('submit_feedback_button'),
                          child: Text(
                            FeedbackLocalizations.of(context).submitButtonText,
                          ),
                          onPressed: () {
                            onSubmit(context, _controller.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
