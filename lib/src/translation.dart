abstract class FeedbackTranslation {
  String get submitButtonText;
  String get feedbackDescriptionText;
  String get navigate;
  String get draw;
}

class EnTranslation implements FeedbackTranslation {
  @override
  String get submitButtonText => 'Submit';

  @override
  String get feedbackDescriptionText => 'What\'s wrong?';

  @override
  String get draw => 'Draw';

  @override
  String get navigate => 'Navigate';
}

class DeTranslation implements FeedbackTranslation {
  @override
  String get submitButtonText => 'Abschicken';

  @override
  String get feedbackDescriptionText => 'Was können wir besser machen?';

  @override
  String get draw => 'Malen';

  @override
  String get navigate => 'Navigieren';
}

class FrTranslation implements FeedbackTranslation {
  @override
  String get submitButtonText => 'Envoyer';

  @override
  String get feedbackDescriptionText => 'Expliquez-nous votre problème';

  @override
  String get draw => 'Dessiner';

  @override
  String get navigate => 'Naviguer';
}
