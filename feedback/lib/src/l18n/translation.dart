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

// coverage:ignore-start

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

/// Default persian localization
class FaFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [FaFeedbackLocalizations].
  const FaFeedbackLocalizations();

  @override
  String get submitButtonText => 'تایید';

  @override
  String get feedbackDescriptionText => 'چه مشکلی پیش آمده ؟';

  @override
  String get draw => 'رسم';

  @override
  String get navigate => 'پیمایش';
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

/// Default russian localization
class RuFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [RuFeedbackLocalizations].
  const RuFeedbackLocalizations();

  @override
  String get submitButtonText => 'Отправить';

  @override
  String get feedbackDescriptionText => 'Опишите проблему';

  @override
  String get draw => 'Рисование';

  @override
  String get navigate => 'Навигация';
}

/// Default swedish localization
class SvFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [SvFeedbackLocalizations].
  const SvFeedbackLocalizations();

  @override
  String get submitButtonText => 'Skicka';

  @override
  String get feedbackDescriptionText => 'Vad är fel?';

  @override
  String get draw => 'Rita';

  @override
  String get navigate => 'Navigera';
}

/// Default ukrainian localization
class UkFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [UkFeedbackLocalizations].
  const UkFeedbackLocalizations();

  @override
  String get submitButtonText => 'Відправити';

  @override
  String get feedbackDescriptionText => 'Опишіть проблему';

  @override
  String get draw => 'Малювання';

  @override
  String get navigate => 'Навігація';
}

/// Default turkish localization
class TrFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [TrFeedbackLocalizations].
  const TrFeedbackLocalizations();

  @override
  String get submitButtonText => 'Gönder';

  @override
  String get feedbackDescriptionText => 'Sorun nedir?';

  @override
  String get draw => 'Çiz';

  @override
  String get navigate => 'Gezin';
}

/// Default Simplified Chinese localization
class ZhFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [ZhFeedbackLocalizations].
  const ZhFeedbackLocalizations();

  @override
  String get submitButtonText => '提交';

  @override
  String get feedbackDescriptionText => '敬请留下您宝贵的意见和建议：';

  @override
  String get draw => '涂鸦';

  @override
  String get navigate => '导航';
}

/// Default polish localization
class PlFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [PlFeedbackLocalizations].
  const PlFeedbackLocalizations();

  @override
  String get submitButtonText => 'Wyślij';

  @override
  String get feedbackDescriptionText => 'Co poszło nie tak?';

  @override
  String get draw => 'Rysuj';

  @override
  String get navigate => 'Nawiguj';
}

/// Default portuguese localization
class PtFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [PtFeedbackLocalizations].
  const PtFeedbackLocalizations();

  @override
  String get submitButtonText => 'Enviar';

  @override
  String get feedbackDescriptionText => 'Qual o problema?';

  @override
  String get draw => 'Desenhar';

  @override
  String get navigate => 'Navegar';
}

/// Default japanese localization
class JaFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [JaFeedbackLocalizations].
  const JaFeedbackLocalizations();

  @override
  String get submitButtonText => '送信';

  @override
  String get feedbackDescriptionText => '何がありましたか？';

  @override
  String get draw => '描く';

  @override
  String get navigate => 'ナビゲート';
}

/// Default greek localization
class ElFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [ElFeedbackLocalizations]
  const ElFeedbackLocalizations();

  @override
  String get submitButtonText => 'Υποβολή';

  @override
  String get feedbackDescriptionText => 'Τι πρόβλημα υπάρχει;';

  @override
  String get draw => 'Σχεδίαση';

  @override
  String get navigate => 'Πλοήγηση';
}

/// Default bulgarian localization
class BgFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [BgFeedbackLocalizations]
  const BgFeedbackLocalizations();

  @override
  String get submitButtonText => 'Подчинение';

  @override
  String get feedbackDescriptionText => 'текст на описанието';

  @override
  String get draw => 'Нарисувай';

  @override
  String get navigate => 'Навигиране';
}

/// Default spanish localization
class EsFeedbackLocalizations extends FeedbackLocalizations {
  /// Creates a [EsFeedbackLocalizations]
  const EsFeedbackLocalizations();

  @override
  String get submitButtonText => 'Enviar';

  @override
  String get feedbackDescriptionText => '¿Cuál es el problema?';

  @override
  String get draw => 'Dibujar';

  @override
  String get navigate => 'Navegar';
}

// coverage:ignore-end

/// This is a localization delegate, which includes all of the localizations
/// already present in this library.
class GlobalFeedbackLocalizationsDelegate
    extends LocalizationsDelegate<FeedbackLocalizations> {
  /// Creates a [GlobalFeedbackLocalizationsDelegate].
  GlobalFeedbackLocalizationsDelegate();

  /// Returns the default instance of a [GlobalFeedbackLocalizationsDelegate].
  static LocalizationsDelegate<FeedbackLocalizations> delegate =
      GlobalFeedbackLocalizationsDelegate();

  /// Returns a dict of all supported locales.
  /// Override this member to provide your own localized strings.
  final supportedLocales = <Locale, FeedbackLocalizations>{
    const Locale('en'): const EnFeedbackLocalizations(),
    const Locale('de'): const DeFeedbackLocalizations(),
    const Locale('fr'): const FrFeedbackLocalizations(),
    const Locale('ar'): const ArFeedbackLocalizations(),
    const Locale('ru'): const RuFeedbackLocalizations(),
    const Locale('sv'): const SvFeedbackLocalizations(),
    const Locale('uk'): const UkFeedbackLocalizations(),
    const Locale('tr'): const TrFeedbackLocalizations(),
    const Locale('zh'): const ZhFeedbackLocalizations(),
    const Locale('pl'): const PlFeedbackLocalizations(),
    const Locale('pt'): const PtFeedbackLocalizations(),
    const Locale('ja'): const JaFeedbackLocalizations(),
    const Locale('el'): const ElFeedbackLocalizations(),
    const Locale('bg'): const BgFeedbackLocalizations(),
    const Locale('es'): const EsFeedbackLocalizations(),
    const Locale('fa'): const FaFeedbackLocalizations(),
  };

  /// The default locale to use. Note that this locale should ALWAYS be
  /// present in supportedLocales.
  static const defaultLocale = Locale('en');

  @override
  bool isSupported(Locale locale) {
    // We only support language codes for now
    if (supportedLocales.containsKey(Locale(locale.languageCode))) {
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
    return SynchronousFuture<FeedbackLocalizations>(
      supportedLocales[languageLocale] ?? supportedLocales[defaultLocale]!,
    );
  }

  @override
  bool shouldReload(GlobalFeedbackLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultFeedbackLocalizations.delegate(en_EN)';
}
