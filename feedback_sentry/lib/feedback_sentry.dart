library feedback_sentry;

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
export 'package:feedback/feedback.dart';

extension SentryFeedback on FeedbackData {
  void showAndUploadToSentry({Hub? hub}) {
    this.show(sendToSentry(hub: hub));
  }
}

@visibleForTesting
OnFeedbackCallback sendToSentry({
  Hub? hub,
  String? name,
  String? email,
}) {
  final realHub = hub ?? HubAdapter();

  return (UserFeedback feedback) async {
    final id = await realHub.captureMessage(feedback.text, withScope: (scope) {
      scope.addAttachment(SentryAttachment.fromUint8List(
        feedback.screenshot,
        'screenshot.png',
        contentType: 'image/png',
      ));
    });
    await realHub.captureUserFeedback(SentryUserFeedback(
      eventId: id,
      email: email,
      name: name,
      comments: feedback.text + '\n${feedback.extra.toString()}',
    ));
  };
}
