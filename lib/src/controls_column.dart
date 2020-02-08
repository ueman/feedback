import 'package:flutter/material.dart';

/// The parameter describes wether drawing is active (true)
/// or inactive (false).
typedef IsDrawActiveChangedCallback = void Function(bool);

typedef OnColorChangedCallback = void Function(Color);

class ControlsColumn extends StatefulWidget {
  const ControlsColumn({
    Key key,
    @required this.onColorChanged,
    @required this.onUndo,
    @required this.onModeChanged,
    @required this.onCloseFeedback,
    @required this.onClearDrawing,
  })  : assert(onColorChanged != null),
        assert(onUndo != null),
        assert(onModeChanged != null),
        assert(onCloseFeedback != null),
        assert(onClearDrawing != null),
        super(key: key);

  final OnColorChangedCallback onColorChanged;
  final VoidCallback onUndo;
  final IsDrawActiveChangedCallback onModeChanged;
  final VoidCallback onCloseFeedback;
  final VoidCallback onClearDrawing;

  @override
  _ControlsColumnState createState() => _ControlsColumnState();
}

const _colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
];

class _ControlsColumnState extends State<ControlsColumn> {
  Color activeColor = Colors.red;
  bool isNavigatingActive = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onCloseFeedback,
          ),
          _ColumnDivider(),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: isNavigatingActive
                ? null
                : () {
                    setState(() {
                      isNavigatingActive = true;
                    });
                    widget.onModeChanged(isNavigatingActive);
                  },
          ),
          _ColumnDivider(),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: isNavigatingActive
                ? () {
                    setState(() {
                      isNavigatingActive = false;
                    });
                    widget.onModeChanged(isNavigatingActive);
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: isNavigatingActive ? null : widget.onUndo,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: isNavigatingActive ? null : widget.onClearDrawing,
          ),
          for (final color in _colors)
            _ColorSelectionIconButton(
              color: color,
              onPressed: isNavigatingActive
                  ? null
                  : (col) {
                      setState(() {
                        activeColor = col;
                      });
                      widget.onColorChanged(col);
                    },
              isActive: activeColor == color,
            ),
        ],
      ),
    );
  }
}

typedef OnColorPressed = Function(Color);

class _ColorSelectionIconButton extends StatelessWidget {
  const _ColorSelectionIconButton({
    Key key,
    this.color,
    this.onPressed,
    this.isActive,
  }) : super(key: key);

  final Color color;
  final OnColorPressed onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isActive ? Icons.check_circle : Icons.check_circle_outline),
      color: color,
      onPressed: onPressed == null
          ? null
          : () {
              onPressed(color);
            },
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
