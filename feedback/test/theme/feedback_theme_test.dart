import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copyWith overwrites all properties without changing original', () {
    final theme = FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.white,
      feedbackSheetHeight: .25,
      activeFeedbackModeColor: Colors.blue,
      drawColors: [Colors.orange, Colors.green],
      bottomSheetDescriptionStyle: const TextStyle(color: Colors.black),
      bottomSheetTextInputStyle: const TextStyle(color: Colors.white),
      sheetIsDraggable: true,
      brightness: Brightness.light,
      dragHandleColor: Colors.white,
      colorScheme: const ColorScheme.light(),
    );

    final copy = theme.copyWith(
      background: Colors.red,
      feedbackSheetColor: Colors.blue,
      feedbackSheetHeight: .5,
      activeFeedbackModeColor: Colors.green,
      drawColors: [Colors.red, Colors.blue],
      bottomSheetDescriptionStyle: const TextStyle(color: Colors.green),
      bottomSheetTextInputStyle: const TextStyle(color: Colors.yellow),
      sheetIsDraggable: false,
      brightness: Brightness.dark,
      dragHandleColor: Colors.black,
      colorScheme: const ColorScheme.dark(),
    );

    // ensure overrides apply
    expect(copy.background, Colors.red);
    expect(copy.feedbackSheetColor, Colors.blue);
    expect(copy.feedbackSheetHeight, .5);
    expect(copy.activeFeedbackModeColor, Colors.green);
    expect(copy.drawColors, [Colors.red, Colors.blue]);
    expect(copy.bottomSheetDescriptionStyle, const TextStyle(color: Colors.green));
    expect(copy.bottomSheetTextInputStyle, const TextStyle(color: Colors.yellow));
    expect(copy.sheetIsDraggable, false);
    expect(copy.brightness, Brightness.dark);
    expect(copy.dragHandleColor, Colors.black);
    expect(copy.colorScheme, const ColorScheme.dark());

    // ensure original theme is not modified
    expect(theme.background, Colors.grey);
    expect(theme.feedbackSheetColor, Colors.white);
    expect(theme.feedbackSheetHeight, .25);
    expect(theme.activeFeedbackModeColor, Colors.blue);
    expect(theme.drawColors, [Colors.orange, Colors.green]);
    expect(theme.bottomSheetDescriptionStyle, const TextStyle(color: Colors.black));
    expect(theme.bottomSheetTextInputStyle, const TextStyle(color: Colors.white));
    expect(theme.sheetIsDraggable, true);
    expect(theme.brightness, Brightness.light);
    expect(theme.dragHandleColor, Colors.white);
    expect(theme.colorScheme, const ColorScheme.light());
  });
}
