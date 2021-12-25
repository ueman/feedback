import 'package:feedback/src/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../better_feedback.dart';

/// This class must be extended by all custom translations.
abstract class FeedbackLocalizations {
  /// Creates a [FeedbackLocalizations].
  const FeedbackLocalizations();

  /// Text of the button, which the user taps or clicks to submit his feedback.
  ///
  /// Remarks:
  /// - This can be ommited when providing a custom
  ///   [BetterFeedback.feedbackBuilder].
  String get submitButtonText;

  /// Text above the text field, in which the user can write his feedback.
  /// This should be some sort of question or an encouragement in order to get
  /// better feedback.
  ///
  /// Remarks:
  /// - This can be ommited when providing a custom
  ///   [BetterFeedback.feedbackBuilder].
  String get feedbackDescriptionText;

  /// Name of the navigation tab in feedback menu.
  /// If the user taps or clicks the button with this text,
  /// the navigation mode is selected.
  String get navigate;

  /// Name of the draw tab in feedback menu.
  /// If the user taps or clicks the button with this text,
  /// the drawing mode is selected.
  String get draw;

  /// This method is used to obtain a localized instance of
  /// [FeedbackLocalizations].
  static FeedbackLocalizations of(BuildContext context) {
    debugCheckHasFeedbackLocalizations(context);
    return Localizations.of<FeedbackLocalizations>(
      context,
      FeedbackLocalizations,
    )!;
  }
}

/// Default german localization
class DeFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [DeFeedbackLocalizations].
  const DeFeedbackLocalizations();

  @override
  String get submitButtonText => 'Abschicken';

  @override
  String get feedbackDescriptionText => 'Was können wir besser machen?';

  @override
  String get draw => 'Malen';

  @override
  String get navigate => 'Navigieren';
}

/// Default english localization
class EnFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [EnFeedbackLocalizations].
  const EnFeedbackLocalizations();

  @override
  String get submitButtonText => 'Submit';

  @override
  String get feedbackDescriptionText => 'What\'s wrong?';

  @override
  String get draw => 'Draw';

  @override
  String get navigate => 'Navigate';
}

/// Default french localization
class FrFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [FrFeedbackLocalizations].
  const FrFeedbackLocalizations();

  @override
  String get submitButtonText => 'Envoyer';

  @override
  String get feedbackDescriptionText => 'Expliquez-nous votre problème';

  @override
  String get draw => 'Dessiner';

  @override
  String get navigate => 'Naviguer';
}

/// Default arabic localization
class ArFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [ArFeedbackLocalizations].
  const ArFeedbackLocalizations();

  @override
  String get submitButtonText => 'إرسال';

  @override
  String get feedbackDescriptionText => 'ما هي مشكلتك؟';

  @override
  String get draw => 'ارسم';

  @override
  String get navigate => 'إنتقال';
}

/// This is a localization delegate, which includes all of the localizations
/// already present in this library.
class GlobalFeedbackLocalizationsDelegate
    extends LocalizationsDelegate<FeedbackLocalizations> {
  /// Creates a [GlobalFeedbackLocalizationsDelegate].
  const GlobalFeedbackLocalizationsDelegate();

  /// Returns the default instance of a [GlobalFeedbackLocalizationsDelegate].
  static const LocalizationsDelegate<FeedbackLocalizations> delegate =
      GlobalFeedbackLocalizationsDelegate();

  static final _supportedLocales = <Locale, FeedbackLocalizations>{
    const Locale('en'): const EnFeedbackLocalizations(),
    const Locale('de'): const DeFeedbackLocalizations(),
    const Locale('fr'): const FrFeedbackLocalizations(),
    const Locale('ar'): const ArFeedbackLocalizations(),
  };

  @override
  bool isSupported(Locale locale) {
    // We only support language codes for now
    if (_supportedLocales.containsKey(Locale(locale.languageCode))) {
      return true;
    }
    debugPrint(
      'The locale $locale is not supported, '
      'falling back to english translations',
    );
    return true;
  }

  @override
  Future<FeedbackLocalizations> load(Locale locale) {
    final languageLocale = Locale(locale.languageCode);
    // We only support language codes for now
    if (_supportedLocales.containsKey(languageLocale)) {
      return SynchronusFuture(_supportedLocales[languageLocale]!);
    }
    // The default is english
    return SynchronusFuture(const EnFeedbackLocalizations());
  }

  @override
  bool shouldReload(GlobalFeedbackLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultFeedbackLocalizations.delegate(en_EN)';
}
