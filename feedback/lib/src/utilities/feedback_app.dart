// ignore_for_file: public_member_api_docs

import 'package:feedback/src/l18n/localization.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/media_query_from_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({
    Key? key,
    required this.child,
    this.data,
    this.localizationsDelegates,
    this.localeOverride,
  }) : super(key: key);

  final Widget child;
  final FeedbackThemeData? data;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? localeOverride;

  @override
  Widget build(BuildContext context) {
    final themeWrapper = FeedbackTheme(
      data: data ?? FeedbackThemeData(),
      child: child,
    );

    Widget mediaQueryWrapper;

    /// Don't replace existing MediaQuery widget if it exists.
    if (MediaQuery.maybeOf(context) == null) {
      mediaQueryWrapper = MediaQueryFromWindow(child: themeWrapper);
    } else {
      mediaQueryWrapper = themeWrapper;
    }

    return FeedbackLocalization(
      delegates: localizationsDelegates,
      localeOverride: localeOverride,
      child: mediaQueryWrapper,
    );
  }
}
