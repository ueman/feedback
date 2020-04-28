import 'package:flutter/cupertino.dart';

/// Configuration to talk to GitLab.
/// Currently only API v4 is supported.
class GitLabSettings {
  GitLabSettings({
    @required this.projectId,
    @required this.token,
    this.baseUrl = 'https://gitlab.com',
  })  : assert(projectId != null),
        assert(token != null),
        assert(baseUrl != null);

  /// The project ID of your GitLab Project. Can be found on the
  /// general settings page of the project. This should be a number;
  final String projectId;

  String get issueUrl => '$baseUrl/api/v4/projects/$projectId/issues';

  String get fileUploadUrl => '$baseUrl/api/v4/projects/$projectId/uploads';

  /// This must be a token with the `api` scope, otherwise it wont work.
  /// See https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#limiting-scopes-of-a-personal-access-token
  final String token;

  /// The url to your GitLab instance. Is per default 'https://gitlab.com'
  final String baseUrl;
}
