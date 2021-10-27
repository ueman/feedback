import 'dart:typed_data';
import 'package:feedback/src/better_feedback.dart';

/// Container for the feedback of the user.
class UserFeedback {
  /// Creates an [UserFeedback].
  /// Typically never used by a user of this library.
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

  /// This can contain additional information. By default this is always empty.
  /// When using a custom [BetterFeedback.feedbackBuilder] this can be used
  /// to supply additional information.
  final Map<String, dynamic>? extra;
}
