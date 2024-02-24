import 'dart:convert';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// This is an extension to make it easier to call
/// [showAndUploadToGitHub].
extension BetterFeedbackX on FeedbackController {
  /// Example usage:
  /// ```dart
  /// import 'package:feedback_github/feedback_github.dart';
  ///
  /// RaisedButton(
  ///   child: Text('Click me'),
  ///   onPressed: (){
  ///     BetterFeedback.of(context).showAndUploadToGitHub
  ///       username: 'username',
  ///       repository: 'repository',
  ///       authToken: 'github_pat_token',
  ///       labels: ['feedback'],
  ///       assignees: ['dash'],
  ///     );
  ///   }
  /// )
  /// ```
  /// The API token (Personal Access Token) needs access to:
  ///   - issues (read and write)
  ///   - metadata (read)
  /// See https://docs.github.com/en/enterprise-server@3.9/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
  void showAndUploadToGitHub({
    required String username,
    required String repository,
    required String authToken,
    List<String>? labels,
    List<String>? assignees,
    String? logs,
    String? githubUrl,
    http.Client? client,
  }) {
    show(uploadToGitLab(
      username: username,
      repository: repository,
      authToken: authToken,
      labels: labels,
      assignees: assignees,
      logs: logs,
      githubUrl: githubUrl,
      client: client,
    ));
  }
}

/// See [BetterFeedbackX.showAndUploadToGitHub].
/// This is just [visibleForTesting].
@visibleForTesting
OnFeedbackCallback uploadToGitLab({
  required String username,
  required String repository,
  required String authToken,
  List<String>? labels,
  List<String>? assignees,
  String? logs,
  String? githubUrl,
  http.Client? client,
}) {
  final httpClient = client ?? http.Client();
  final baseUrl = githubUrl ?? 'api.github.com';

  return (UserFeedback feedback) async {
    final uri = Uri.https(
      baseUrl,
      'repos/$username/$repository/issues',
    );

    // title contains first 20 characters of message, with a default for empty feedback
    final title = feedback.text.length > 20
        ? '${feedback.text.substring(0, 20)}...'
        : feedback.text.isEmpty
            ? 'New Feedback'
            : feedback.text;
    // body contains message and optional logs
    final body = '''${feedback.text}
    ${logs != null ? '''
<details>
<summary>Logs</summary>

```
$logs
```
</details>
''' : ''}
''';

    // https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#create-an-issue
    final response = await httpClient.post(
      uri,
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
        if (labels != null && labels.isNotEmpty) 'labels': labels,
        if (assignees != null && assignees.isNotEmpty) 'assignees': assignees,
      }),
    );

    print(response.body);

    if (response.statusCode == 201) {
      print('uploaded');
    } else {
      print('not uploaded');
    }
  };
}
