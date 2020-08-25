import 'package:feedback/src/l18n/localization.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/media_query_from_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({
    Key key,
    @required this.child,
    this.data,
  }) : super(key: key);

  final Widget child;
  final FeedbackThemeData data;

  @override
  Widget build(BuildContext context) {
    return MediaQueryFromWindow(
      child: FeedbackLocalization(
        child: FeedbackTheme(
          data: data ?? FeedbackThemeData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                opaque: true,
                builder: (context) => child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
