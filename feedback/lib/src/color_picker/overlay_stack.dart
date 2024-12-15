part of 'color_picker_icon.dart';

class _OverlayStack extends StatefulWidget {
  const _OverlayStack({
    required this.closeCallback,
    required this.activeColor,
    required this.onColorChanged,
  });

  final VoidCallback closeCallback;
  final Color activeColor;
  final ValueChanged<Color> onColorChanged;

  @override
  State<_OverlayStack> createState() => _OverlayStackState();
}

class _OverlayStackState extends State<_OverlayStack> {
  static const Duration _animationDuration = Duration(milliseconds: 320);

  @override
  void initState() {
    super.initState();
    Future(() => setState(() => opacity = 1.0));
  }

  double opacity = 0.0;

  void onTapOutside() {
    setState(() => opacity = 0.0);
    Future.delayed(_animationDuration).then(
      (_) => widget.closeCallback(),
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onTapOutside,
            ),
          ),
          AnimatedOpacity(
            duration: _animationDuration,
            opacity: opacity,
            curve: Curves.decelerate,
            child: AlertDialog.adaptive(
              content: _ColorPicker(
                activeColor: widget.activeColor,
                onColorChanged: widget.onColorChanged,
              ),
            ),
          ),
        ],
      );
}
