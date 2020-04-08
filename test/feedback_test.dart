import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BetterFeedback', () {
    testWidgets(' can open feedback', (tester) async {
      final widget = BetterFeedback(
        child: const MyApp(),
        onFeedback: (
          BuildContext context,
          String feedbackText,
          Uint8List feedbackScreenshot,
        ) {
          // upload to server, share whatever
        },
      );

      await tester.pumpWidget(widget);

      // feedback is closed
      var userInputFields = find.byKey(const Key('feedback_user_input_fields'));

      expect(userInputFields, findsNothing);

      // open feedback
      final openFeedbackButton = find.byKey(const Key('open_feedback'));

      await tester.tap(openFeedbackButton);

      await tester.pumpAndSettle();
      expect(userInputFields, findsOneWidget);
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyTestPage(title: 'Feedback Test Page'),
    );
  }
}

class MyTestPage extends StatefulWidget {
  const MyTestPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyTestPageState createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
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
              style: Theme.of(context).textTheme.display1,
            ),
            const TextField(),
            FlatButton(
              key: const Key('open_feedback'),
              child: const Text('Get feedback'),
              onPressed: () {
                BetterFeedback.of(context).show();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
