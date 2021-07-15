import 'dart:typed_data';
import 'package:feedback/src/better_feedback.dart';

/// Container for the feedback of the user.
class UserFeedback {
  UserFeedback({
    required this.text,
    required this.screenshot,
    this.extra,
  });

  /// The user's written feedback
  final String text;

  /// A raw png encoded screenshot of the app. Hopefully annotated by helpful
  /// drawings by the user.
  final Uint8List screenshot;

  /// Additional information.
  /// For use by custom [BetterFeedback.feedbackBuilder].
  final Map<String, dynamic>? extra;
}
