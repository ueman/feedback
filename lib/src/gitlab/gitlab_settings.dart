class GitLabSettings {
  GitLabSettings(this.projectId, this.token, this.baseUrl);

  final String projectId;
  String get issueUrl => '$baseUrl/api/v4/projects/$projectId/issues';

  String get fileUploadUrl => '$baseUrl/api/v4/projects/$projectId/uploads';
  final String token;

  final String baseUrl;
}
