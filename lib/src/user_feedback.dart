import 'dart:typed_data';

/// Container for the feedback of the user.
class UserFeedback {
  UserFeedback({
    required this.text,
    required this.screenshot,
    this.extra,
  });

  /// Written feedback of the user
  final String text;

  /// A raw png encoded screenshot of the app. Hopefully annotated by helpful
  /// drawings of the user.
  final Uint8List? screenshot;

  /// Additional information. For user by custom Feedback Builders.
  final Map<String, dynamic>? extra;
}
