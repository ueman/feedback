import 'dart:developer';
import 'dart:typed_data';

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
    required this.screenshotController,
  });

  final OnSubmit onSubmit;
  final ScrollController? scrollController;
  final ScreenshotController? screenshotController;

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();

  Uint8List? _screenshotBytes;
  bool _isCapturing = false;

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

                  // ---------- Screenshot preview area ----------
                  const SizedBox(height: 16),
                  if (_screenshotBytes != null) ...[
                    Text('Screenshot preview:',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _openPreviewDialog(context),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 220,
                          maxWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.memory(
                          _screenshotBytes!,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _isCapturing ? null : _retakeScreenshot,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retake'),
                        ),
                        const SizedBox(width: 12),
                        TextButton.icon(
                          onPressed: _isCapturing ? null : _clearScreenshot,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Remove'),
                        ),
                      ],
                    ),
                  ],
                  // ---------- end preview ----------
                ],
              ),
            ],
          ),
        ),

        // Capture button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: TextButton(
            onPressed: _isCapturing ? null : _handleTakeScreenshot,
            child: _isCapturing
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Capturing...'),
                    ],
                  )
                : const Text('Take screenshot'),
          ),
        ),

        // Submit button
        TextButton(
          onPressed: _customFeedback.feedbackType != null
              ? () async {
                  // Prepare extras: merge custom feedback map and optionally screenshot
                  final extras =
                      Map<String, dynamic>.from(_customFeedback.toMap());
                  if (_screenshotBytes != null) {
                    extras['screenshot'] = _screenshotBytes;
                  }
                  await widget.onSubmit(
                    _customFeedback.feedbackText ?? '',
                    extras: extras,
                  );
                }
              : null,
          child: const Text('Submit'),
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

  Future<void> _handleTakeScreenshot() async {
    if (widget.screenshotController == null) {
      _showSnack('Screenshot controller is not available.');
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      // Capture with sensible default pixelRatio; you can adjust this
      final bytes = await widget.screenshotController!.capture(pixelRatio: 2.0);
      if (!mounted) return;
      setState(() {
        _screenshotBytes = bytes;
      });
      log('Screenshot captured: ${bytes.lengthInBytes} bytes');
    } catch (e, st) {
      log('Error capturing screenshot: $e\n$st');
      _showSnack('Could not capture screenshot.');
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _retakeScreenshot() async {
    // small convenience wrapper to retake
    await _handleTakeScreenshot();
  }

  void _clearScreenshot() {
    setState(() {
      _screenshotBytes = null;
    });
  }

  void _openPreviewDialog(BuildContext context) {
    print('object');
    if (_screenshotBytes == null) return;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          child: InteractiveViewer(
            child: Image.memory(_screenshotBytes!),
          ),
        );
      },
    );
  }

  void _showSnack(String text) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
