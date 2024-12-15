import 'dart:math';

import 'package:flutter/material.dart';

part 'alpha_slider.dart';
part 'color_picker.dart';
part 'constants.dart';
part 'hue_slider.dart';
part 'overlay_stack.dart';
part 'ring_clipper.dart';
part 'white_to_color_box.dart';

///
class ColorPickerIcon extends StatelessWidget {
  ///
  const ColorPickerIcon({
    super.key,
    required this.activeColor,
    required this.onColorChanged,
  });

  ///
  final ValueChanged<Color>? onColorChanged;

  ///
  final Color activeColor;

  List<Color> get _brightColors => [
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.green,
      ];

  static const _iconSize = 30.0;
  static const _outerRingSize = _iconSize / 7;
  static const _innerRingSize = _outerRingSize;

  // This last ` - 1 ` is for easier visual separation between alpha and hue representation
  // especially when color is lighter while at max alpha due to [_WhiteToColorBox]
  static const _innerColorSize = _iconSize - (_outerRingSize * 2) - (_innerRingSize * 2) - 1;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onColorChanged == null ? null : () => _showColorPicker(context),
        icon: Stack(
          alignment: Alignment.center,
          children: [
            ClipPath(
              clipper: _RingClipper(width: _outerRingSize),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.decelerate,
                width: _iconSize,
                height: _iconSize,
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: onColorChanged == null
                        ? _brightColors.map((c) => c.withAlpha(50)).toList()
                        : _brightColors,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// That ring is the full representation of active color and its alpha
            ClipPath(
              clipper: _RingClipper(width: _innerRingSize),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.decelerate,
                width: _iconSize - _outerRingSize * 2,
                height: _iconSize - _outerRingSize * 2,
                decoration: BoxDecoration(
                  /// Found it better in indicating lower
                  /// alpha values when adding `withAlpha(170)`
                  color: Colors.white.withAlpha(170),
                  shape: BoxShape.circle,
                ),
                foregroundDecoration: BoxDecoration(
                  color: _borderColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// That is the color representation without alpha
            Container(
              width: _innerColorSize,
              height: _innerColorSize,
              decoration: BoxDecoration(
                color: _topColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );

  /// Solid representation of active color without alpha
  Color get _topColor =>
      onColorChanged == null ? activeColor.withAlpha(50) : activeColor.withAlpha(_maxAlpha);

  /// Full representation of active color including alpha
  Color get _borderColor => onColorChanged == null ? activeColor.withAlpha(50) : activeColor;

  static OverlayEntry? _entry;

  void _showColorPicker(BuildContext context) {
    final overlayState = Overlay.of(context);

    _entry = OverlayEntry(
      builder: (context) => _OverlayStack(
        closeCallback: _close,
        activeColor: activeColor,
        onColorChanged: onColorChanged!,
      ),
    );

    overlayState.insert(_entry!);
  }

  void _close() => _entry?.remove();
}
