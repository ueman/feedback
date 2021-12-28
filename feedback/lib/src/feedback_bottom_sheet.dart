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
  }) : super(key: key);

  final FeedbackSheetBuilder feedbackSheetBuilder;
  final OnSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    // We need to supply an overlay so that the contents of the bottom sheet
    // have access to it. Overlays are used by many material widgets
    // such as `TextField` and `DropDownButton`. Typically, this would be
    // provided by `MaterialApp`, but `BetterFeedback` is above `MaterialApp` in
    // the widget tree.
    return Overlay(
      key: UniqueKey(),
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            print(feedbackSheetBuilder);
            if (FeedbackTheme.of(context).sheetIsDraggable) {
              return _DraggableFeedbackSheet(
                feedbackSheetBuilder: feedbackSheetBuilder,
                onSubmit: onSubmit,
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
          },
        ),
      ],
    );
  }
}

// This widget needs to be stateful so that `sheetProgress` persists across
// rebuilds.
// TODO(caseycrogers): replace `sheetProgress` with a direct reference to
//   `DraggableScrollableController` when the latter makes it into production.
//   See: https://github.com/flutter/flutter/pull/92440.
class _DraggableFeedbackSheet extends StatefulWidget {
  _DraggableFeedbackSheet({
    Key? key,
    required this.feedbackSheetBuilder,
    required this.onSubmit,
  }) : super(key: key);

  final FeedbackSheetBuilder feedbackSheetBuilder;
  final OnSubmit onSubmit;

  @override
  State<_DraggableFeedbackSheet> createState() =>
      _DraggableFeedbackSheetState();
}

class _DraggableFeedbackSheetState extends State<_DraggableFeedbackSheet> {
  final ValueNotifier<double> sheetProgress = ValueNotifier(0);

  double get animationProgress => Curves.easeIn.transform(sheetProgress.value);

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
            color: feedbackTheme.feedbackSheetColor,
          ),
          builder: (context, _, child) {
            return Opacity(
              // Use the curved progress value
              opacity: animationProgress,
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
              builder: (context, controller) {
                return ValueListenableBuilder<void>(
                  valueListenable: sheetProgress,
                  builder: (context, _, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * (1 - animationProgress)),
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
                          (controller.position
                                  as ScrollPositionWithSingleContext)
                              .applyUserOffset(
                                  notification.dragDetails!.delta.dy);
                        }
                        return false;
                      },
                      child: widget.feedbackSheetBuilder(
                        context,
                        widget.onSubmit,
                        controller,
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
