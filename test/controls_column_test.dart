import 'package:feedback/src/controls_column.dart';
import 'package:feedback/src/l18n/localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  Widget create({
    Color? activeColor,
    ControlMode? mode,
    ValueChanged<Color>? onColorChanged,
    VoidCallback? onUndo,
    ValueChanged<ControlMode>? onControlModeChanged,
    VoidCallback? onCloseFeedback,
    VoidCallback? onClearDrawing,
    List<Color>? colors,
  }) {
    return FeedbackLocalization(
      child: ControlsColumn(
        activeColor: activeColor ?? Colors.red,
        mode: mode ?? ControlMode.draw,
        colors:
            colors ?? [Colors.red, Colors.green, Colors.blue, Colors.yellow],
        onClearDrawing: onClearDrawing ?? () {},
        onCloseFeedback: onCloseFeedback ?? () {},
        onColorChanged: onColorChanged ?? (newColor) {},
        onControlModeChanged: onControlModeChanged ?? (newMode) {},
        onUndo: onUndo ?? () {},
      ),
    );
  }

  group('ControlsColumn', () {
    testWidgets(' close callback', (tester) async {
      var closeButtonCallbackExecuted = false;

      await tester.pumpWidget(
        create(
          onCloseFeedback: () {
            closeButtonCallbackExecuted = true;
          },
        ),
      );

      await tester.pumpAndSettle();

      final closeButton =
          find.byKey(const ValueKey<String>('close_controls_column'));
      await tester.tap(closeButton);

      expect(closeButtonCallbackExecuted, true);
    });

    testWidgets(' change drawing to navigating', (tester) async {
      var mode = ControlMode.draw;

      await tester.pumpWidget(
        create(
          mode: mode,
          onControlModeChanged: (newMode) {
            mode = newMode;
          },
        ),
      );
      await tester.pumpAndSettle();

      final navigateButton =
          find.byKey(const ValueKey<String>('navigate_button'));
      await tester.tap(navigateButton);

      expect(mode, ControlMode.navigate);
    });

    testWidgets(' can launch with drawing mode', (tester) async {
      var drawingCallbackWasCalled = false;
      final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

      await tester.pumpWidget(
        create(
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
          },
        ),
      );
      await tester.pumpAndSettle();
      final undoButton = find.byKey(const ValueKey<String>('undo_button'));
      await tester.tap(undoButton);

      final clearButton = find.byKey(const ValueKey<String>('clear_button'));
      await tester.tap(clearButton);

      for (final color in colors) {
        final colorButton = find.byKey(ValueKey<Color>(color));
        await tester.tap(colorButton);
      }

      expect(drawingCallbackWasCalled, false);
    });

    testWidgets(' drawing is inactive while navigating', (tester) async {
      var drawingCallbackWasCalled = false;
      final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

      await tester.pumpWidget(
        create(
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
          },
        ),
      );
      await tester.pumpAndSettle();
      final undoButton = find.byKey(const ValueKey<String>('undo_button'));
      await tester.tap(undoButton);

      final clearButton = find.byKey(const ValueKey<String>('clear_button'));
      await tester.tap(clearButton);

      for (final color in colors) {
        final colorButton = find.byKey(ValueKey<Color>(color));
        await tester.tap(colorButton);
      }

      expect(drawingCallbackWasCalled, false);
    });

    testWidgets(' change color', (tester) async {
      final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
      Color color = colors[0];

      await tester.pumpWidget(
        create(
          mode: ControlMode.draw,
          colors: colors,
          activeColor: colors[0],
          onColorChanged: (newColor) {
            color = newColor;
          },
        ),
      );

      await tester.pumpAndSettle();

      final greenColorButton = find.byKey(ValueKey<Color>(colors[1]));
      await tester.tap(greenColorButton);

      expect(color, colors[1]);
    });
  });
}
