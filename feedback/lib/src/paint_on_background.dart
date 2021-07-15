import 'package:feedback/src/painter.dart';
import 'package:flutter/material.dart';

class PaintOnChild extends StatelessWidget {
  const PaintOnChild({
    Key? key,
    required this.child,
    required this.isPaintingActive,
    required this.controller,
  }) : super(key: key);

  final Widget child;
  final bool isPaintingActive;
  final PainterController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isPaintingActive) Painter(controller),
      ],
    );
  }
}
