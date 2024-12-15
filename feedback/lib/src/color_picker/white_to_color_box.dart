part of 'color_picker_icon.dart';

class _WhiteToColorBox extends StatefulWidget {
  const _WhiteToColorBox({
    required this.color,
    required this.outsideSetter,
    required this.innerSetter,
  });

  final Color color;
  final ValueSetter<Color> outsideSetter;
  final ValueSetter<double> innerSetter;

  @override
  State<_WhiteToColorBox> createState() => _WhiteToColorBoxState();
}

class _WhiteToColorBoxState extends State<_WhiteToColorBox> {
  static const double _padding = 12;
  static const AlignmentGeometry _startAlignment = Alignment.topLeft;
  static const AlignmentGeometry _endAlignment = Alignment.bottomRight;

  Color get color => widget.color.withAlpha(_maxAlpha);

  @override
  void initState() {
    super.initState();
    Future(
      () => setState(
        () => offset = _calculateInitialOffset(),
      ),
    );
  }

  @override
  didUpdateWidget(covariant _WhiteToColorBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(
      () => interpolatedColor = Color.lerp(
        _startColor,
        color,
        _cachedWhiteToColorValue,
      )!,
    );
  }

  late Offset offset = Offset.zero;
  late Color interpolatedColor = Color.lerp(
    _startColor,
    color,
    _cachedWhiteToColorValue,
  )!;

  @override
  Widget build(BuildContext context) => Stack(
        key: _whiteToColorKey,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.all(_padding),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/checkerboard.png'),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            foregroundDecoration: ShapeDecoration(
              /// If This [LinearGradient] changes, It will need another algorithm to calculate
              /// the interpolated color according to the new gradient type.
              gradient: LinearGradient(
                /// These may change freely even with [AlignmentDirectional] values
                begin: _startAlignment,
                end: _endAlignment,
                colors: [
                  _startColor,
                  color,
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(width: 1),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) => _onPointerUpdate(details.globalPosition),
            ),
          ),
          Positioned(
            top: offset.dy,
            left: offset.dx,
            child: GestureDetector(
              onPanUpdate: (details) => _onPointerUpdate(details.globalPosition),
              child: Container(
                width: _padding * 2,
                height: _padding * 2,
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(width: 1),
                  ),
                  color: interpolatedColor,
                ),
              ),
            ),
          )
        ],
      );

  Offset _calculateInitialOffset() {
    final renderBox = _whiteToColorKey.currentContext!.findRenderObject() as RenderBox;

    /// Note we have a margin of [padding] all around the box.
    final xUpperLimit = renderBox.size.width - _padding * 2;
    final yUpperLimit = renderBox.size.height - _padding * 2;

    final bottomRight = Offset(xUpperLimit, yUpperLimit);

    final (start, end) = _startEnd(
      bottomRight: bottomRight,
      direction: Directionality.of(context),
    );

    /// m = (h - 0) / ( w - 0 )
    /// c = y - mx
    final m = (end.dy - start.dy) / (end.dx - start.dx);
    final c = start.dy - m * start.dx;

    final gradientLineLength = calculateDistance(start, end);
    final distanceOfInterpolation = gradientLineLength * _cachedWhiteToColorValue;

    final otherPoint = calculateOtherPoint(
      start,
      distanceOfInterpolation,
      m,
      c,
    );

    return otherPoint;
  }

  double calculateDistance(Offset start, Offset end) => sqrt(
        pow(end.dx - start.dx, 2) + pow(end.dy - start.dy, 2),
      );

  Offset calculateOtherPoint(
    Offset point,
    double distance,
    double lineSlope,
    double coefficient,
  ) {
    /// There values are the coefficients of the quadratic equation
    /// obtained from solving the given line equation and the distance equation.
    /// y1 = m * x1 + c;
    /// d = sqrt( (x1 - x0)^2 + (y1 - y0)^2 )
    final a = 1 + lineSlope * lineSlope;
    final b = 2 * lineSlope * coefficient - 2 * point.dx - point.dy * lineSlope;
    final c = pow(point.dx, 2) -
        point.dy * coefficient +
        pow(point.dy, 2) +
        pow(coefficient, 2) -
        pow(distance, 2);

    double x;
    x = (-b + sqrt(b * b - 4 * a * c)) / (2 * a);
    if (x.isNegative) x = (-b - sqrt(b * b - 4 * a * c)) / (2 * a);

    final y = lineSlope * x + coefficient;
    return Offset(x, y);
  }

  // void _onPointerUpdate(Offset tapPosition) {
  //   final renderBox = _whiteToColorKey.currentContext!.findRenderObject() as RenderBox;
  //   final xUpperLimit = renderBox.size.width - padding * 2;
  //   final yUpperLimit = renderBox.size.height - padding * 2;
  //   final newOffset = tapPosition - Offset(padding, padding);
  //   final constraintOffset = Offset(
  //     newOffset.dx.clamp(0, xUpperLimit),
  //     newOffset.dy.clamp(0, yUpperLimit),
  //   );
  //   print(constraintOffset);
  //   setState(
  //     () {
  //       offset = constraintOffset;
  //     },
  //   );
  // }

  void _onPointerUpdate(Offset global) {
    final renderBox = _whiteToColorKey.currentContext!.findRenderObject() as RenderBox;

    /// Note we have a margin of [padding] all around the box.
    final boxTopLeftGlobalOffset = renderBox.localToGlobal(Offset(_padding, _padding));
    final xUpperLimit = renderBox.size.width - _padding * 2;
    final yUpperLimit = renderBox.size.height - _padding * 2;

    // final newOffset = details.localPosition - Offset(padding, padding);
    final local = global - boxTopLeftGlobalOffset;
    // print(newOffset);
    final tapPosition = Offset(
      local.dx.clamp(0, xUpperLimit),
      local.dy.clamp(0, yUpperLimit),
    );

    final bottomRight = Offset(xUpperLimit, yUpperLimit);
    final newColor = _interpolateTapPosition(
      bottomRight,
      tapPosition,
    );
    setState(
      () {
        offset = tapPosition;
        interpolatedColor = newColor;
      },
    );
    widget.innerSetter(_cachedWhiteToColorValue);
    final colorWithAlpha = interpolatedColor.withAlpha(_cachedAlphaSlider.round());
    widget.outsideSetter(colorWithAlpha);
  }

  Color _interpolateTapPosition(Offset bottomRight, Offset tapPosition) {
    final x0 = tapPosition.dx;
    final y0 = tapPosition.dy;

    final (start, end) = _startEnd(
      bottomRight: bottomRight,
      direction: Directionality.of(context),
    );

    /// m = (h - 0) / ( w - 0 )
    /// c = y - mx
    final m = (end.dy - start.dy) / (end.dx - start.dx);
    final c = start.dy - m * start.dx;

    ///  x1 = ( x0 + m y0 - m c ) / ( m^2 + 1 )
    ///  y1 = m (x1) + c
    final x1 = (x0 + m * y0 - m * c) / (m * m + 1);
    final y1 = m * x1 + c;

    /// Performing Interpolation
    final distance = calculateDistance(start, Offset(x1, y1));
    final gradientLineLength = calculateDistance(start, end);
    final interpolationValue = distance / gradientLineLength;

    /// Caching interpolation value
    _cachedWhiteToColorValue = interpolationValue;

    return Color.lerp(
      _startColor,
      color,
      interpolationValue,
    )!;
  }

  (Offset start, Offset end) _startEnd({
    required Offset bottomRight,
    required TextDirection direction,
  }) {
    final startAlignment = _startAlignment.resolve(direction);
    final endAlignment = _endAlignment.resolve(direction);

    final double startXOffset;
    final double startYOffset;
    if (startAlignment.x < 0) {
      startXOffset = 0;
    } else if (startAlignment.x == 0) {
      startXOffset = bottomRight.dx / 2;
    } else {
      startXOffset = bottomRight.dx;
    }

    if (startAlignment.y < 0) {
      startYOffset = 0;
    } else if (startAlignment.y == 0) {
      startYOffset = bottomRight.dy / 2;
    } else {
      startYOffset = bottomRight.dy;
    }

    final double endXOffset;
    final double endYOffset;
    if (endAlignment.x < 0) {
      endXOffset = 0;
    } else if (endAlignment.x == 0) {
      endXOffset = bottomRight.dx / 2;
    } else {
      endXOffset = bottomRight.dx;
    }

    if (endAlignment.y < 0) {
      endYOffset = 0;
    } else if (endAlignment.y == 0) {
      endYOffset = bottomRight.dy / 2;
    } else {
      endYOffset = bottomRight.dy;
    }

    return (
      Offset(startXOffset, startYOffset),
      Offset(endXOffset, endYOffset),
    );
  }
}
