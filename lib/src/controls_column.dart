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
    @required this.colors,
  })  : assert(onColorChanged != null),
        assert(onUndo != null),
        assert(onModeChanged != null),
        assert(onCloseFeedback != null),
        assert(onClearDrawing != null),
        assert(
          // ignore: prefer_is_empty
          colors != null && colors.length > 0,
          'There must be at least one color to draw',
        ),
        super(key: key);

  final OnColorChangedCallback onColorChanged;
  final VoidCallback onUndo;
  final IsDrawActiveChangedCallback onModeChanged;
  final VoidCallback onCloseFeedback;
  final VoidCallback onClearDrawing;
  final List<Color> colors;

  @override
  _ControlsColumnState createState() => _ControlsColumnState();
}

class _ControlsColumnState extends State<ControlsColumn> {
  Color activeColor;
  bool isNavigatingActive = true;

  @override
  void initState() {
    super.initState();
    activeColor = widget.colors[0];
  }

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
            icon: Icon(Icons.navigation),
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
          for (final color in widget.colors)
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
      icon: Icon(isActive ? Icons.lens : Icons.panorama_fish_eye),
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
