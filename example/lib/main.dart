import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

bool _useCustomFeedback = false;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      child: MaterialApp(
        title: 'Feedback Demo',
        theme: ThemeData(
          primarySwatch: _useCustomFeedback ? Colors.green : Colors.blue,
        ),
        home: MyHomePage(_toggleCustomizedFeedback),
      ),
      // If custom feedback is not enabled, supply null and the default text
      // feedback form will be used.
      getFeedback: _useCustomFeedback
          ? (onSubmit) => CustomFeedbackForm(onSubmit: onSubmit)
          : null,
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalFeedbackLocalizationsDelegate(),
      ],
      localeOverride: const Locale('en'),
      mode: FeedbackMode.navigate,
      pixelRatio: 1,
    );
  }

  void _toggleCustomizedFeedback() =>
      setState(() => _useCustomFeedback = !_useCustomFeedback);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage(this.toggleCustomizedFeedback, {Key? key}) : super(key: key);

  final VoidCallback toggleCustomizedFeedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_useCustomFeedback
            ? '(Custom) Feedback Example'
            : 'Feedback Example'),
      ),
      drawer: Drawer(
        child: Container(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text('This is the example app for the "feedback" library.'),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Go to library page on pub.dev'),
                onPressed: () {
                  launch('https://pub.dev/packages/feedback');
                },
              ),
              const SizedBox(height: 10),
              const MarkdownBody(
                data: '# How does it work?\n'
                    '1. Just press the `Provide feedback` button.\n'
                    '2. The feedback view opens. '
                    'You can choose between draw and navigation mode. '
                    'When in navigate mode, you can freely navigate in the '
                    'app. Try it by opening the navigation drawer or by '
                    'tapping the `Open scaffold` button. To switch to the '
                    'drawing mode just press the `Draw` button on the right '
                    'side. Now you can draw on the screen.\n'
                    '3. To finish your feedback just write a message '
                    'below and send it by pressing the `Submit` button.',
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Open scaffold'),
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return _SecondaryScaffold();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Provide feedback'),
                onPressed: () {
                  BetterFeedback.of(context)!.show(
                    (
                      Object feedback,
                      Uint8List? feedbackScreenshot,
                    ) async {
                      // upload to server, share whatever
                      // for example purposes just show it to the user
                      alertFeedbackFunction(
                        context,
                        _feedbackToString(feedback),
                        feedbackScreenshot,
                      );
                    },
                  );
                },
              ),
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Provide E-Mail feedback'),
                  onPressed: () {
                    BetterFeedback.of(context)!.show(
                      (
                        Object feedback,
                        Uint8List? feedbackScreenshot,
                      ) async {
                        // draft an email and send to developer
                        final screenshotFilePath =
                            await writeImageToStorage(feedbackScreenshot!);

                        final Email email = Email(
                          body: _feedbackToString(feedback),
                          subject: 'App Feedback',
                          recipients: ['john.doe@flutter.dev'],
                          attachmentPaths: [screenshotFilePath],
                          isHTML: false,
                        );
                        await FlutterEmailSender.send(email);
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Provide feedback via platform sharing'),
                  onPressed: () {
                    BetterFeedback.of(context)!.show(
                      (
                        Object feedback,
                        Uint8List? feedbackScreenshot,
                      ) async {
                        final screenshotFilePath =
                            await writeImageToStorage(feedbackScreenshot!);

                        await Share.shareFiles(
                          [screenshotFilePath],
                          text: _feedbackToString(feedback),
                        );
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: const Text('toggle feedback mode',
            style: TextStyle(color: Colors.white)),
        onPressed: () {
          // don't toggle the feedback mode if it's currently visible
          if (!BetterFeedback.of(context)!.isVisible) {
            toggleCustomizedFeedback();
          }
        },
      ),
    );
  }
}

class _SecondaryScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold 2'),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

Future<void> createGitlabIssueFromFeedback(BuildContext context) async {
  BetterFeedback.of(context)!.show((
    feedbackText,
    feedbackScreenshot,
  ) async {
    const projectId = 'your-gitlab-project-id';
    const apiToken = 'your-gitlab-api-token';

    final screenshotFilePath = await writeImageToStorage(feedbackScreenshot!);

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
          'title': (feedbackText as String).padRight(80),
          'description': '$feedbackText\n'
              "${uploadResponseMap["markdown"] ?? "Missing image!"}",
        },
      ),
      headers: {
        'PRIVATE-TOKEN': apiToken,
      },
    );
  });
}

String _feedbackToString(Object feedback) {
  if (feedback is String) {
    return feedback;
  }
  // We must currently be using the custom feedback form. Cast to the correct
  // type and convert to string.
  return (feedback as CustomFeedback).toString();
}
