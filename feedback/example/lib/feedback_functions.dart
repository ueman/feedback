// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Map from a string route to the underlying feedback route and it's corresponding `onSubmit`.
/// This is just here to support the legacy `simpleFeedback` API.
Future<void> onSubmitWithStringRoute(
  BuildContext context,
  String? route,
  UserFeedback feedback,
) {
  return switch (route) {
    'alert_dialog' => onSubmitAlertDialog(context, feedback),
    'email' => onSubmitEmail(context, feedback),
    'platform_sharing' => onSubmitPlatformSharing(context, feedback),
    _ => throw UnsupportedError('Unsupported route: `$route`'),
  };
}

Future<void> onSubmitEmail(BuildContext context, UserFeedback feedback) async {
  // draft an email and send to developer
  final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

  final Email email = Email(
    body: feedback.text,
    subject: 'App Feedback',
    recipients: ['john.doe@flutter.dev'],
    attachmentPaths: [screenshotFilePath],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}

Future<void> onSubmitPlatformSharing(BuildContext context, UserFeedback feedback) async {
  final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

  // ignore: deprecated_member_use
  await Share.shareFiles(
    [screenshotFilePath],
    text: feedback.text,
  );
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

/// Prints the given feedback to the console.
/// This is useful for debugging purposes.
void consoleFeedbackFunction(
  BuildContext context,
  UserFeedback feedback,
) {
  print('Feedback text:');
  print(feedback.text);
  print('Size of image: ${feedback.screenshot.length}');
  if (feedback.extra != null) {
    print('Extras: ${feedback.extra!.toString()}');
  }
}

Future<void> onSubmitAlertDialog(BuildContext context, UserFeedback feedback) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(feedback.text),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (feedback.extra != null) Text(feedback.extra!.toString()),
              Image.memory(
                feedback.screenshot,
                height: 600,
                width: 500,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

Future<void> createGitlabIssueFromFeedback(BuildContext context, UserFeedback feedback) async {
  const projectId = 'your-gitlab-project-id';
  const apiToken = 'your-gitlab-api-token';

  final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

  // Upload screenshot
  final uploadRequest = http.MultipartRequest(
    'POST',
    Uri.https(
      'gitlab.com',
      '/api/v4/projects/$projectId/uploads',
    ),
  )
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      screenshotFilePath,
    ))
    ..headers.putIfAbsent('PRIVATE-TOKEN', () => apiToken);
  final uploadResponse = await uploadRequest.send();

  final dynamic uploadResponseMap = jsonDecode(
    await uploadResponse.stream.bytesToString(),
  );

  // Create issue
  await http.post(
    Uri.https(
      'gitlab.com',
      '/api/v4/projects/$projectId/issues',
      <String, String>{
        'title': feedback.text.padRight(80),
        'description': '${feedback.text}\n'
            "${uploadResponseMap["markdown"] ?? "Missing image!"}",
      },
    ),
    headers: {
      'PRIVATE-TOKEN': apiToken,
    },
  );
}
