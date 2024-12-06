import 'dart:typed_data';

import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';

class FeedbackFormController<R> {
  const FeedbackFormController(this._screenshotController, [this.scrollController]);

  final ScreenshotController _screenshotController;

  final ScrollController? scrollController;

  Future<Uint8List> takeScreenshot(BuildContext context, {
    bool showKeyboard = false,
    double pixelRatio = 3.0,
    Duration delay = const Duration(milliseconds: 2000),
  }) async {
    if (!showKeyboard) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    await Future<void>.delayed(delay);
    return _screenshotController.capture(
      pixelRatio: pixelRatio,
      delay: Duration.zero,
    );
  }
}
