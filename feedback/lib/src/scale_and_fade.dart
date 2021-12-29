// ignore_for_file: public_member_api_docs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScaleAndFade extends StatelessWidget {
  const ScaleAndFade({
    required this.progress,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ValueListenable<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, child) {
        return Opacity(
          opacity: 1 - value,
          child: Transform.scale(
            scale: 1 - .03 * value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
