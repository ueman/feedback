import 'package:feedback/src/better_feedback.dart';
import 'package:flutter/material.dart';

class FeedbackController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  OnFeedbackCallback? onFeedback;

  void show(OnFeedbackCallback onFeedback) {
    _isVisible = true;
    this.onFeedback = onFeedback;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
