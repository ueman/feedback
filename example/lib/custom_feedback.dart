import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FeedbackType {
  bug_report,
  feature_request,
}

enum FeedbackRating {
  bad,
  neutral,
  good,
}

class CustomFeedback {
  CustomFeedback({
    this.feedbackType,
    this.feedbackText,
    this.rating,
  });

  FeedbackType? feedbackType;
  String? feedbackText;
  FeedbackRating? rating;

  @override
  String toString() {
    return {
      if (rating != null) 'rating': rating.toString(),
      'feedback_type': feedbackType.toString(),
      'feedback_text': feedbackText,
    }.toString();
  }
}

class CustomFeedbackForm extends StatefulWidget {
  const CustomFeedbackForm({Key? key, required this.onSubmit})
      : super(key: key);

  final OnSubmit onSubmit;

  @override
  _CustomFeedbackFormState createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('What kind of feedback do you want to give?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text('*'),
            ),
            Flexible(
              child: DropdownButton<FeedbackType>(
                value: _customFeedback.feedbackType,
                items: FeedbackType.values
                    .map(
                      (type) => DropdownMenuItem<FeedbackType>(
                        child: Text(type.toString().replaceAll('_', ' ')),
                        value: type,
                      ),
                    )
                    .toList(),
                onChanged: (feedbackType) =>
                    setState(() => _customFeedback.feedbackType = feedbackType),
              ),
            ),
          ],
        ),
        TextField(
          onChanged: (newFeedback) =>
              _customFeedback.feedbackText = newFeedback,
        ),
        TextButton(
          // disable this button until the user has specified a feedback type
          onPressed: _customFeedback.feedbackType != null
              ? () => widget.onSubmit(_customFeedback)
              : null,
          child: const Text('submit'),
        ),
      ],
    );
  }
}
