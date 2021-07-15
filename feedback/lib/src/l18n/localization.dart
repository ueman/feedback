import 'package:feedback/src/l18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FeedbackLocalization extends StatelessWidget {
  const FeedbackLocalization({
    Key? key,
    required this.child,
    this.delegates,
    this.localeOverride,
  }) : super(key: key);

  final Widget child;
  final List<LocalizationsDelegate<dynamic>>? delegates;
  final Locale? localeOverride;

  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates => [
        ...GlobalMaterialLocalizations.delegates,
        const GlobalFeedbackLocalizationsDelegate(),
      ];
  @override
  Widget build(BuildContext context) {
    final mergedDelegates = _localizationsDelegates.toList(growable: true);
    if (delegates != null) {
      mergedDelegates.insertAll(0, delegates!);
    }

    return Localizations(
      delegates: mergedDelegates,
      locale: localeOverride ?? _defaultLocale,
      child: child,
    );
  }
}

Locale get _defaultLocale {
  // Flutter 1.26 (2.0.1) returns `Locale?`, 1.27 `Locale`
  final Locale? locale = WidgetsBinding.instance?.window.locale;
  return locale ?? const Locale('en', 'US');
}
