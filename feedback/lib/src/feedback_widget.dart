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

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({
    super.key,
    required this.child,
    required this.isFeedbackVisible,
    required this.drawColors,
    required this.mode,
    required this.pixelRatio,
    required this.feedbackBuilder,
  }) : assert(
          // This way, we can have a const constructor
          // ignore: prefer_is_empty
          drawColors.length > 0,
          'There must be at least one color to draw',
        );

  final bool isFeedbackVisible;
  final FeedbackMode mode;
  final double pixelRatio;
  final Widget child;
  final List<Color> drawColors;

  final FeedbackBuilder feedbackBuilder;

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

@visibleForTesting
class FeedbackWidgetState extends State<FeedbackWidget>
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

  late FeedbackMode mode = widget.mode;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

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
    if (mode == FeedbackMode.draw && widget.isFeedbackVisible) {
      if (painterController.getStepCount() > 0) {
        painterController.undo();
      } else {
        BetterFeedback.of(context).hide();
      }
      return true;
    }
    return false;
  }

  @override
  void didUpdateWidget(FeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update feedback mode with the initial value
    mode = widget.mode;
    if (oldWidget.isFeedbackVisible != widget.isFeedbackVisible &&
        oldWidget.isFeedbackVisible == false) {
      // Feedback is now visible,
      // start animation to show it.
      _controller.forward();
    }

    if (oldWidget.isFeedbackVisible != widget.isFeedbackVisible &&
        oldWidget.isFeedbackVisible == true) {
      // Feedback is no longer visible,
      // reverse animation to hide it.
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
                        mode == FeedbackMode.draw && widget.isFeedbackVisible,
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
                                  BetterFeedback.of(context).hide();
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
                            child: FeedbackBottomSheet(
                              key: const Key('feedback_bottom_sheet'),
                              feedbackBuilder: widget.feedbackBuilder,
                              onSubmit: (
                                String feedback, {
                                Map<String, dynamic>? extras,
                              }) async {
                                await _sendFeedback(
                                  context,
                                  BetterFeedback.of(context).onFeedback!,
                                  screenshotController,
                                  feedback,
                                  widget.pixelRatio,
                                  extras: extras,
                                );
                                painterController.clear();
                              },
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

  @visibleForTesting
  static Future<void> sendFeedback(
    OnFeedbackCallback onFeedbackSubmitted,
    ScreenshotController controller,
    String feedback,
    double pixelRatio, {
    Duration delay = const Duration(milliseconds: 2000),
    Map<String, dynamic>? extras,
  }) async {
    // Wait for the keyboard to be closed, and then proceed
    // to take a screenshot
    await Future.delayed(
      delay,
      () async {
        // Take high resolution screenshot
        final screenshot = await controller.capture(
          pixelRatio: pixelRatio,
          delay: const Duration(milliseconds: 0),
        );

        // Give it to the developer
        // to do something with it.
        await onFeedbackSubmitted(
          UserFeedback(
            text: feedback,
            screenshot: screenshot,
            extra: extras,
          ),
        );
      },
    );
  }

  static Future<void> _sendFeedback(
    BuildContext context,
    OnFeedbackCallback onFeedbackSubmitted,
    ScreenshotController controller,
    String feedback,
    double pixelRatio, {
    Duration delay = const Duration(milliseconds: 200),
    bool showKeyboard = false,
    Map<String, dynamic>? extras,
  }) async {
    if (!showKeyboard) {
      _hideKeyboard(context);
    }
    await sendFeedback(
      onFeedbackSubmitted,
      controller,
      feedback,
      pixelRatio,
      delay: delay,
      extras: extras,
    );

    // Close feedback mode
    // ignore: use_build_context_synchronously
    BetterFeedback.of(context).hide();
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
