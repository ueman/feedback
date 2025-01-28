part of 'color_picker_icon.dart';

final _colorsList = List<Color>.from(
  Colors.primaries.take(Colors.primaries.length - 2),
).followedBy(
  [Colors.brown.shade500, Colors.black],
).toList();
final _colorShare = 1 / (_colorsList.length - 1);

const _thumbRadius = 24.0;
double _cachedHueSlider = 1.0;

double _cachedAlphaSlider = _maxAlpha.toDouble();
const _minAlpha = 50;
const _maxAlpha = 255;

final GlobalKey _whiteToColorKey = GlobalKey();
const Color _startColor = Colors.white;
double _cachedWhiteToColorValue = 1.0;
