import 'package:feedback/feedback.dart';
import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/controls_column.dart';
import 'package:feedback/src/feedback_bottom_sheet.dart';
import 'package:feedback/src/feedback_mode.dart';
import 'package:feedback/src/paint_on_background.dart';
import 'package:feedback/src/painter.dart';
import 'package:feedback/src/scale_and_clip.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

typedef FeedbackButtonPress = void Function(BuildContext context);

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({
    Key? key,
    required this.child,
    required this.isFeedbackVisible,
    required this.drawColors,
    required this.mode,
    required this.pixelRatio,
    required this.feedbackBuilder,
  })  : assert(
          // This way, we can have a const constructor
          // ignore: prefer_is_empty
          drawColors.length > 0,
          'There must be at least one color to draw',
        ),
        super(key: key);

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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(FeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(begin: 1, end: 0.65)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    final animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    final controlsHorizontalAlignment = Tween<double>(begin: 1.4, end: .95)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ColoredBox(
          color: FeedbackTheme.of(context).background,
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ScaleAndClip(
                  scale: scaleAnimation.value,
                  alignmentProgress: animation.value,
                  child: Screenshot(
                    controller: screenshotController,
                    child: PaintOnChild(
                      controller: painterController,
                      isPaintingActive:
                          mode == FeedbackMode.draw && widget.isFeedbackVisible,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(
                  controlsHorizontalAlignment.value,
                  -0.7,
                ),
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
              // only display if feedback is visible or this widget is still
              // animating out
              if (widget.isFeedbackVisible || !animation.isDismissed)
                Positioned(
                  key: const Key('feedback_bottom_sheet'),
                  left: 0,
                  // Make sure the input field is always visible,
                  // especially if the keyboard is shown
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 0,
                  height: MediaQuery.of(context).size.height *
                      // height should be screen size minus the bottom edge of
                      // screenshot widget:
                      //   1 - (scaleOrigin + height*scaleFactor)
                      (1 - (.35 / 2 + 1.65 / 2 * .65)),
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(animation),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: FeedbackBottomSheet(
                        feedbackBuilder: widget.feedbackBuilder,
                        onSubmit: (
                          String feedback, {
                          Map<String, dynamic>? extras,
                        }) async {
                          await _sendFeedback(
                            context,
                            FeedbackData.of(context).onFeedback!,
                            screenshotController,
                            feedback,
                            widget.pixelRatio,
                            extras: extras,
                          );
                          painterController.clear();
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @internal
  @visibleForTesting
  static Future<void> sendFeedback(
    OnFeedbackCallback onFeedbackSubmitted,
    ScreenshotController controller,
    String feedback,
    double pixelRatio, {
    Duration delay = const Duration(milliseconds: 200),
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
        onFeedbackSubmitted(UserFeedback(
          text: feedback,
          screenshot: screenshot,
          extra: extras,
        ));
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
    FeedbackData.of(context).hide();
  }

  static void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
