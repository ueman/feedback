import 'package:feedback/feedback.dart';
import 'package:feedback/src/controls_column.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  Widget create({
    Color activeColor,
    ControlMode mode,
    ValueChanged<Color> onColorChanged,
    VoidCallback onUndo,
    ValueChanged<ControlMode> onControlModeChanged,
    VoidCallback onCloseFeedback,
    VoidCallback onClearDrawing,
    List<Color> colors,
    FeedbackTranslation translation,
  }) {
    return MaterialApp(
      home: ControlsColumn(
        activeColor: activeColor ?? Colors.red,
        mode: mode ?? ControlMode.draw,
        colors:
            colors ?? [Colors.red, Colors.green, Colors.blue, Colors.yellow],
        onClearDrawing: onClearDrawing ?? () {},
        onCloseFeedback: onCloseFeedback ?? () {},
        onColorChanged: onColorChanged ?? (newColor) {},
        onControlModeChanged: onControlModeChanged ?? (newMode) {},
        onUndo: onUndo ?? () {},
        translation: EnTranslation(),
      ),
    );
  }

  group('ControlsColumn', () {
    testWidgets(' close callback', (tester) async {
      var closeButtonCallbackExecuted = false;

      await tester.pumpWidget(create(onCloseFeedback: () {
        closeButtonCallbackExecuted = true;
      }));

      final closeButton = find.byKey(const Key('close_controls_column'));
      await tester.tap(closeButton);

      expect(closeButtonCallbackExecuted, true);
    });

    testWidgets(' change navigation to drawing', (tester) async {
      var mode = ControlMode.navigate;

      await tester.pumpWidget(create(
          mode: mode,
          onControlModeChanged: (newMode) {
            mode = newMode;
          }));

      final drawButton = find.byKey(const Key('draw_button'));
      await tester.tap(drawButton);

      expect(mode, ControlMode.draw);
    });

    testWidgets(' change drawing to navigating', (tester) async {
      var mode = ControlMode.draw;

      await tester.pumpWidget(create(
          mode: mode,
          onControlModeChanged: (newMode) {
            mode = newMode;
          }));

      final navigateButton = find.byKey(const Key('navigate_button'));
      await tester.tap(navigateButton);

      expect(mode, ControlMode.navigate);
    });

    testWidgets(' drawing is inactive while navigating', (tester) async {
      var drawingCallbackWasCalled = false;
      final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

      await tester.pumpWidget(create(
          colors: colors,
          mode: ControlMode.navigate,
          onClearDrawing: () {
            drawingCallbackWasCalled = true;
          },
          onColorChanged: (_) {
            drawingCallbackWasCalled = true;
          },
          onUndo: () {
            drawingCallbackWasCalled = true;
          }));

      final undoButton = find.byKey(const Key('undo_button'));
      await tester.tap(undoButton);

      final clearButton = find.byKey(const Key('clear_button'));
      await tester.tap(clearButton);

      for (final color in colors) {
        final colorButton = find.byKey(ValueKey<Color>(color));
        await tester.tap(colorButton);
      }

      expect(drawingCallbackWasCalled, false);
    });

    testWidgets(' change color', (tester) async {
      Color color;
      final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

      await tester.pumpWidget(create(
          mode: ControlMode.draw,
          colors: colors,
          activeColor: colors[0],
          onColorChanged: (newColor) {
            color = newColor;
          }));

      final greenColorButton = find.byKey(ValueKey<Color>(colors[1]));
      await tester.tap(greenColorButton);

      expect(color, colors[1]);
    });
  });
}
