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
    this.localizationsDelegates,
  }) : super(key: key);

  final Widget child;
  final FeedbackThemeData data;
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  @override
  Widget build(BuildContext context) {
    return MediaQueryFromWindow(
      child: FeedbackLocalization(
        delegates: localizationsDelegates,
        child: FeedbackTheme(
          data: data ?? FeedbackThemeData(),
          // The overlay is needed by the TextField
          // in the feedback bottom sheet.
          child: child,
        ),
      ),
    );
  }
}
