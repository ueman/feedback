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

class ArFeedbackLocalizations extends FeedbackLocalizations {
  const ArFeedbackLocalizations();

  @override
  String get submitButtonText => 'إرسال';

  @override
  String get feedbackDescriptionText => 'ما الذي يمكننا فعله بشكل أفضل؟';

  @override
  String get draw => 'رسم';

  @override
  String get navigate => 'التنقل';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const ArFeedbackLocalizations(),
    );
  }
}

class CsFeedbackLocalizations extends FeedbackLocalizations {
  const CsFeedbackLocalizations();

  @override
  String get submitButtonText => 'Předložit';

  @override
  String get feedbackDescriptionText =>
      'Zanechte prosím své cenné komentáře a návrhy:';

  @override
  String get draw => 'Kreslit';

  @override
  String get navigate => 'Navigovat';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const CsFeedbackLocalizations(),
    );
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

class EsFeedbackLocalizations extends FeedbackLocalizations {
  const EsFeedbackLocalizations();

  @override
  String get submitButtonText => 'Enviar';

  @override
  String get feedbackDescriptionText => '¿Qué podemos hacer mejor?';

  @override
  String get draw => 'Dibujar';

  @override
  String get navigate => 'Navegar';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const EsFeedbackLocalizations(),
    );
  }
}

class FaFeedbackLocalizations extends FeedbackLocalizations {
  const FaFeedbackLocalizations();

  @override
  String get submitButtonText => 'ارسال';

  @override
  String get feedbackDescriptionText => 'چه کار بهتری میتوانیم انجام دهیم؟';

  @override
  String get draw => 'نقاشی';

  @override
  String get navigate => 'پیمایش کنید';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const FaFeedbackLocalizations(),
    );
  }
}

class HiFeedbackLocalizations extends FeedbackLocalizations {
  const HiFeedbackLocalizations();

  @override
  String get submitButtonText => 'प्रस्तुत';

  @override
  String get feedbackDescriptionText => 'हम बेहतर क्या कर सकते हैं?';

  @override
  String get draw => 'पेंट करने के लिए';

  @override
  String get navigate => 'नेविगेट';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const HiFeedbackLocalizations(),
    );
  }
}

class HuFeedbackLocalizations extends FeedbackLocalizations {
  const HuFeedbackLocalizations();

  @override
  String get submitButtonText => 'Küld';

  @override
  String get feedbackDescriptionText => 'Mit tehetnénk jobban?';

  @override
  String get draw => 'Húz';

  @override
  String get navigate => 'Hajózik';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const HuFeedbackLocalizations(),
    );
  }
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

class ItFeedbackLocalizations extends FeedbackLocalizations {
  const ItFeedbackLocalizations();

  @override
  String get submitButtonText => 'Spedire';

  @override
  String get feedbackDescriptionText => 'Cosa possiamo fare di meglio?';

  @override
  String get draw => 'Dipingere';

  @override
  String get navigate => 'Navigare';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const ItFeedbackLocalizations(),
    );
  }
}

class JaFeedbackLocalizations extends FeedbackLocalizations {
  const JaFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const JaFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => '提交';

  @override
  String get feedbackDescriptionText => '貴重なご意見やご感想をお寄せください：';

  @override
  String get draw => '落書き';

  @override
  String get navigate => 'ナビゲーター';
}

class KoFeedbackLocalizations extends FeedbackLocalizations {
  const KoFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const KoFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => '제출';

  @override
  String get feedbackDescriptionText => '소중한 의견과 제안을 남겨주세요:';

  @override
  String get draw => '낙서';

  @override
  String get navigate => '항해';
}

class PlFeedbackLocalizations extends FeedbackLocalizations {
  const PlFeedbackLocalizations();

  @override
  String get submitButtonText => 'Wysłać';

  @override
  String get feedbackDescriptionText => 'Co możemy zrobić lepiej?';

  @override
  String get draw => 'Malować';

  @override
  String get navigate => 'Nawigować';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const PlFeedbackLocalizations(),
    );
  }
}

class PtFeedbackLocalizations extends FeedbackLocalizations {
  const PtFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const PtFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => 'Enviar';

  @override
  String get feedbackDescriptionText =>
      'Deixe seus valiosos comentários e sugestões:';

  @override
  String get draw => 'Desenhar';

  @override
  String get navigate => 'Navegar';
}

class RoFeedbackLocalizations extends FeedbackLocalizations {
  const RoFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const RoFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => 'Trimite';

  @override
  String get feedbackDescriptionText =>
      'Vă rugăm să lăsați comentariile și sugestiile voastre valoroase:';

  @override
  String get draw => 'Desena';

  @override
  String get navigate => 'Navigare';
}

class RuFeedbackLocalizations extends FeedbackLocalizations {
  const RuFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const RuFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => 'Послать';

  @override
  String get feedbackDescriptionText =>
      'Пожалуйста, оставляйте свои ценные комментарии и предложения по адресу:';

  @override
  String get draw => 'Рисовать';

  @override
  String get navigate => 'Навигация';
}

class TrFeedbackLocalizations extends FeedbackLocalizations {
  const TrFeedbackLocalizations();

  @override
  String get submitButtonText => 'gönder';

  @override
  String get feedbackDescriptionText => 'Neyi daha iyi yapabiliriz?';

  @override
  String get draw => 'boyamak';

  @override
  String get navigate => 'Gezin';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const TrFeedbackLocalizations(),
    );
  }
}

class ZhFeedbackLocalizations extends FeedbackLocalizations {
  const ZhFeedbackLocalizations();

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const ZhFeedbackLocalizations(),
    );
  }

  @override
  String get submitButtonText => '提交';

  @override
  String get feedbackDescriptionText => '敬请留​下您宝贵的意见和建议：';

  @override
  String get draw => '涂鸦';

  @override
  String get navigate => '导航';
}

class GlobalFeedbackLocalizationsDelegate
    extends LocalizationsDelegate<FeedbackLocalizations> {
  const GlobalFeedbackLocalizationsDelegate();

  static const LocalizationsDelegate<FeedbackLocalizations> delegate =
      GlobalFeedbackLocalizationsDelegate();

  static final _supportedLocales = <Locale, FeedbackLocalizations>{
    const Locale('ar'): const ArFeedbackLocalizations(),
    const Locale('cs'): const CsFeedbackLocalizations(),
    const Locale('de'): const DeFeedbackLocalizations(),
    const Locale('en'): const EnFeedbackLocalizations(),
    const Locale('es'): const EsFeedbackLocalizations(),
    const Locale('fa'): const FaFeedbackLocalizations(),
    const Locale('fr'): const FrFeedbackLocalizations(),
    const Locale('hi'): const HiFeedbackLocalizations(),
    const Locale('hu'): const HuFeedbackLocalizations(),
    const Locale('it'): const ItFeedbackLocalizations(),
    const Locale('ja'): const JaFeedbackLocalizations(),
    const Locale('ko'): const KoFeedbackLocalizations(),
    const Locale('pl'): const PlFeedbackLocalizations(),
    const Locale('pt'): const PtFeedbackLocalizations(),
    const Locale('ro'): const RoFeedbackLocalizations(),
    const Locale('ru'): const RuFeedbackLocalizations(),
    const Locale('tr'): const TrFeedbackLocalizations(),
    const Locale('zh'): const ZhFeedbackLocalizations(),
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
