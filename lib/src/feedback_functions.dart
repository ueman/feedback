import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Function which gets called when the user submits his feedback.
/// [feedback] is the user generated feedback. A string, by default.
/// [feedbackScreenshot] is a raw png encoded image.
/// [OnFeedbackCallback] should cast [feedback] to the appropriate type.
typedef OnFeedbackCallback = void Function(
  Object feedback,
  Uint8List? feedbackScreenshot,
);

/// Prints the given feedback to the console.
/// This is useful for debugging purposes.
void consoleFeedbackFunction(
  BuildContext context,
  String feedbackText,
  Uint8List feedbackScreenshot,
) {
  print('Feedback text:');
  print(feedbackText);
  print('Size of image: ${feedbackScreenshot.length}');
}

/// Shows an [AlertDialog] with the given feedback.
/// This is useful for debugging purposes.
void alertFeedbackFunction(
  BuildContext outerContext,
  String feedbackText,
  Uint8List? feedbackScreenshot,
) {
  showDialog<void>(
    context: outerContext,
    builder: (context) {
      return AlertDialog(
        title: Text(feedbackText),
        content: feedbackScreenshot != null
            ? Image.memory(
                feedbackScreenshot,
                height: 600,
                width: 500,
                fit: BoxFit.contain,
              )
            : null,
        actions: <Widget>[
          TextButton(
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
