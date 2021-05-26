import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.collapsedHeight,
  }) : super(key: key);

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit onSubmit;
  final double collapsedHeight;

  @override
  Widget build(BuildContext context) {
    if (!FeedbackTheme.of(context).enableBottomSheetExpansion) {
      return SizedBox(
        height: collapsedHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          child: Material(
            color: FeedbackTheme.of(context).feedbackSheetColor,
            child: _sheetContent(context),
          ),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        minChildSize: collapsedHeight / MediaQuery.of(context).size.height,
        initialChildSize: collapsedHeight / MediaQuery.of(context).size.height,
        builder: (context, controller) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
            child: Material(
              color: FeedbackTheme.of(context).feedbackSheetColor,
              child: Column(
                children: [
                  _DragHandle(controller: controller),
                  Expanded(
                      child: _sheetContent(context, controller: controller)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sheetContent(BuildContext context, {ScrollController? controller}) {
    // We need to supply a navigator so that the contents of the
    // bottom sheet have access to an overlay (overlays are used by
    // many material widgets such as `TextField` and `DropDownButton`.
    // Typically, the navigator would be provided by a `MaterialApp`,
    // but `BetterFeedback` is used above `MaterialApp` in the widget
    // tree so that the nested navigation in navigate mode works
    // properly.
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => feedbackBuilder(context, onSubmit, controller),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: SizedBox(
        // Make drag handle the same height as the top safe area
        height: MediaQuery.of(context).padding.top,
        width: double.infinity,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
