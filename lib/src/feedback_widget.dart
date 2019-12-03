library feeback;

import 'dart:typed_data';

import 'package:feeback/src/controls_column.dart';
import 'package:feeback/src/feedback_adapter.dart';
import 'package:feeback/src/feedback_controller.dart';
import 'package:feeback/src/paint_on_background.dart';
import 'package:feeback/src/painter.dart';
import 'package:feeback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnFeedbackCallback = void Function(String, Uint8List);

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({
    Key key,
    @required this.child,
    this.onFeedback,
    this.feedbackAdapter,
    @required this.controller,
  })  : assert(child != null),
        assert(onFeedback != null || feedbackAdapter != null),
        assert(controller != null),
        super(key: key);

  final OnFeedbackCallback onFeedback;
  final FeedbackController controller;
  final FeedbackAdapter feedbackAdapter;

  final Widget child;

  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  PainterController controller;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController();

  bool isNavigatingActive = true;
  bool isFeedbackViewActive = false;

  PainterController create() {
    final PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.drawColor = Colors.red;
    return controller;
  }

  @override
  void initState() {
    super.initState();
    controller = create();
    widget.controller.addListener(onUpdateOfController);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onUpdateOfController);
  }

  void onUpdateOfController() {
    setState(() {
      isFeedbackViewActive = widget.controller.isFeedbackViewActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isFeedbackViewActive) {
      return widget.child;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Screenshot(
                  controller: screenshotController,
                  child: _ScaleAndClip(
                    child: PaintOnBackground(
                      controller: controller,
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
                    controller.drawColor = color;
                  },
                  onUndo: () {
                    controller.undo();
                  },
                  onClearDrawing: () {
                    controller.clear();
                  },
                  onModeChanged: (isDrawingActive) {
                    setState(() {
                      isNavigatingActive = isDrawingActive;
                    });
                  },
                  onCloseFeedback: () {
                    setState(() {
                      isFeedbackViewActive = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        bottomSheet: SafeArea(
          child: Container(
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
                FlatButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    final screenshot =
                        await screenshotController.capture(pixelRatio: 3);
                    final feedbackText = textEditingController.text;
                    if (widget.feedbackAdapter != null) {
                      widget.feedbackAdapter
                          .onFeedback(feedbackText, screenshot);
                    } else {
                      widget.onFeedback(feedbackText, screenshot);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaleAndClip extends StatelessWidget {
  const _ScaleAndClip({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: const Alignment(-0.3, -1),
      scale: 0.7,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
        child: child,
      ),
    );
  }
}
