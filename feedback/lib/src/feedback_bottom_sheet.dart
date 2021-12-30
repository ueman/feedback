// ignore_for_file: public_member_api_docs

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';

import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  }) : super(key: key);

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  Widget build(BuildContext context) {
    if (FeedbackTheme.of(context).sheetIsDraggable) {
      return _DraggableFeedbackSheet(
        feedbackBuilder: feedbackBuilder,
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
          child: feedbackBuilder(context, onSubmit, null),
        ),
      ),
    );
  }
}

class _DraggableFeedbackSheet extends StatefulWidget {
  const _DraggableFeedbackSheet({
    Key? key,
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.sheetProgress,
  }) : super(key: key);

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit onSubmit;
  final ValueNotifier<double> sheetProgress;

  @override
  State<_DraggableFeedbackSheet> createState() => _DraggableFeedbackSheetState();
}

class _DraggableFeedbackSheetState extends State<_DraggableFeedbackSheet> {
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
          valueListenable: widget.sheetProgress,
          child: Container(
            height: MediaQuery.of(context).padding.top,
            color: FeedbackTheme.of(context).feedbackSheetColor,
          ),
          builder: (context, _, child) {
            return Opacity(
              // Use the curved progress value
              opacity: widget.sheetProgress.value,
              child: child,
            );
          },
        ),
        Expanded(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              // Convert the extent into a fraction representing progress
              // between min and max.
              widget.sheetProgress.value =
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
                  valueListenable: widget.sheetProgress,
                  builder: (context, _, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * (1 - widget.sheetProgress.value)),
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
                      child: widget.feedbackBuilder(
                        context,
                        widget.onSubmit,
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
