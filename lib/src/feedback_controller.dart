import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  OnFeedbackCallback<Object>? onFeedback;

  void show(OnFeedbackCallback<Object> onFeedback) {
    _isVisible = true;
    this.onFeedback = onFeedback;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
