import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

/// Controls the state of the feeback ui.
class FeedbackController extends ChangeNotifier {
  bool _isVisible = false;

  /// Whether the feedback ui is currently visible.
  bool get isVisible => _isVisible;

  /// This function is called when the user submits his feedback.
  OnFeedbackCallback? onFeedback;

  /// Open the feedback ui.
  /// After the user submitted his feedback [onFeedback] is called.
  /// If the user aborts the process of giving feedback, [onFeedback] is
  /// not called.
  void show(OnFeedbackCallback onFeedback) {
    _isVisible = true;
    this.onFeedback = onFeedback;
    notifyListeners();
  }

  /// Hides the feedback ui.
  /// Typically, this does not need to be called by the user of this library
  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  /// The draggable scrollable sheet controller used by better feedback.
  ///
  /// The controller is only attached if [FeedbackThemeData.sheetIsDraggable] is
  /// true and feedback is currently displayed.
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
}
