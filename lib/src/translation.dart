abstract class Translation {
  String submitButtonText;
  String helpText;
  String feedbackPlaceholderText;
}

class EnTranslation extends Translation {
  @override
  String get submitButtonText => 'Submit';

  @override
  String get helpText => 'TODO';

  @override
  String get feedbackPlaceholderText => 'What\'s wrong?';
}
