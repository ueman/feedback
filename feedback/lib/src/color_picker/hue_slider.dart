part of 'color_picker_icon.dart';

class _HueSlider extends StatefulWidget {
  const _HueSlider({
    required this.activeColor,
    required this.insideSetter,
    required this.outSideSetter,
  });

  final Color activeColor;
  final ValueSetter<Color> insideSetter;
  final ValueSetter<Color> outSideSetter;

  @override
  State<_HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<_HueSlider> {
  static const _thumbRadius = 12.0;

  @override
  void initState() {
    super.initState();
    Future(() {
      _presetToActiveColorIfExists();
      onChanged(_cachedHueSlider);
    });
  }

  void _presetToActiveColorIfExists() {
    /// Presetting [_cachedHueSlider] to move the slider to match the provided
    /// [activeColor] if it is present in [_colorsList]
    Color? matchedColor;
    _colorsList.any(
      (element) {
        if (widget.activeColor == element) {
          matchedColor = element;
          return true;
        }
        return false;
      },
    );
    if (matchedColor != null) {
      final index = _colorsList.indexOf(matchedColor!);
      _cachedHueSlider = index * _colorShare;
    }
  }

  Color _hueSlideColor = Colors.transparent;
  double _slideValue = _cachedHueSlider;

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
                  colors: _colorsList,
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
                  inactiveColor: Colors.transparent,
                  thumbColor: _hueSlideColor,
                  value: _slideValue,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      );

  void onChanged(double value) {
    final hueColor = _getColorFromSliderValue(value);

    setState(() {
      _hueSlideColor = hueColor;
      _slideValue = value;
      _cachedHueSlider = _slideValue;
    });
    widget.insideSetter(_hueSlideColor);

    /// Note that [_getColorFromSliderValue] returns a color without taking alpha
    /// nor white to color value into account so we have to adjust it before setting
    /// the outside [activeColor]
    final colorWithWhiteToColor = Color.lerp(
      _startColor,
      _hueSlideColor,
      _cachedWhiteToColorValue,
    )!;
    final allSetColor = colorWithWhiteToColor.withAlpha(_cachedAlphaSlider.round());

    widget.outSideSetter(allSetColor);
  }

  Color _getColorFromSliderValue(double value) {
    final firstIndex = value ~/ _colorShare;
    final secondIndex = min(firstIndex + 1, _colorsList.length - 1);
    final (first, second) = (
      _colorsList[firstIndex],
      _colorsList[secondIndex],
    );

    final interpolation = value / _colorShare - min(firstIndex, secondIndex);

    final hueColor = Color.lerp(
      first,
      second,
      interpolation,
    );
    return hueColor!;
  }
}
