import 'package:flutter/cupertino.dart';

class FeedbackController extends ChangeNotifier {
  bool isFeedbackViewActive = false;

  void showFeedback() {
    isFeedbackViewActive = true;
    notifyListeners();
  }

  void hideFeedback() {
    isFeedbackViewActive = false;
    notifyListeners();
  }
}
