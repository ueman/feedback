import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:example/feedback_functions.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

bool _useCustomFeedback = false;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      // If custom feedback is not enabled, supply null and the default text
      // feedback form will be used.
      feedbackBuilder: _useCustomFeedback
          ? (context, onSubmit, scrollController) => CustomFeedbackForm(
                onSubmit: onSubmit,
                scrollController: scrollController,
              )
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
      darkTheme: FeedbackThemeData.dark(),
      localizationsDelegates: [
        GlobalFeedbackLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeOverride: const Locale('en'),
      mode: FeedbackMode.draw,
      pixelRatio: 1,
      child: MaterialApp(
        title: 'Feedback Demo',
        theme: ThemeData(
          primarySwatch: _useCustomFeedback ? Colors.green : Colors.blue,
        ),
        home: MyHomePage(_toggleCustomizedFeedback),
      ),
    );
  }

  void _toggleCustomizedFeedback() =>
      setState(() => _useCustomFeedback = !_useCustomFeedback);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage(this.toggleCustomizedFeedback, {super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
              const Divider(),
              ElevatedButton(
                child: const Text('Provide feedback'),
                onPressed: () {
                  BetterFeedback.of(context).show(
                    (feedback) async {
                      // upload to server, share whatever
                      // for example purposes just show it to the user
                      alertFeedbackFunction(
                        context,
                        feedback,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                TextButton(
                  child: const Text('Provide E-Mail feedback'),
                  onPressed: () {
                    BetterFeedback.of(context).show((feedback) async {
                      // draft an email and send to developer
                      final screenshotFilePath =
                          await writeImageToStorage(feedback.screenshot);

                      final Email email = Email(
                        body: feedback.text,
                        subject: 'App Feedback',
                        recipients: ['john.doe@flutter.dev'],
                        attachmentPaths: [screenshotFilePath],
                        isHTML: false,
                      );
                      await FlutterEmailSender.send(email);
                    });
                  },
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                child: const Text('Provide feedback via platform sharing'),
                onPressed: () {
                  BetterFeedback.of(context).show(
                    (feedback) async {
                      final screenshotFilePath =
                          await writeImageToStorage(feedback.screenshot);

                      // ignore: deprecated_member_use
                      await Share.shareFiles(
                        [screenshotFilePath],
                        text: feedback.text,
                      );
                    },
                  );
                },
              ),
              const Divider(),
              const Text('This is the example app for the "feedback" library.'),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Visit library page on pub.dev'),
                onPressed: () {
                  launchUrl(Uri.parse('https://pub.dev/packages/feedback'));
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Open Dialog #1'),
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Dialog #1"),
                        content: Container(),
                      );
                    },
                  );
                },
              ),
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
          if (!BetterFeedback.of(context).isVisible) {
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
  BetterFeedback.of(context).show((feedback) async {
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
  });
}
