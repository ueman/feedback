// ignore_for_file: public_member_api_docs

import 'package:feedback/src/l18n/localization.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({
    super.key,
    required this.child,
    this.themeMode,
    this.theme,
    this.darkTheme,
    this.localizationsDelegates,
    this.localeOverride,
  });

  final Widget child;
  final ThemeMode? themeMode;
  final FeedbackThemeData? theme;
  final FeedbackThemeData? darkTheme;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? localeOverride;

  FeedbackThemeData _buildThemeData(BuildContext context) {
    final ThemeMode mode = themeMode ?? ThemeMode.system;
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    final bool useDarkMode = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && brightness == Brightness.dark);
    FeedbackThemeData? themeData;

    if (useDarkMode && darkTheme != null) {
      themeData = darkTheme;
    } else if (useDarkMode && theme == null) {
      themeData = FeedbackThemeData.dark();
    }

    themeData ??= theme ?? FeedbackThemeData.light();

    return themeData;
  }

  @override
  Widget build(BuildContext context) {
    return FeedbackLocalization(
      delegates: localizationsDelegates,
      localeOverride: localeOverride,
      child: FeedbackTheme(
        data: _buildThemeData(context),
        child: child,
      ),
    );
  }
}
