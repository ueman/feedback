import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  OnFeedbackCallback onFeedback;

  void show(OnFeedbackCallback onFeedback) {
    assert(onFeedback != null);
    _isVisible = true;
    this.onFeedback = onFeedback;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
