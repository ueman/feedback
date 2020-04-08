import 'package:flutter/material.dart';

class FeedbackController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
