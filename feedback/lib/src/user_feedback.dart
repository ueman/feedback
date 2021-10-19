import 'dart:typed_data';
import 'package:feedback/src/better_feedback.dart';

/// Container for the feedback of the user.
class UserFeedback {
  /// Creates an [UserFeedback]
  UserFeedback({
    required this.text,
    required this.screenshot,
    this.extra,
  });

  /// The user's written feedback
  final String text;

  /// A raw png encoded screenshot of the app. Probably annotated with helpful
  /// drawings by the user.
  final Uint8List screenshot;

  /// Additional information.
  /// For use by a custom [BetterFeedback.feedbackBuilder].
  final Map<String, dynamic>? extra;
}
