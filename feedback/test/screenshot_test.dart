import 'dart:typed_data';

import 'package:feedback/src/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('screenshot test', () {
    testWidgets('take screenshot', (tester) async {
      final controller = ScreenshotController();
      final widget = Screenshot(
        controller: controller,
        child: const Example(),
      );

      Uint8List? screenshot;
      await tester.runAsync(() async {
        await tester.pumpWidget(widget);

        screenshot =
            await controller.capture(pixelRatio: 1, delay: Duration.zero);
      });

      expect(screenshot, isNotNull);
    });
  });
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
