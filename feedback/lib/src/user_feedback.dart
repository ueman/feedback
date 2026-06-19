import 'dart:typed_data';
import 'package:feedback/src/better_feedback.dart';

/// Container for the feedback of the user.
class UserFeedback {
  /// Creates an [UserFeedback].
  /// Typically never used by a user of this library.
  const UserFeedback({
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

  /// Creates a copy of this [UserFeedback] with the given fields replaced
  /// by new values.
  ///
  /// Any parameter that is omitted will default to the value of the
  /// corresponding field in this instance.
  UserFeedback copyWith({
    String? text,
    Uint8List? screenshot,
    Map<String, dynamic>? extra,
  }) {
    return UserFeedback(
      text: text ?? this.text,
      screenshot: screenshot ?? this.screenshot,
      extra: extra ?? this.extra,
    );
  }
}
