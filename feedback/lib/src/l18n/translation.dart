import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class FeedbackLocalizations {
  const FeedbackLocalizations();

  String get submitButtonText;
  String get feedbackDescriptionText;
  String get navigate;
  String get draw;

  static FeedbackLocalizations of(BuildContext context) {
    return Localizations.of<FeedbackLocalizations>(
        context, FeedbackLocalizations)!;
  }
}

class DeFeedbackLocalizations extends FeedbackLocalizations {
  const DeFeedbackLocalizations();

  @override
  String get submitButtonText => 'Abschicken';

  @override
  String get feedbackDescriptionText => 'Was können wir besser machen?';

  @override
  String get draw => 'Malen';

  @override
  String get navigate => 'Navigieren';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const DeFeedbackLocalizations(),
    );
  }
}

class EnFeedbackLocalizations extends FeedbackLocalizations {
  const EnFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const EnFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => 'Submit';

  @override
  String get feedbackDescriptionText => 'What\'s wrong?';

  @override
  String get draw => 'Draw';

  @override
  String get navigate => 'Navigate';
}

class FrFeedbackLocalizations extends FeedbackLocalizations {
  const FrFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const FrFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => 'Envoyer';

  @override
  String get feedbackDescriptionText => 'Expliquez-nous votre problème';

  @override
  String get draw => 'Dessiner';

  @override
  String get navigate => 'Naviguer';
}

class GlobalFeedbackLocalizationsDelegate
    extends LocalizationsDelegate<FeedbackLocalizations> {
  const GlobalFeedbackLocalizationsDelegate();

  static const LocalizationsDelegate<FeedbackLocalizations> delegate =
      GlobalFeedbackLocalizationsDelegate();

  static final _supportedLocales = <Locale, FeedbackLocalizations>{
    const Locale('en'): const EnFeedbackLocalizations(),
    const Locale('de'): const DeFeedbackLocalizations(),
    const Locale('fr'): const FrFeedbackLocalizations(),
  };

  @override
  bool isSupported(Locale locale) {
    // We only support language codes for now
    if (_supportedLocales.containsKey(Locale(locale.languageCode))) {
      return true;
    }
    debugPrint(
      'The locale $locale is not supported,'
      ' falling back to englisch translations',
    );
    return true;
  }

  @override
  Future<FeedbackLocalizations> load(Locale locale) async {
    final languageLocale = Locale(locale.languageCode);
    // We only support language codes for now
    if (_supportedLocales.containsKey(languageLocale)) {
      return _supportedLocales[languageLocale]!;
    }
    // The default is english
    return EnFeedbackLocalizations.load(locale);
  }

  @override
  bool shouldReload(GlobalFeedbackLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultFeedbackLocalizations.delegate(en_EN)';
}

bool debugCheckHasFeedbackLocalizations(BuildContext context) {
  assert(() {
    if (Localizations.of<FeedbackLocalizations>(
          context,
          FeedbackLocalizations,
        ) ==
        null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No FeedbackLocalizations found.'),
        ErrorDescription(
          '${context.widget.runtimeType} widgets require FeedbackLocalizations '
          'to be provided by a Localizations widget ancestor.',
        ),
        ErrorDescription(
          'Localizations are used to generate many different messages, labels, '
          'and abbreviations which are used by the feedback library.',
        ),
        ...context.describeMissingAncestor(
          expectedAncestorType: FeedbackLocalizations,
        )
      ]);
    }
    return true;
  }());
  return true;
}
