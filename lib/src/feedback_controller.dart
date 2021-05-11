import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackController<T> extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  OnFeedbackCallback<T>? onFeedback;

  void show(OnFeedbackCallback<T> onFeedback) {
    _isVisible = true;
    this.onFeedback = onFeedback;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
