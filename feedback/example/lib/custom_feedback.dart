import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

/// A data type holding user feedback consisting of a feedback type, free from
/// feedback text, and a sentiment rating.
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (rating != null) 'rating': rating.toString(),
      'feedback_type': feedbackType.toString(),
      'feedback_text': feedbackText,
    };
  }
}

/// What type of feedback the user wants to provide.
enum FeedbackType {
  bugReport,
  featureRequest,
}

/// A user-provided sentiment rating.
enum FeedbackRating {
  bad,
  neutral,
  good,
}

/// A form that prompts the user for the type of feedback they want to give,
/// free form text feedback, and a sentiment rating.
/// The submit button is disabled until the user provides the feedback type. All
/// other fields are optional.
class CustomFeedbackForm extends StatefulWidget {
  const CustomFeedbackForm({
    super.key,
    required this.onSubmit,
    required this.scrollController,
  });

  final OnSubmit onSubmit;
  final ScrollController? scrollController;

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              if (widget.scrollController != null)
                const FeedbackSheetDragHandle(),
              ListView(
                controller: widget.scrollController,
                // Pad the top by 20 to match the corner radius if drag enabled.
                padding: EdgeInsets.fromLTRB(
                    16, widget.scrollController != null ? 20 : 16, 16, 0),
                children: [
                  const Text('What kind of feedback do you want to give?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('*'),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton<FeedbackType>(
                              value: _customFeedback.feedbackType,
                              items: FeedbackType.values
                                  .map(
                                    (type) => DropdownMenuItem<FeedbackType>(
                                      value: type,
                                      child: Text(type
                                          .toString()
                                          .split('.')
                                          .last
                                          .replaceAll('_', ' ')),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (feedbackType) => setState(() =>
                                  _customFeedback.feedbackType = feedbackType),
                            ),
                            ElevatedButton(
                              child: const Text('Open Dialog #2'),
                              onPressed: () {
                                showDialog<dynamic>(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text("Dialog #2"),
                                      content: Container(),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('What is your feedback?'),
                  TextField(
                    onChanged: (newFeedback) =>
                        _customFeedback.feedbackText = newFeedback,
                  ),
                  const SizedBox(height: 16),
                  const Text('How does this make you feel?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: FeedbackRating.values.map(_ratingToIcon).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          // disable this button until the user has specified a feedback type
          onPressed: _customFeedback.feedbackType != null
              ? () => widget.onSubmit(
                    _customFeedback.feedbackText ?? '',
                    extras: _customFeedback.toMap(),
                  )
              : null,
          child: const Text('submit'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _ratingToIcon(FeedbackRating rating) {
    final bool isSelected = _customFeedback.rating == rating;
    late IconData icon;
    switch (rating) {
      case FeedbackRating.bad:
        icon = Icons.sentiment_dissatisfied;
        break;
      case FeedbackRating.neutral:
        icon = Icons.sentiment_neutral;
        break;
      case FeedbackRating.good:
        icon = Icons.sentiment_satisfied;
        break;
    }
    return IconButton(
      color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey,
      onPressed: () => setState(() => _customFeedback.rating = rating),
      icon: Icon(icon),
      iconSize: 36,
    );
  }
}
