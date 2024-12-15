part of 'color_picker_icon.dart';

class _ColorPicker extends StatefulWidget {
  const _ColorPicker({
    required this.onColorChanged,
    required this.activeColor,
  });

  final ValueChanged<Color> onColorChanged;
  final Color activeColor;

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  late Color _hueSlideColor = widget.activeColor;
  double _whiteToColorValue = _cachedWhiteToColorValue;

  void onHueColorChanged(Color color) => setState(
        () => _hueSlideColor = color,
      );

  void onWhiteToColorChanged(double value) => setState(
        () => _whiteToColorValue = value,
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 5 / 4,
              child: _WhiteToColorBox(
                color: _hueSlideColor,
                innerSetter: onWhiteToColorChanged,
                outsideSetter: widget.onColorChanged,
              ),
            ),
            SizedBox(height: _thumbRadius),
            _AlphaSlider(
              color: _hueSlideColor,
              whiteToColorValue: _whiteToColorValue,
              outsideSetter: widget.onColorChanged,
            ),
            SizedBox(height: _thumbRadius),
            /// This is not affected by the alpha slider nor the white to color
            _HueSlider(
              activeColor: widget.activeColor,
              insideSetter: onHueColorChanged,
              outSideSetter: widget.onColorChanged,
            ),
          ],
        ),
      );
}
