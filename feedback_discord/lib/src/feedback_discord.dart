import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// This is an extension to make it easier to call
/// [showAndUploadToGitLab].
extension BetterFeedbackDiscord on FeedbackController {
  /// Example usage:
  /// ```dart
  /// import 'package:feedback_gitlab/feedback_gitlab.dart';
  ///
  /// RaisedButton(
  ///   child: Text('Click me'),
  ///   onPressed: (){
  ///     BetterFeedback.of(context).showAndUploadToGitLab
  ///       projectId: 'gitlab-project-id',
  ///       apiToken: 'gitlab-api-token',
  ///       gitlabUrl: 'gitlab.org', // optional, defaults to 'gitlab.com'
  ///     );
  ///   }
  /// )
  /// ```
  /// The API token needs access to:
  ///   - read_api
  ///   - write_repository
  /// See https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#limiting-scopes-of-a-project-access-token
  void showAndUploadToDiscord({
    required String channel,
    required String discordUrl,
    http.Client? client,
  }) {
    show(uploadToDiscord(
      channel: channel,
      discordUrl: discordUrl,
      client: client,
    ));
  }
}

/// See [BetterFeedbackX.showAndUploadToGitLab].
/// This is just [visibleForTesting].
@visibleForTesting
OnFeedbackCallback uploadToDiscord({
  required String channel,
  required String discordUrl,
  http.Client? client,
}) {
  final httpClient = client ?? http.Client();
  final baseUrl = discordUrl;

  return (UserFeedback feedback) async {
    final uri = Uri.parse(
      baseUrl,
    );
    final uploadRequest = http.MultipartRequest('POST', uri)
      ..fields['content'] = 'FeedbackTest'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        feedback.screenshot,
        filename: 'feedback.png',
        contentType: MediaType('image', 'png'),
      ));

    await httpClient.send(uploadRequest);
  };
}
