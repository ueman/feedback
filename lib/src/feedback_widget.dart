library feeback;

import 'package:feedback/src/controls_column.dart';
import 'package:feedback/src/feedback.dart';
import 'package:feedback/src/feedback_functions.dart';
import 'package:feedback/src/paint_on_background.dart';
import 'package:feedback/src/painter.dart';
import 'package:feedback/src/scale_and_clip.dart';
import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({
    Key key,
    @required this.child,
    @required this.feedback,
    @required this.isFeedbackVisible,
  })  : assert(child != null),
        assert(feedback != null),
        assert(isFeedbackVisible != null),
        super(key: key);

  final bool isFeedbackVisible;
  final OnFeedbackCallback feedback;
  final Widget child;

  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget>
    with SingleTickerProviderStateMixin {
  PainterController painterController;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController();

  bool isNavigatingActive = true;

  AnimationController _controller;

  PainterController create() {
    final PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.drawColor = Colors.red;
    return controller;
  }

  @override
  void initState() {
    super.initState();
    painterController = create();

    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 300),
    );
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
    assert(
        widget.child.key is GlobalKey,
        'The child needs a GlobalKey,'
        ' so that the app doesn\'t loose its state while switching '
        'between normal use and feedback view.');

    // Possible optimization:
    // If feedback is invisible just build widget.child
    // without the whole feedback foo.
    //if (!widget.isFeedbackVisible) {
    //  return widget.child;
    //}

    final scaleAnimation = Tween<double>(begin: 1, end: 0.7)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    final animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    final controlsHorizontalAlignment = Tween<double>(begin: 1.3, end: .95)
        .chain(CurveTween(curve: Curves.easeInSine))
        .animate(_controller);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Screenshot(
                  controller: screenshotController,
                  child: ScaleAndClip(
                    scale: scaleAnimation.value,
                    alignmentProgress: animation.value,
                    child: PaintOnBackground(
                      controller: painterController,
                      isPaintingActive: !isNavigatingActive,
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
                  onColorChanged: (color) {
                    painterController.drawColor = color;
                  },
                  onUndo: () {
                    painterController.undo();
                  },
                  onClearDrawing: () {
                    painterController.clear();
                  },
                  onModeChanged: (isDrawingActive) {
                    setState(() {
                      isNavigatingActive = isDrawingActive;
                    });
                  },
                  onCloseFeedback: () {
                    BetterFeedback.of(context).hide();
                  },
                ),
              ),
            ],
          ),
          bottomSheet: !widget.isFeedbackVisible
              ? null
              : Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text('What\'s wrong?'),
                      TextField(
                        maxLines: 2,
                        minLines: 2,
                        controller: textEditingController,
                      ),
                      Builder(
                        builder: (innerContext) {
                          // Through using a Builder we can supply an
                          // appropriate BuildContext to the callback function.
                          return FlatButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              // Take high res screenshot
                              final screenshot = await screenshotController
                                  .capture(pixelRatio: 3);

                              // Get feedback text
                              final feedbackText = textEditingController.text;

                              // Give it to the developer
                              // to do something with it.
                              widget.feedback(
                                innerContext,
                                feedbackText,
                                screenshot,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
