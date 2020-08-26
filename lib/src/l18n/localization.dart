import 'package:feedback/src/l18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackLocalization extends StatelessWidget {
  const FeedbackLocalization({
    Key key,
    @required this.child,
    this.delegates,
  }) : super(key: key);

  final Widget child;
  final List<LocalizationsDelegate<dynamic>> delegates;

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
    yield DefaultMaterialLocalizations.delegate;
    yield DefaultCupertinoLocalizations.delegate;
    yield DefaultWidgetsLocalizations.delegate;
    yield const GlobalFeedbackLocalizationsDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: delegates ?? _localizationsDelegates.toList(growable: false),
      locale: const Locale('en'),
      child: child,
    );
  }
}
