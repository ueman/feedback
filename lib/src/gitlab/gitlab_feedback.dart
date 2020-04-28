import 'dart:convert';
import 'dart:typed_data';

import 'package:feedback/src/gitlab/file_upload_reponse.dart';
import 'package:feedback/src/gitlab/gitlab_settings.dart';
import 'package:feedback/src/gitlab/issue.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Tries to create a new issue with the given [feedback] and [pngImage] at
/// the GitLab instance as defined in [settings].
/// If successful it returns the link to the created issue.
/// REMARKS: This method does not do any exception handling, so if unsuccessful
/// it may return nothing or throw an exception.
Future<String> gitlabFeedback(
  GitLabSettings settings,
  String feedback,
  Uint8List pngImage,
) async {
  final file = await uploadFile(settings, pngImage);

  final issue = IssuePostContent(
    'feedback_${DateTime.now().toIso8601String()}',
    '$feedback  ${file.markdown}',
    'feedback',
  );

  final response =
      await post(settings.issueUrl + issue.toUrlParameter(), headers: {
    'PRIVATE-TOKEN': settings.token,
  });

  final newlyCreatedIssue =
      IssueResponse.fromJson(json.decode(response.body) as Map);
  return newlyCreatedIssue.webUrl;
}

Future<FileUploadResponse> uploadFile(
  GitLabSettings settings,
  Uint8List pngImage,
) async {
  final uri = Uri.parse(settings.fileUploadUrl);
  final request = http.MultipartRequest('POST', uri)
    ..headers['PRIVATE-TOKEN'] = settings.token
    ..fields['id'] = settings.projectId.toString()
    ..files.add(http.MultipartFile.fromBytes(
      'file',
      pngImage,
      filename: 'screenshot.png',
      contentType: MediaType('image', 'png'),
    ));
  final response = await request.send();
  final responseString = await response.stream.bytesToString();
  return FileUploadResponse.fromJson(json.decode(responseString) as Map);
}
