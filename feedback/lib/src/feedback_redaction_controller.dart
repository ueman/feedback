import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

/// Controls the state of the feedback redaction.
class FeedbackRedactionController extends ChangeNotifier {
  bool _isRedacted = false;

  /// Whether sensitive content (wrapped in [FeedbackRedacted]) is currently
  /// redacted.
  bool get isRedacted => _isRedacted;

  /// Redacts all sensitive content (wrapped in [FeedbackRedacted]).
  /// After draw mode is enabled or the screenshot is being taken.
  /// Typically, this does not need to be called by the user of this library.
  void redact() {
    if (_isRedacted) return;
    _isRedacted = true;
    notifyListeners();
  }

  /// Unredacts all sensitive content (wrapped in [FeedbackRedacted]).
  /// After navigation mode is enabled or the screenshot has been taken.
  /// Typically, this does not need to be called by the user of this library.
  void unredact() {
    if (!_isRedacted) return;
    _isRedacted = false;
    notifyListeners();
  }
}
