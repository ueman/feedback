// ignore_for_file: public_member_api_docs
// coverage:ignore-file

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:flutter/material.dart';

void printErrorMessage() {
  final dynamic flutterCanvasKit = js.context['flutterCanvasKit'];
  if (flutterCanvasKit != null) {
    return;
  }
  // Seems like the user is on the Flutter HTML renderer.
  // Because of Flutter limitations, this library doesn't work with it.
  FlutterError.onError?.call(
    FlutterErrorDetails(
      exception: FlutterError(
        '"feedback" does not work with Flutter HTML renderer. '
        'Switch to the CanvasKit renderer in order to make it work. '
        'See https://docs.flutter.dev/development/tools/web-renderers and '
        'https://pub.dev/packages/feedback#-known-issues-and-limitations '
        'for more information.',
      ),
      library: 'feedback',
    ),
  );
}
