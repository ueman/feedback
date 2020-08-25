import 'package:feedback/src/l18n/translation.dart';
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

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
    yield DefaultMaterialLocalizations.delegate;
    yield DefaultCupertinoLocalizations.delegate;
    yield DefaultWidgetsLocalizations.delegate;
    yield const GlobalFeedbackLocalizationsDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQueryFromWindow(
      child: Localizations(
        delegates: _localizationsDelegates.toList(growable: false),
        locale: const Locale('en'),
        child: FeedbackTheme(
          data: data ?? FeedbackThemeData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                opaque: true,
                builder: (context) {
                  return child;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
