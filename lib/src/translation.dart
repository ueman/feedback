abstract class FeedbackTranslation {
  String submitButtonText;
  String feedbackDescriptionText;
}

class EnTranslation extends FeedbackTranslation {
  @override
  String get submitButtonText => 'Submit';

  @override
  String get feedbackDescriptionText => 'What\'s wrong?';
}

class DeTranslation extends FeedbackTranslation {
  @override
  String get submitButtonText => 'Abschicken';

  @override
  String get feedbackDescriptionText => 'Was können wir besser machen?';
}
