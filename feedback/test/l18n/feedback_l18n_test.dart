import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('overwrites locale', () async {
    const language = Locale('zh', 'TW');
    final GlobalFeedbackLocalizationsDelegate delegate =
        GlobalFeedbackLocalizationsDelegate();
    final FeedbackLocalizations localizations = await delegate.load(language);
    const ZhTWFeedbackLocalizations targetLocalizations =
        ZhTWFeedbackLocalizations();
    // ensure overrides apply
    expect(localizations.draw, targetLocalizations.draw);
    expect(localizations.navigate, targetLocalizations.navigate);
    expect(
        localizations.submitButtonText, targetLocalizations.submitButtonText);
    expect(localizations.feedbackDescriptionText,
        targetLocalizations.feedbackDescriptionText);
  });
}
