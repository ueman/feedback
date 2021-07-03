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

class BgFeedbackLocalizations extends FeedbackLocalizations {
  const BgFeedbackLocalizations();

  @override
  String get submitButtonText => 'Подаване на';

  @override
  String get feedbackDescriptionText => 'Какво можем да направим по-добре?';

  @override
  String get draw => 'Боядисване';

  @override
  String get navigate => 'Навигирайте в';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const BgFeedbackLocalizations(),
    );
  }
}

class BnFeedbackLocalizations extends FeedbackLocalizations {
  const BnFeedbackLocalizations();

  @override
  String get submitButtonText => 'প্রেরণ';

  @override
  String get feedbackDescriptionText => 'আমরা আরও ভাল কি করতে পারি?';

  @override
  String get draw => 'রং করা';

  @override
  String get navigate => 'নেভিগেট করুন';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const BnFeedbackLocalizations(),
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

class DaFeedbackLocalizations extends FeedbackLocalizations {
  const DaFeedbackLocalizations();

  @override
  String get submitButtonText => 'Indsend';

  @override
  String get feedbackDescriptionText => 'Hvad kan vi gøre bedre?';

  @override
  String get draw => 'Maling';

  @override
  String get navigate => 'Navigere';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const DaFeedbackLocalizations(),
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

class ElFeedbackLocalizations extends FeedbackLocalizations {
  const ElFeedbackLocalizations();

  @override
  String get submitButtonText => 'Υποβολή';

  @override
  String get feedbackDescriptionText => 'Τι μπορούμε να κάνουμε καλύτερα;';

  @override
  String get draw => 'Βαφή';

  @override
  String get navigate => 'Κυβερνώ';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const ElFeedbackLocalizations(),
    );
  }
}

class EnFeedbackLocalizations extends FeedbackLocalizations {
  const EnFeedbackLocalizations();

  @override
  String get submitButtonText => 'Submit';

  @override
  String get feedbackDescriptionText => 'What\'s wrong?';

  @override
  String get draw => 'Draw';

  @override
  String get navigate => 'Navigate';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const EnFeedbackLocalizations(),
    );
  }
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

class EtFeedbackLocalizations extends FeedbackLocalizations {
  const EtFeedbackLocalizations();

  @override
  String get submitButtonText => 'Esita';

  @override
  String get feedbackDescriptionText => 'Mida me saame paremini teha?';

  @override
  String get draw => 'Värvi';

  @override
  String get navigate => 'Navigeeri';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const EtFeedbackLocalizations(),
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

class FiFeedbackLocalizations extends FeedbackLocalizations {
  const FiFeedbackLocalizations();

  @override
  String get submitButtonText => 'Lähettää';

  @override
  String get feedbackDescriptionText => 'Mitä voimme tehdä paremmin?';

  @override
  String get draw => 'Maalata';

  @override
  String get navigate => 'Navigoida';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const FiFeedbackLocalizations(),
    );
  }
}

class FrFeedbackLocalizations extends FeedbackLocalizations {
  const FrFeedbackLocalizations();

  @override
  String get submitButtonText => 'Envoyer';

  @override
  String get feedbackDescriptionText => 'Expliquez-nous votre problème';

  @override
  String get draw => 'Dessiner';

  @override
  String get navigate => 'Naviguer';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const FrFeedbackLocalizations(),
    );
  }
}

class GuFeedbackLocalizations extends FeedbackLocalizations {
  const GuFeedbackLocalizations();

  @override
  String get submitButtonText => 'મોકલો';

  @override
  String get feedbackDescriptionText => 'આપણે વધુ સારું શું કરી શકીએ?';

  @override
  String get draw => 'કલર કરવો';

  @override
  String get navigate => 'નેવિગેટ કરો';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const GuFeedbackLocalizations(),
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

class HrFeedbackLocalizations extends FeedbackLocalizations {
  const HrFeedbackLocalizations();

  @override
  String get submitButtonText => 'Poslati';

  @override
  String get feedbackDescriptionText => 'Što možemo učiniti bolje?';

  @override
  String get draw => 'Obojati';

  @override
  String get navigate => 'Navigacija';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const HrFeedbackLocalizations(),
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

class IdFeedbackLocalizations extends FeedbackLocalizations {
  const IdFeedbackLocalizations();

  @override
  String get submitButtonText => 'Kirim';

  @override
  String get feedbackDescriptionText =>
      'Apa yang bisa kita lakukan lebih baik?';

  @override
  String get draw => 'Melukis';

  @override
  String get navigate => 'Navigasi';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const IdFeedbackLocalizations(),
    );
  }
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

class LtFeedbackLocalizations extends FeedbackLocalizations {
  const LtFeedbackLocalizations();

  @override
  String get submitButtonText => 'Pateikti';

  @override
  String get feedbackDescriptionText => 'Ką galime padaryti geriau?';

  @override
  String get draw => 'Dažai';

  @override
  String get navigate => 'Naršykite';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const LtFeedbackLocalizations(),
    );
  }
}

class LvFeedbackLocalizations extends FeedbackLocalizations {
  const LvFeedbackLocalizations();

  @override
  String get submitButtonText => 'Iesniegt';

  @override
  String get feedbackDescriptionText => 'Ko mēs varam darīt labāk?';

  @override
  String get draw => 'Krāsa';

  @override
  String get navigate => 'Pārvietoties';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const LvFeedbackLocalizations(),
    );
  }
}

class MkFeedbackLocalizations extends FeedbackLocalizations {
  const MkFeedbackLocalizations();

  @override
  String get submitButtonText => 'Испрати';

  @override
  String get feedbackDescriptionText => 'Што можеме да направиме подобро?';

  @override
  String get draw => 'Да слика';

  @override
  String get navigate => 'Навигација';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const MkFeedbackLocalizations(),
    );
  }
}

class MsFeedbackLocalizations extends FeedbackLocalizations {
  const MsFeedbackLocalizations();

  @override
  String get submitButtonText => 'Hantar';

  @override
  String get feedbackDescriptionText =>
      'Apa yang boleh kita lakukan dengan lebih baik?';

  @override
  String get draw => 'Mengecat';

  @override
  String get navigate => 'Navigasi';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const MsFeedbackLocalizations(),
    );
  }
}

class NlFeedbackLocalizations extends FeedbackLocalizations {
  const NlFeedbackLocalizations();

  @override
  String get submitButtonText => 'Indienen';

  @override
  String get feedbackDescriptionText => 'Wat kunnen we beter doen?';

  @override
  String get draw => 'Verf';

  @override
  String get navigate => 'Navigeren';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const NlFeedbackLocalizations(),
    );
  }
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

class SkFeedbackLocalizations extends FeedbackLocalizations {
  const SkFeedbackLocalizations();

  @override
  String get submitButtonText => 'Odoslať';

  @override
  String get feedbackDescriptionText => 'Čo môžeme urobiť lepšie?';

  @override
  String get draw => 'Farba';

  @override
  String get navigate => 'Navigovať';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const SkFeedbackLocalizations(),
    );
  }
}

class SlFeedbackLocalizations extends FeedbackLocalizations {
  const SlFeedbackLocalizations();

  @override
  String get submitButtonText => 'Pošlji';

  @override
  String get feedbackDescriptionText => 'Kaj lahko naredimo bolje?';

  @override
  String get draw => 'Barva';

  @override
  String get navigate => 'Krmarite';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const SlFeedbackLocalizations(),
    );
  }
}

class SqFeedbackLocalizations extends FeedbackLocalizations {
  const SqFeedbackLocalizations();

  @override
  String get submitButtonText => 'Dërgoni';

  @override
  String get feedbackDescriptionText => 'Çfarë mund të bëjmë më mirë?';

  @override
  String get draw => 'Vizato';

  @override
  String get navigate => 'Lundro';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const SqFeedbackLocalizations(),
    );
  }
}

class SrFeedbackLocalizations extends FeedbackLocalizations {
  const SrFeedbackLocalizations();

  @override
  String get submitButtonText => 'Пошаљите';

  @override
  String get feedbackDescriptionText => 'Шта можемо учинити боље?';

  @override
  String get draw => 'Обојити';

  @override
  String get navigate => 'Навигација';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const SrFeedbackLocalizations(),
    );
  }
}

class SvFeedbackLocalizations extends FeedbackLocalizations {
  const SvFeedbackLocalizations();

  @override
  String get submitButtonText => 'Skicka';

  @override
  String get feedbackDescriptionText => 'Vad kan vi göra bättre?';

  @override
  String get draw => 'Färg';

  @override
  String get navigate => 'Navigera';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const SvFeedbackLocalizations(),
    );
  }
}

class TeFeedbackLocalizations extends FeedbackLocalizations {
  const TeFeedbackLocalizations();

  @override
  String get submitButtonText => 'పంపండి';

  @override
  String get feedbackDescriptionText => 'మనం బాగా ఏమి చేయగలం?';

  @override
  String get draw => 'అద్దుటకై';

  @override
  String get navigate => 'నావిగేషన్';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const TeFeedbackLocalizations(),
    );
  }
}

class ThFeedbackLocalizations extends FeedbackLocalizations {
  const ThFeedbackLocalizations();

  @override
  String get submitButtonText => 'ส่ง';

  @override
  String get feedbackDescriptionText => 'เราจะทำอะไรได้ดีกว่านี้?';

  @override
  String get draw => 'ทาสี';

  @override
  String get navigate => 'นำทาง';

  static Future<FeedbackLocalizations> load(Locale locale) {
    return SynchronousFuture<FeedbackLocalizations>(
      const ThFeedbackLocalizations(),
    );
  }
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
    const Locale('ar'): const ArFeedbackLocalizations(), // Arabic
    const Locale('bg'): const BgFeedbackLocalizations(), // Bulgarian
    const Locale('bn'): const BnFeedbackLocalizations(), // Bengali
    const Locale('cs'): const CsFeedbackLocalizations(), // Czech
    const Locale('da'): const DaFeedbackLocalizations(), // Danish
    const Locale('de'): const DeFeedbackLocalizations(), // German
    const Locale('el'): const ElFeedbackLocalizations(), // Greek
    const Locale('en'): const EnFeedbackLocalizations(), // English
    const Locale('es'): const EsFeedbackLocalizations(), // Spanish
    const Locale('et'): const EtFeedbackLocalizations(), // Estonian
    const Locale('fa'): const FaFeedbackLocalizations(), // Persian
    const Locale('fi'): const FiFeedbackLocalizations(), // Finnish
    const Locale('fr'): const FrFeedbackLocalizations(), // French
    const Locale('gu'): const GuFeedbackLocalizations(), // Gujarati
    const Locale('hi'): const HiFeedbackLocalizations(), // Hindi
    const Locale('hr'): const HrFeedbackLocalizations(), // Croatian
    const Locale('hu'): const HuFeedbackLocalizations(), // Hungarian
    const Locale('id'): const IdFeedbackLocalizations(), // Indonesian
    const Locale('it'): const ItFeedbackLocalizations(), // Italian
    const Locale('ja'): const JaFeedbackLocalizations(), // Japanese
    const Locale('ko'): const KoFeedbackLocalizations(), // Korean
    const Locale('lt'): const LtFeedbackLocalizations(), // Lithuanian
    const Locale('lv'): const LvFeedbackLocalizations(), // Latvian
    const Locale('mk'): const MkFeedbackLocalizations(), // Macedonian
    const Locale('ms'): const MsFeedbackLocalizations(), // Malay
    const Locale('nl'): const NlFeedbackLocalizations(), // Dutch
    const Locale('pl'): const PlFeedbackLocalizations(), // Polish
    const Locale('pt'): const PtFeedbackLocalizations(), // Portuguese
    const Locale('ro'): const RoFeedbackLocalizations(), // Romanian
    const Locale('ru'): const RuFeedbackLocalizations(), // Russian
    const Locale('sk'): const SkFeedbackLocalizations(), // Slovak
    const Locale('sl'): const SlFeedbackLocalizations(), // Slovenian
    const Locale('sq'): const SqFeedbackLocalizations(), // Albanian
    const Locale('sr'): const SrFeedbackLocalizations(), // Serbian
    const Locale('sv'): const SvFeedbackLocalizations(), // Swedish
    const Locale('te'): const TeFeedbackLocalizations(), // Telugu
    const Locale('th'): const ThFeedbackLocalizations(), // Thai
    const Locale('tr'): const TrFeedbackLocalizations(), // Turkish
    const Locale('zh'): const ZhFeedbackLocalizations(), // Chinese
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
