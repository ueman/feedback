import 'package:feedback/src/feedback_mode.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// This is the Widget on the right side of the app when the feedback view
/// is active.
class ControlsColumn extends StatelessWidget {
  ControlsColumn({
    Key? key,
    required this.mode,
    required this.activeColor,
    required this.onColorChanged,
    required this.onUndo,
    required this.onControlModeChanged,
    required this.onCloseFeedback,
    required this.onClearDrawing,
    required this.colors,
  })   : assert(
          colors.isNotEmpty,
          'There must be at least one color to draw in colors',
        ),
        assert(colors.contains(activeColor), 'colors must contain activeColor'),
        super(key: key);

  final ValueChanged<Color> onColorChanged;
  final VoidCallback onUndo;
  final ValueChanged<FeedbackMode> onControlModeChanged;
  final VoidCallback onCloseFeedback;
  final VoidCallback onClearDrawing;
  final List<Color> colors;
  final Color activeColor;
  final FeedbackMode mode;

  @override
  Widget build(BuildContext context) {
    final isNavigatingActive = FeedbackMode.navigate == mode;
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            key: const ValueKey<String>('close_controls_column'),
            icon: const Icon(Icons.close),
            onPressed: onCloseFeedback,
          ),
          _ColumnDivider(),
          RotatedBox(
            quarterTurns: 1,
            child: MaterialButton(
              key: const ValueKey<String>('navigate_button'),
              child: Text(FeedbackLocalizations.of(context).navigate),
              onPressed: isNavigatingActive
                  ? null
                  : () => onControlModeChanged(FeedbackMode.navigate),
              disabledTextColor:
                  FeedbackTheme.of(context).activeFeedbackModeColor,
            ),
          ),
          _ColumnDivider(),
          RotatedBox(
            quarterTurns: 1,
            child: MaterialButton(
              key: const ValueKey<String>('draw_button'),
              minWidth: 20,
              child: Text(FeedbackLocalizations.of(context).draw),
              onPressed: isNavigatingActive
                  ? () => onControlModeChanged(FeedbackMode.draw)
                  : null,
              disabledTextColor:
                  FeedbackTheme.of(context).activeFeedbackModeColor,
            ),
          ),
          IconButton(
            key: const ValueKey<String>('undo_button'),
            icon: const Icon(Icons.undo),
            onPressed: isNavigatingActive ? null : onUndo,
          ),
          IconButton(
            key: const ValueKey<String>('clear_button'),
            icon: const Icon(Icons.delete),
            onPressed: isNavigatingActive ? null : onClearDrawing,
          ),
          for (final color in colors)
            _ColorSelectionIconButton(
              key: ValueKey<Color>(color),
              color: color,
              onPressed: isNavigatingActive ? null : onColorChanged,
              isActive: activeColor == color,
            ),
        ],
      ),
    );
  }
}

class _ColorSelectionIconButton extends StatelessWidget {
  const _ColorSelectionIconButton({
    Key? key,
    required this.color,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  final Color color;
  final ValueChanged<Color>? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isActive ? Icons.lens : Icons.panorama_fish_eye),
      color: color,
      onPressed: onPressed == null ? null : () => onPressed!(color),
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
