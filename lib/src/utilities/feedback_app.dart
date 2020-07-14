import 'package:feedback/src/utilities/media_query_from_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({Key key, @required this.child}) : super(key: key);

  final Widget child;

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
    yield DefaultMaterialLocalizations.delegate;
    yield DefaultCupertinoLocalizations.delegate;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQueryFromWindow(
      child: Localizations(
        delegates: _localizationsDelegates.toList(growable: false),
        locale: const Locale('en'),
        child: Material(child: child),
      ),
    );
  }
}
