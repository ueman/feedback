part of 'color_picker_icon.dart';

class _OverlayStack extends StatefulWidget {
  const _OverlayStack({
    required this.closeCallback,
    required this.activeColor,
    required this.onColorChanged,
  });

  final BoolCallback closeCallback;
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
    BackButtonInterceptor.add(widget.closeCallback, priority: 1);
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
  void dispose() {
    BackButtonInterceptor.remove(widget.closeCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
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
            child: Container(
              constraints: BoxConstraints(
                maxWidth: min(
                  450,
                  MediaQuery.sizeOf(context).width,
                ),
                maxHeight: min(
                  450,
                  MediaQuery.sizeOf(context).height * 0.85,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceDim,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _ColorPicker(
                activeColor: widget.activeColor,
                onColorChanged: widget.onColorChanged,
              ),
            ),
          ),
        ],
      );
}
