import 'package:flutter/widgets.dart';

class ScaleAndClip extends StatelessWidget {
  const ScaleAndClip({
    Key key,
    this.child,
    this.scale,
    this.alignmentProgress,
  }) : super(key: key);

  final Widget child;
  final double scale;
  final double alignmentProgress;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment(
        -0.3 * alignmentProgress,
        -1 * alignmentProgress,
      ),
      scale: scale,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20 * alignmentProgress,
          ),
        ),
        child: child,
      ),
    );
  }
}
