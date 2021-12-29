// ignore_for_file: public_member_api_docs

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';

import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackSheetBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  }) : super(key: key);

  final FeedbackSheetBuilder feedbackSheetBuilder;
  final OnSubmit onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  Widget build(BuildContext context) {
    // We need to supply an navigator so that the contents of the bottom sheet
    // have access to it. Overlays are used by many material widgets
    // such as `TextField` and `DropDownButton`. Typically, this would be
    // provided by `MaterialApp`, but `BetterFeedback` is above `MaterialApp` in
    // the widget tree.
    if (FeedbackTheme.of(context).sheetIsDraggable) {
      return _DraggableFeedbackSheet(
        feedbackSheetBuilder: feedbackSheetBuilder,
        onSubmit: onSubmit,
        sheetProgress: sheetProgress,
      );
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            FeedbackTheme.of(context).feedbackSheetHeight,
        child: Material(
          color: FeedbackTheme.of(context).feedbackSheetColor,
          // Pass a null scroll controller because the sheet is not drag
          // enabled.
          child: feedbackSheetBuilder(context, onSubmit, null),
        ),
      ),
    );
  }
}

class _DraggableFeedbackSheet extends StatelessWidget {
  const _DraggableFeedbackSheet({
    Key? key,
    required this.feedbackSheetBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  }) : super(key: key);

  final FeedbackSheetBuilder feedbackSheetBuilder;
  final OnSubmit onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  Widget build(BuildContext context) {
    final FeedbackThemeData feedbackTheme = FeedbackTheme.of(context);
    final MediaQueryData query = MediaQuery.of(context);
    // We need to recalculate the collapsed height to account for the safe area
    // at the top and the keyboard (if present).
    final double collapsedHeight = feedbackTheme.feedbackSheetHeight *
        query.size.height /
        (query.size.height - query.padding.top - query.viewInsets.bottom);
    return Column(
      children: [
        ValueListenableBuilder<void>(
          valueListenable: sheetProgress,
          child: Container(
            height: MediaQuery.of(context).padding.top,
            color: FeedbackTheme.of(context).feedbackSheetColor,
          ),
          builder: (context, _, child) {
            return Opacity(
              // Use the curved progress value
              opacity: sheetProgress.value,
              child: child,
            );
          },
        ),
        Expanded(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              // Convert the extent into a fraction representing progress
              // between min and max.
              sheetProgress.value =
                  (notification.extent - notification.minExtent) /
                      (notification.maxExtent - notification.minExtent);
              return false;
            },
            child: DraggableScrollableSheet(
              snap: true,
              minChildSize: collapsedHeight,
              initialChildSize: collapsedHeight,
              builder: (context, scrollController) {
                return ValueListenableBuilder<void>(
                  valueListenable: sheetProgress,
                  builder: (context, _, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * (1 - sheetProgress.value)),
                      ),
                      child: child,
                    );
                  },
                  child: Material(
                    color: FeedbackTheme.of(context).feedbackSheetColor,
                    // A `ListView` makes the content here disappear.
                    child: NotificationListener<ScrollUpdateNotification>(
                      onNotification: (notification) {
                        if (notification.dragDetails != null) {
                          (scrollController.position
                                  as ScrollPositionWithSingleContext)
                              .applyUserOffset(
                                  notification.dragDetails!.delta.dy);
                        }
                        return false;
                      },
                      child: feedbackSheetBuilder(
                        context,
                        onSubmit,
                        scrollController,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
