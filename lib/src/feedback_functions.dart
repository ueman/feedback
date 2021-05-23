import 'package:feedback/src/user_feedback.dart';
import 'package:flutter/material.dart';

/// Function which gets called when the user submits his feedback.
/// [feedback] is the user generated feedback. A string, by default.
/// [screenshot] is a raw png encoded image.
/// [OnFeedbackCallback] should cast [feedback] to the appropriate type.
typedef OnFeedbackCallback = void Function(UserFeedback);

/// Prints the given feedback to the console.
/// This is useful for debugging purposes.
void consoleFeedbackFunction(
  BuildContext context,
  UserFeedback feedback,
) {
  print('Feedback text:');
  print(feedback.text);
  print('Size of image: ${feedback.screenshot?.length}');
  if (feedback.extra != null) {
    print('Extras: ${feedback.extra!.toString()}');
  }
}

/// Shows an [AlertDialog] with the given feedback.
/// This is useful for debugging purposes.
void alertFeedbackFunction(
  BuildContext outerContext,
  UserFeedback feedback,
) {
  showDialog<void>(
    context: outerContext,
    builder: (context) {
      return AlertDialog(
        title: Text(feedback.text),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (feedback.extra != null) Text(feedback.extra!.toString()),
              if (feedback.screenshot != null)
                Image.memory(
                  feedback.screenshot!,
                  height: 600,
                  width: 500,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
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
