// ignore_for_file: public_member_api_docs

import 'package:feedback/feedback.dart';
import 'package:feedback/src/controls_column.dart';
import 'package:feedback/src/feedback_bottom_sheet.dart';
import 'package:feedback/src/paint_on_background.dart';
import 'package:feedback/src/painter.dart';
import 'package:feedback/src/scale_and_clip.dart';
import 'package:feedback/src/scale_and_fade.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/back_button_interceptor.dart';
import 'package:flutter/material.dart';

typedef FeedbackButtonPress = void Function(BuildContext context);

// See alignment.dart.
const kScaleOrigin = Alignment(-.3, -.65);
const kScaleFactor = .65;

class FeedbackWidget<T, R> extends StatefulWidget {
  const FeedbackWidget({
    super.key,
    required this.route,
    required this.isVisible,
    required this.child,
    required this.drawColors,
    required this.mode,
    required this.feedbackBuilder,
  }) : assert(
          // This way, we can have a const constructor
          // ignore: prefer_is_empty
          drawColors.length > 0,
          'There must be at least one color to draw',
        );

  // Note that we need both `isVisible` and `route` as route may be
  // null even if the feedback is visible as route is nullable.
  final T? route;
  final bool isVisible;
  final FeedbackMode mode;
  final Widget child;
  final List<Color> drawColors;

  final FeedbackBuilder<T, R> feedbackBuilder;

  @override
  FeedbackWidgetState<T, R> createState() => FeedbackWidgetState();
}

@visibleForTesting
class FeedbackWidgetState<T, R> extends State<FeedbackWidget<T, R>>
    with SingleTickerProviderStateMixin {
  // Padding to put around the interactive screenshot preview.
  final double padding = 8;

  // We use a ValueNotifier instead of just a double and `SetState` because
  // rebuilding the feedback sheet mid-drag cancels the drag.
  // TODO(caseycrogers): replace `sheetProgress` with a direct reference to
  //   `DraggableScrollableController` when the latter gets into production.
  //   See: https://github.com/flutter/flutter/pull/135366.
  ValueNotifier<double> sheetProgress = ValueNotifier(0);

  @visibleForTesting
  late PainterController painterController = create();

  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController();

  late final FeedbackController<T, R> feedbackController = BetterFeedback.of<T, R>(context);

  late FeedbackMode mode = widget.mode;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  T? lastSeenRoute;

  PainterController create() {
    final controller = PainterController();
    controller.thickness = 5.0;

    controller.drawColor = widget.drawColors[0];
    return controller;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backButtonIntercept);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    BackButtonInterceptor.remove(backButtonIntercept);
  }

  @visibleForTesting
  bool backButtonIntercept() {
    if (mode == FeedbackMode.draw && feedbackController.isVisible) {
      if (painterController.getStepCount() > 0) {
        painterController.undo();
      } else {
        BetterFeedback.of<T, R>(context).hide();
      }
      return true;
    }
    return false;
  }

  @override
  void didUpdateWidget(FeedbackWidget<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update feedback mode with the initial value
    mode = widget.mode;
    if (oldWidget.isVisible != widget.isVisible &&
        oldWidget.isVisible == false) {
      // Feedback is now visible,
      // start animation to show it and update the route.
      lastSeenRoute = widget.route;
      _controller.forward();
    }

    if (oldWidget.isVisible != widget.isVisible &&
        oldWidget.isVisible == true) {
      // Feedback is no longer visible,
      // reverse animation to hide it.
      // Note that we do not clear the last seen route as the bottom sheet will
      // still need to reference it as it animates out.
      _controller.reverse();
      // Reset the sheet progress so the fade is no longer applied.
      sheetProgress.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    final FeedbackThemeData feedbackThemeData = FeedbackTheme.of(context);
    final ThemeData theme = ThemeData(
        brightness: feedbackThemeData.brightness,
        cardColor: feedbackThemeData.feedbackSheetColor,
        colorScheme: feedbackThemeData.colorScheme);

    // We need to supply a overlay because `TextField` and other widgets that
    // could be used in the bottom feedback sheet require an overlay widget ancestor.
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Theme(
            data: theme,
            child: Material(
              color: FeedbackTheme.of(context).background,
              child: AnimatedBuilder(
                animation: _controller,
                // Place the screenshot here so that the widget tree isn't being
                // arbitrarily rebuilt.
                child: Screenshot(
                  controller: screenshotController,
                  child: PaintOnChild(
                    controller: painterController,
                    isPaintingActive:
                        mode == FeedbackMode.draw && feedbackController.isVisible,
                    child: widget.child,
                  ),
                ),
                builder: (context, screenshotChild) {
                  return CustomMultiChildLayout(
                    delegate: _FeedbackLayoutDelegate(
                      displayFeedback: !animation.isDismissed,
                      query: MediaQuery.of(context),
                      sheetFraction: feedbackThemeData.feedbackSheetHeight,
                      animationProgress: animation.value,
                    ),
                    children: [
                      LayoutId(
                        id: _screenshotId,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: ScaleAndFade(
                            progress: sheetProgress,
                            minScale: .7,
                            // If opacity reaches zero, flutter will stop
                            // drawing the child widget which breaks the
                            // screenshot.
                            minOpacity: .01,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final size = MediaQuery.of(context).size;
                              return OverflowBox(
                                // Allow the screenshot to overflow to the full
                                // screen size and then scale it down to meet
                                // it's parent's constraints.
                                maxWidth: size.width,
                                maxHeight: size.height,
                                child: ScaleAndClip(
                                  progress: animation.value,
                                  // Scale down to fit the constraints.
                                  // `_FeedbackLayoutDelegate` ensures that the
                                  // constraints are the same aspect ratio as
                                  // the query size.
                                  scaleFactor:
                                      constraints.maxWidth / size.width,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return screenshotChild!;
                                  }),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      if (!animation.isDismissed)
                        LayoutId(
                          id: _controlsColumnId,
                          child: Padding(
                            padding: EdgeInsets.only(left: padding),
                            child: ScaleAndFade(
                              progress: sheetProgress,
                              minScale: .7,
                              child: ControlsColumn(
                                mode: mode,
                                activeColor: painterController.drawColor,
                                colors: widget.drawColors,
                                onColorChanged: (color) {
                                  setState(() {
                                    painterController.drawColor = color;
                                  });
                                  _hideKeyboard(context);
                                },
                                onUndo: () {
                                  painterController.undo();
                                  _hideKeyboard(context);
                                },
                                onClearDrawing: () {
                                  painterController.clear();
                                  _hideKeyboard(context);
                                },
                                onControlModeChanged: (mode) {
                                  setState(() {
                                    this.mode = mode;
                                    _hideKeyboard(context);
                                  });
                                },
                                onCloseFeedback: () {
                                  _hideKeyboard(context);
                                  BetterFeedback.of<T, R>(context).hide();
                                },
                              ),
                            ),
                          ),
                        ),
                      if (!animation.isDismissed)
                        LayoutId(
                          id: _sheetId,
                          child: NotificationListener<
                              DraggableScrollableNotification>(
                            onNotification: (notification) {
                              sheetProgress.value = (notification.extent -
                                      notification.minExtent) /
                                  (notification.maxExtent -
                                      notification.minExtent);
                              return false;
                            },
                            child: FeedbackBottomSheet<T, R>(
                              key: const Key('feedback_bottom_sheet'),
                              // We need to forcibly cast to T to handle that current route is
                              // nullable and T itself may or may not be nullable
                              route: BetterFeedback.of<T, R>(context).currentRoute as T,
                              screenshotController: screenshotController,
                              feedbackBuilder: widget.feedbackBuilder,
                              sheetProgress: sheetProgress,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

const _screenshotId = 'screenshot_id';
const _controlsColumnId = 'controls_column_id';
const _sheetId = 'sheet_id';

class _FeedbackLayoutDelegate extends MultiChildLayoutDelegate {
  _FeedbackLayoutDelegate({
    required this.displayFeedback,
    required this.query,
    required this.sheetFraction,
    required this.animationProgress,
  });

  final bool displayFeedback;
  final MediaQueryData query;
  final double sheetFraction;
  final double animationProgress;

  double get safeAreaHeight => query.padding.top;

  double get keyboardHeight => query.viewInsets.bottom;

  double get screenHeight => query.size.height;

  // Fraction of screen height taken up by the screenshot preview.
  double get screenshotFraction =>
      1 - sheetFraction - (safeAreaHeight / screenHeight);

  double get screenshotHeight => screenshotFraction * screenHeight;

  @override
  void performLayout(Size size) {
    if (!displayFeedback) {
      layoutChild(_screenshotId, BoxConstraints.tight(size));
      return;
    }
    // Lay out the controls.
    final Size controlsSize = layoutChild(
      _controlsColumnId,
      BoxConstraints.loose(
        Size(size.width, screenshotHeight),
      ),
    );

    // Lay out screenshot preview, clipping the bounds to the correct aspect
    // ratio.
    final Size screenShotSize = layoutChild(
      _screenshotId,
      BoxConstraints.tight(
        // This clips our available space to the aspect ratio of the screenshot
        // preview.
        applyBoxFit(
          BoxFit.scaleDown,
          query.size,
          Size(
            size.width - animationProgress * (controlsSize.width),
            size.height - animationProgress * (size.height - screenshotHeight),
          ),
        ).destination,
      ),
    );

    // Position the screenshot and controls centered together.
    final double remainingWidth =
        query.size.width - screenShotSize.width - controlsSize.width;
    positionChild(
      _screenshotId,
      Offset(
        animationProgress * remainingWidth / 2,
        animationProgress * safeAreaHeight,
      ),
    );
    positionChild(
      _controlsColumnId,
      Offset(
        size.width -
            animationProgress * (controlsSize.width + remainingWidth / 2),
        safeAreaHeight + (screenshotHeight - controlsSize.height) / 2,
      ),
    );

    // Lay out sheet.
    final double sheetHeight = layoutChild(
      _sheetId,
      BoxConstraints.loose(
        Size(
          size.width,
          size.height - query.viewInsets.bottom,
        ),
      ),
    ).height;
    positionChild(
      _sheetId,
      Offset(
        0,
        size.height -
            animationProgress * (sheetHeight + query.viewInsets.bottom),
      ),
    );
  }

  @override
  bool shouldRelayout(covariant _FeedbackLayoutDelegate oldDelegate) {
    return query != oldDelegate.query ||
        sheetFraction != oldDelegate.sheetFraction ||
        animationProgress != oldDelegate.animationProgress;
  }
}
