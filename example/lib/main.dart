import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:feedback/feedback.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    BetterFeedback(
      child: const MyApp(),
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
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Open another scaffold'),
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
            TextButton(
              child: const Text('Provide feedback'),
              onPressed: () {
                BetterFeedback.of(context)?.show(
                  (
                    String feedbackText,
                    Uint8List? feedbackScreenshot,
                  ) async {
                    // upload to server, share whatever
                    // for example purposes just show it to the user
                    alertFeedbackFunction(
                        context, feedbackText, feedbackScreenshot);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: !kIsWeb && (Platform.isAndroid || Platform.isIOS),
              child: TextButton(
                child: const Text('Provide E-Mail feedback'),
                onPressed: () {
                  BetterFeedback.of(context)?.show(
                    (
                      String feedbackText,
                      Uint8List? feedbackScreenshot,
                    ) async {
                      // draft an email and send to developer
                      final Directory output = await getTemporaryDirectory();
                      final String screenshotFilePath =
                          '${output.path}/feedback.png';
                      final File screenshotFile = File(screenshotFilePath);
                      await screenshotFile.writeAsBytes(feedbackScreenshot!);

                      final Email email = Email(
                        body: feedbackText,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
