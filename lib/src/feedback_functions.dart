import 'dart:typed_data';

import 'package:flutter/material.dart';

typedef OnFeedbackCallback = void Function(
  BuildContext context,
  String,
  Uint8List,
);

void consoleFeedbackFunction(
  BuildContext context,
  String feedbackText,
  Uint8List feedbackScreenshot,
) {
  print('Feedback text:');
  print(feedbackText);
  print('Size of image: ${feedbackScreenshot.length}');
}

/// Shows an AlertDialog with the given feedback.
/// Does not work yet.
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
