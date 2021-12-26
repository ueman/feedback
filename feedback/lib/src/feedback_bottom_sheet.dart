// ignore_for_file: public_member_api_docs

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'feedback_widget.dart';

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
    // We need to supply an overlay so that the contents of the bottom sheet
    // have access to it. Overlays are used by many material widgets
    // such as `TextField` and `DropDownButton`. Typically, this would be
    // provided by `MaterialApp`, but `BetterFeedback` is above `MaterialApp` in
    // the widget tree.
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            if (FeedbackTheme.of(context).sheetIsDraggable) {
              return _DraggableSheetProgressTracker(
                builder: (sheetProgress) {
                  return _DraggableFeedbackSheet(
                    sheetProgress: sheetProgress,
                    child: feedbackBuilder(context, onSubmit),
                  );
                },
              );
            }
            return feedbackBuilder(context, onSubmit);
          },
        ),
      ],
    );
  }
}

class _DraggableFeedbackSheet extends StatelessWidget {
  const _DraggableFeedbackSheet({
    Key? key,
    required this.sheetProgress,
    required this.child,
  }) : super(key: key);

  final ValueListenable<double> sheetProgress;
  final Widget child;

  double get animationProgress => Curves.easeIn.transform(sheetProgress.value);

  @override
  Widget build(BuildContext context) {
    final FeedbackThemeData feedbackTheme = FeedbackTheme.of(context);
    // We need to convert form `Alignment`'s uses -1 to 1 scale to
    // `DraggableScrollableSheet`'s 0 to 1 scale.
    final double scaleOriginY = (kScaleOrigin.y + 1) / 2;
    final double safeArea = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height +
        MediaQuery.of(context).viewInsets.bottom;
    print(scaleOriginY);
    print(scaleOriginY);
    print(scaleOriginY);
    print(scaleOriginY);
    //   1 - (scaleOriginY + (1-scaleOriginY)*scaleFactor) - ((padding + safeArea)/screenHeight)
    final double collapsedHeight = 1 -
        (scaleOriginY +
            (1 - scaleOriginY) * kScaleFactor +
            (safeArea / screenHeight));
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
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          controller: controller,
                          child: const SizedBox(
                            height: 20,
                            child: Center(child: _DragHandle()),
                          ),
                        ),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              //controller.jumpTo(notification.metrics.pixels);
                              return false;
                            },
                            child: child,
                          ),
                        ),
                      ],
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

class _DraggableSheetProgressTracker extends StatelessWidget {
  _DraggableSheetProgressTracker({Key? key, required this.builder})
      : super(key: key);

  final Widget Function(ValueListenable<double>) builder;

  final ValueNotifier<double> _sheetProgress = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        _sheetProgress.value = (notification.extent - notification.minExtent) /
            (notification.maxExtent - notification.minExtent);
        return false;
      },
      child: builder(_sheetProgress),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({Key? key}) : super(key: key);

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
