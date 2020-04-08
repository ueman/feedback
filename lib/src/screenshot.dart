import 'dart:typed_data';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenshotController {
  ScreenshotController() {
    _containerKey = GlobalKey();
  }

  GlobalKey _containerKey;

  Future<Uint8List> capture({
    double pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) {
    //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
    return Future.delayed(delay, () async {
      final renderObject = _containerKey.currentContext.findRenderObject();
      if (renderObject is RenderRepaintBoundary) {
        final ui.Image image =
            await renderObject.toImage(pixelRatio: pixelRatio);
        final ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData.buffer.asUint8List();
      } else {
        throw Exception('_containerKey is not a RepaintBoundary');
      }
    });
  }
}

class Screenshot extends StatefulWidget {
  const Screenshot({
    Key key,
    @required this.child,
    this.containerKey,
    this.controller,
  })  : assert(child != null),
        super(key: key);
  @override
  State<Screenshot> createState() {
    return ScreenshotState();
  }

  final Widget child;
  final ScreenshotController controller;
  final GlobalKey containerKey;
}

class ScreenshotState extends State<Screenshot> with TickerProviderStateMixin {
  ScreenshotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScreenshotController();
  }

  @override
  void didUpdateWidget(Screenshot oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      return;
    }

    widget.controller._containerKey = oldWidget.controller._containerKey;
    if (oldWidget.controller != null && widget.controller == null) {
      _controller._containerKey = oldWidget.controller._containerKey;
    }
    if (widget.controller != null && oldWidget.controller == null) {
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _controller._containerKey,
      child: widget.child,
    );
  }
}
