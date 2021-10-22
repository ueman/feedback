import 'dart:convert';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// This is an extension to make it easier to call
/// [showAndUploadToGitLab].
extension BetterFeedbackX on FeedbackController {
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
  void showAndUploadToGitLab({
    required String projectId,
    required String apiToken,
    String? gitlabUrl,
    http.Client? client,
  }) {
    show(uploadToGitLab(
      projectId: projectId,
      apiToken: apiToken,
      gitlabUrl: gitlabUrl,
      client: client,
    ));
  }
}

/// See [BetterFeedbackX.showAndUploadToGitLab].
/// This is just [visibleForTesting].
@visibleForTesting
OnFeedbackCallback uploadToGitLab({
  required String projectId,
  required String apiToken,
  String? gitlabUrl,
  http.Client? client,
}) {
  final httpClient = client ?? http.Client();
  final baseUrl = gitlabUrl ?? 'gitlab.com';

  return (UserFeedback feedback) async {
    final uri = Uri.https(
      baseUrl,
      '/api/v4/projects/$projectId/uploads',
    );
    final uploadRequest = http.MultipartRequest('POST', uri)
      ..headers.putIfAbsent('PRIVATE-TOKEN', () => apiToken)
      ..fields['id'] = projectId
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        feedback.screenshot,
        filename: 'feedback.png',
        contentType: MediaType('image', 'png'),
      ));

    final uploadResponse = await httpClient.send(uploadRequest);

    final dynamic uploadResponseMap = jsonDecode(
      await uploadResponse.stream.bytesToString(),
    );

    final imageMarkdown = uploadResponseMap["markdown"] as String?;
    final extras = feedback.extra?.toString() ?? '';

    final description = '${feedback.text}\n'
        '${imageMarkdown ?? 'Missing image!'}\n'
        '$extras';

    // Create issue
    await httpClient.post(
      Uri.https(
        baseUrl,
        '/api/v4/projects/$projectId/issues',
        <String, String>{
          'title': feedback.text,
          'description': description,
        },
      ),
      headers: {'PRIVATE-TOKEN': apiToken},
    );
  };
}
