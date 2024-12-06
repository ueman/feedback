// ignore_for_file: public_member_api_docs

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/feedback_form_controller.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/back_button_interceptor.dart';
import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet<T, R> extends StatelessWidget {
  const FeedbackBottomSheet({
    super.key,
    required this.route,
    required this.screenshotController,
    required this.feedbackBuilder,
    required this.sheetProgress,
  });

  final T route;
  final ScreenshotController screenshotController;
  final FeedbackBuilder<T, R> feedbackBuilder;
  final ValueNotifier<double> sheetProgress;

  @override
  Widget build(BuildContext context) {
    if (FeedbackTheme.of(context).sheetIsDraggable) {
      return DraggableScrollableActuator(
        child: _DraggableFeedbackSheet<T, R>(
          route: route,
          screenshotController: screenshotController,
          feedbackBuilder: feedbackBuilder,
          sheetProgress: sheetProgress,
        ),
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
          child: Navigator(
            onGenerateRoute: (_) {
              return MaterialPageRoute<void>(
                builder: (_) => feedbackBuilder(
                  context,
                  route,
                  FeedbackFormController<R>(screenshotController),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DraggableFeedbackSheet<T, R> extends StatefulWidget {
  const _DraggableFeedbackSheet({
    required this.route,
    required this.screenshotController,
    required this.feedbackBuilder,
    required this.sheetProgress,
  });

  final T route;
  final ScreenshotController screenshotController;
  final FeedbackBuilder<T, R> feedbackBuilder;
  final ValueNotifier<double> sheetProgress;

  @override
  State<_DraggableFeedbackSheet<T, R>> createState() =>
      _DraggableFeedbackSheetState();
}

class _DraggableFeedbackSheetState<T, R> extends State<_DraggableFeedbackSheet<T, R>> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_onBackButton, priority: 0);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_onBackButton);
    super.dispose();
  }

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
          child: DraggableScrollableSheet(
            controller: BetterFeedback.of<T, R>(context).sheetController,
            snap: true,
            minChildSize: collapsedHeight,
            initialChildSize: collapsedHeight,
            builder: (context, scrollController) {
              return ValueListenableBuilder<void>(
                valueListenable: widget.sheetProgress,
                builder: (context, _, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          20 * (1 - widget.sheetProgress.value)),
                    ),
                    child: child,
                  );
                },
                child: Material(
                  color: FeedbackTheme.of(context).feedbackSheetColor,
                  // A `ListView` makes the content here disappear.
                  child: DefaultTextEditingShortcuts(
                    child: Navigator(
                      onGenerateRoute: (_) {
                        return MaterialPageRoute<void>(
                          builder: (_) => widget.feedbackBuilder(
                            context,
                            widget.route,
                            FeedbackFormController(widget.screenshotController, scrollController),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _onBackButton() {
    if (widget.sheetProgress.value != 0) {
      // TODO(caseycrogers): replace `reset` with `animateTo` when
      //   `DraggableScrollableController` reaches production
      if (DraggableScrollableActuator.reset(context)) {
        widget.sheetProgress.value = 0;
        return true;
      }
    }
    return false;
  }
}
