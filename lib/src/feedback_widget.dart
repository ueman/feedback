library feeback;

import 'package:feeback/src/controls_column.dart';
import 'package:feeback/src/feedback.dart';
import 'package:feeback/src/feedback_functions.dart';
import 'package:feeback/src/paint_on_background.dart';
import 'package:feeback/src/painter.dart';
import 'package:feeback/src/scale_and_clip.dart';
import 'package:feeback/src/screenshot.dart';
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

class _FeedbackWidgetState extends State<FeedbackWidget> {
  PainterController painterController;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController();

  bool isNavigatingActive = true;

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
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isFeedbackVisible) {
      return widget.child;
    }

    //return Builder();
    // TODO(ueman): look for a better solution
    // it would be really nice if we would not need a
    // MaterialApp nor a Scaffold here
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Screenshot(
                controller: screenshotController,
                child: ScaleAndClip(
                  child: PaintOnBackground(
                    controller: painterController,
                    isPaintingActive: !isNavigatingActive,
                    child: widget.child,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(.95, -0.9),
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
      ),
      bottomSheet: Container(
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
            // Through using a Builder we can supply an approprioat
            // BuildContext to the callback function.
            Builder(
              builder: (innerContext) {
                return FlatButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    final screenshot =
                        await screenshotController.capture(pixelRatio: 3);
                    final feedbackText = textEditingController.text;
                    widget.feedback(innerContext, feedbackText, screenshot);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
