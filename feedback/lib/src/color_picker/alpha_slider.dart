part of 'color_picker_icon.dart';

class _AlphaSlider extends StatefulWidget {
  const _AlphaSlider({
    required this.color,
    required this.whiteToColorValue,
    required this.outsideSetter,
  });

  final Color color;
  final double whiteToColorValue;
  final ValueSetter<Color> outsideSetter;

  @override
  State<_AlphaSlider> createState() => _AlphaSliderState();
}

class _AlphaSliderState extends State<_AlphaSlider> {
  static const _thumbRadius = 12.0;

  Color get color => Color.lerp(_startColor, widget.color, widget.whiteToColorValue)!;
  late var _sliderValue = _cachedAlphaSlider;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _thumbRadius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: _thumbRadius / 2,
              margin: EdgeInsets.symmetric(horizontal: _thumbRadius),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color.withAlpha(_minAlpha),
                    color.withAlpha(_maxAlpha),
                  ],
                ),
                shape: StadiumBorder(),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: _thumbRadius * 0.65,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: _thumbRadius,
                  ),
                ),
                child: Slider(
                  activeColor: Colors.transparent,
                  min: _minAlpha.toDouble(),
                  max: _maxAlpha.toDouble(),
                  inactiveColor: Colors.transparent,
                  thumbColor: color.withAlpha(
                    // We limit only the look of the thumb to the middle of [_maxAlpha]
                    // however the value in [_sliderValue] is still reflected properly
                    max(_maxAlpha / 2, _sliderValue).round(),
                  ),
                  value: _sliderValue,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      );

  void onChanged(double value) {
    setState(() {
      _sliderValue = value;
      _cachedAlphaSlider = _sliderValue;
    });
    widget.outsideSetter(color.withAlpha(_sliderValue.round()));
  }
}
