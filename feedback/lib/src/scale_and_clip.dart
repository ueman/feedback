// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

class ScaleAndClip extends StatelessWidget {
  const ScaleAndClip({
    super.key,
    required this.child,
    required this.scaleFactor,
    required this.progress,
  });

  final Widget child;
  final double scaleFactor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - progress * (1 - scaleFactor),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20 * progress,
          ),
        ),
        child: child,
      ),
    );
  }
}
