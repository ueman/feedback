import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key, this.onFeedback});

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
    super.key,
    required this.title,
    this.onFeedback,
  });

  final String title;
  final OnFeedbackCallback? onFeedback;

  @override
  MyTestPageState createState() => MyTestPageState();
}

@visibleForTesting
class MyTestPageState extends State<MyTestPage> {
  @visibleForTesting
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void popPage() => Navigator.of(context).pop();

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
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const TextField(),
            TextButton(
              key: const Key('open_feedback'),
              child: const Text('open feedback'),
              onPressed: () {
                BetterFeedback.of(context).show(widget.onFeedback ?? (_) {});
              },
            ),
            TextButton(
              key: const Key('change_page'),
              child: const Text('change page'),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Container(
                      key: const Key('new_page'),
                      child: const Text(
                        'Hey look at me I\'m a new page!',
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_button'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
