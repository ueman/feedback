// ignore_for_file: public_member_api_docs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScaleAndFade extends StatelessWidget {
  const ScaleAndFade({
    required this.progress,
    required this.child,
    this.minOpacity = 0,
    this.maxOpacity = 1,
    this.minScale = 0,
    this.maxScale = 1,
    super.key,
  });

  final ValueListenable<double> progress;
  final Widget child;
  final double minOpacity;
  final double maxOpacity;
  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, currProgress, child) {
        return Opacity(
          opacity: maxOpacity - currProgress * (maxOpacity - minOpacity),
          child: Transform.scale(
            scale: maxScale - currProgress * (maxScale - minScale),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
