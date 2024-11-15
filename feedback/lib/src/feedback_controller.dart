import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

/// Controls the state of the feeback ui.
class FeedbackController<T, R> extends ChangeNotifier {
  _FeedbackSession<T, R>? _session;

  /// The current route, if any.
  T? get currentRoute => _session?.route;

  /// Whether the feedback ui is currently visible.
  bool get isVisible => _session != null;

  /// Open the feedback ui.
  /// After the user submitted his feedback [onFeedback] is called.
  /// If the user aborts the process of giving feedback, [onFeedback] is
  /// not called.
  Future<R?> show(T route) async {
    _session = _FeedbackSession(route);
    notifyListeners();
    return _session!.result.future;
  }

  /// Hides the feedback ui.
  void hide([R? result]) {
    if (_session == null) return;
    _session!.result.complete(result);
    _session = null;
    notifyListeners();
  }

  /// The draggable scrollable sheet controller used by better feedback.
  ///
  /// The controller is only attached if [FeedbackThemeData.sheetIsDraggable] is
  /// true and feedback is currently displayed.
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
}


class _FeedbackSession<T, R> {
  _FeedbackSession(this.route);

  final T route;
  final Completer<R?> result = Completer();
}