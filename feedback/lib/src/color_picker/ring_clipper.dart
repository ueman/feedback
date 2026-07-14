part of 'color_picker_icon.dart';

class _RingClipper extends CustomClipper<Path> {
  final double width;

  const _RingClipper({required this.width});

  @override
  Path getClip(Size size) {
    final outerRadius = size.width / 2;
    assert(size.width == size.height, 'Width is not equal to height');

    final path = Path()..fillType = PathFillType.evenOdd;
    path.addOval(
      Rect.fromCircle(
        center: Offset(outerRadius, outerRadius),
        radius: outerRadius,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(outerRadius, outerRadius),
        radius: outerRadius - width,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
