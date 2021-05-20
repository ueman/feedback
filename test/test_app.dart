import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class MyTestApp extends StatelessWidget {
  const MyTestApp({Key? key, this.onFeedback}) : super(key: key);

  final OnFeedbackCallback? onFeedback;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyTestPage(
        title: 'Feedback Test Page',
        onFeedback: onFeedback,
      ),
    );
  }
}

class MyTestPage extends StatefulWidget {
  const MyTestPage({
    Key? key,
    required this.title,
    this.onFeedback,
  }) : super(key: key);

  final String title;
  final OnFeedbackCallback? onFeedback;

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
              style: Theme.of(context).textTheme.headline4,
            ),
            const TextField(),
            TextButton(
              key: const Key('open_feedback'),
              child: const Text('open feedback'),
              onPressed: () {
                BetterFeedback.of(context)!
                    .show(widget.onFeedback ?? (_, __) {});
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
