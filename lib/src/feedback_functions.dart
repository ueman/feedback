import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Function which gets called when the user submits his feedback.
/// [context] is a [BuildContext] with a [MaterialApp] ancestor.
/// [feedback] is the user generated feedback text.
/// [feedbackScreenshot] is a raw png encoded image.
typedef OnFeedbackCallback = void Function(
  BuildContext context,
  String feedback,
  Uint8List feedbackScreenshot,
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
  BuildContext context,
  String feedbackText,
  Uint8List feedbackScreenshot,
) {
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
