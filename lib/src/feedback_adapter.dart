import 'dart:typed_data';

import 'package:flutter/material.dart';

typedef OnFeedbackCallback = void Function(String, Uint8List);

/// Interface to implement for a custom handling of feedback
class FeedbackAdapter {
  void onFeedback(String feedbackText, Uint8List feedbackScreenshot) {
    print('Feedback text:');
    print(feedbackText);
    print('Size of image: ${feedbackScreenshot.length}');
  }
}

/// Can wrap an [OnFeedbackCallback] into a [FeedbackAdapter]
class CallbackFeedbackAdapter implements FeedbackAdapter {
  CallbackFeedbackAdapter(this.callback);

  final OnFeedbackCallback callback;

  @override
  void onFeedback(String feedbackText, Uint8List feedbackScreenshot) {
    callback(feedbackText, feedbackScreenshot);
  }
}

/// Shows an AlertDialog with the given feedback.
/// Does not work yet.
class AlertDialogFeedbackAdapter implements FeedbackAdapter {
  AlertDialogFeedbackAdapter(this.context);

  final BuildContext context;

  @override
  void onFeedback(String feedbackText, Uint8List feedbackScreenshot) {
    showDialog<void>(
      context: context,
      builder: (bc) {
        return AlertDialog(
          title: Text(feedbackText),
          content: Image.memory(
            feedbackScreenshot,
            height: 600,
            width: 500,
            fit: BoxFit.contain,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
