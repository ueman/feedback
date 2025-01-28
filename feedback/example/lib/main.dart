import 'dart:io';

import 'package:example/feedback_functions.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
    final theme = FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.grey[50]!,
      drawColors: [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
      ],
    );
    final delegates = <LocalizationsDelegate<dynamic>>[
      GlobalFeedbackLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
    if (_useCustomFeedback) {
      return BetterFeedback<OnSubmit, UserFeedback>.customFeedback(
        feedbackBuilder: (context, onSubmit, formController) => CustomFeedbackForm(
          onSubmit: onSubmit,
          formController: formController,
        ),
        theme: theme,
        darkTheme: FeedbackThemeData.dark(),
        localizationsDelegates: delegates,
        localeOverride: const Locale('en'),
        mode: FeedbackMode.draw,
        child: MaterialApp(
          title: 'Feedback Demo',
          theme: ThemeData(
            primarySwatch: _useCustomFeedback ? Colors.green : Colors.blue,
          ),
          home: MyHomePage(_toggleCustomizedFeedback),
        ),
      );
    }
    return BetterFeedback.simpleFeedback(
      darkTheme: FeedbackThemeData.dark(),
      localizationsDelegates: delegates,
      localeOverride: const Locale('en'),
      mode: FeedbackMode.draw,
      child: MaterialApp(
        title: 'Feedback Demo',
        theme: ThemeData(
          primarySwatch: _useCustomFeedback ? Colors.green : Colors.blue,
        ),
        home: MyHomePage(_toggleCustomizedFeedback),
      ),
    );
  }

  void _toggleCustomizedFeedback() => setState(() => _useCustomFeedback = !_useCustomFeedback);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage(this.toggleCustomizedFeedback, {super.key});

  final VoidCallback toggleCustomizedFeedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_useCustomFeedback ? '(Custom) Feedback Example' : 'Feedback Example'),
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
                onPressed: () async {
                  // We're going to open the alert dialog after the feedback is complete, so
                  // there's no need to provide an `onSubmit` callback.
                  final feedback = await BetterFeedback.simpleFeedbackOf(context).show(null);
                  // User cancelled feedback before submitting and/or navigated away.
                  if (feedback == null || !context.mounted) return;
                  onSubmitAlertDialog(context, feedback);
                },
              ),
              const SizedBox(height: 10),
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                TextButton(
                  child: const Text('Provide E-Mail feedback'),
                  onPressed: () {
                    BetterFeedback.simpleFeedbackOf(context).show(onSubmitEmail);
                  },
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                child: const Text('Provide feedback via platform sharing'),
                onPressed: () {
                  BetterFeedback.simpleFeedbackOf(context).show(onSubmitPlatformSharing);
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: const Text('toggle feedback mode', style: TextStyle(color: Colors.white)),
        onPressed: () {
          // don't toggle the feedback mode if it's currently visible
          if (!BetterFeedback.simpleFeedbackOf(context).isVisible) {
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
