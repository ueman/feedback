import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget simpleFeedbackSheetBuilder(
  BuildContext context,
  OnSubmit onSubmit,
  ScrollController? scrollController,
) =>
    StringFeedback(onSubmit: onSubmit, scrollController: scrollController);

/// A form that prompts the user for feedback with a single text field.
/// This is the default feedback widget used by [BetterFeedback].
class StringFeedback extends StatefulWidget {
  /// Create a [StringFeedback].
  /// This is the default feedback bottom sheet, which is presented to the user.
  const StringFeedback({
    Key? key,
    required this.onSubmit,
    required this.scrollController,
  }) : super(key: key);

  /// Should be called when the user taps the submit button.
  final OnSubmit onSubmit;

  /// A scroll controller that expands the sheet when it's attached to a
  /// scrollable widget and that widget is scrolled.
  ///
  /// Non null if the sheet is draggable.
  /// See: [FeedbackThemeData.sheetIsDraggable].
  final ScrollController? scrollController;

  @override
  _StringFeedbackState createState() => _StringFeedbackState();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              if (widget.scrollController != null)
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: FeedbackSheetDragHandle(),
                  ),
                ),
              ListView(
                controller: widget.scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: <Widget>[
                  Text(
                    FeedbackLocalizations.of(context).feedbackDescriptionText,
                    maxLines: 2,
                    style:
                        FeedbackTheme.of(context).bottomSheetDescriptionStyle,
                  ),
                  TextField(
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

/// A drag handle to be placed at the top of a draggable feedback sheet.
///
/// This is a purely visual element that communicates to users that the sheet
/// can be dragged to expand it.
///
/// It should be placed in a stack over the sheet's scrollable element so that
/// users can click and drag on it-the drag handle ignores pointers so the drag
/// will pass through to the scrollable beneath.
///
/// TODO(caseycrogers): Replace this with a pre-built drag handle above the
///   builder function once `DraggableScrollableController` is available in
///   production.
///   See: https://github.com/flutter/flutter/pull/92440.
class FeedbackSheetDragHandle extends StatelessWidget {
  /// Create a drag handle.
  const FeedbackSheetDragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
