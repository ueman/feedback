import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnappableScrollableSheet extends StatefulWidget {
  const SnappableScrollableSheet({
    Key? key,
    required this.builder,
    required this.minChildSize,
    this.maxChildSize = 1,
  }) : super(key: key);

  final ScrollableWidgetBuilder builder;
  final double minChildSize;
  final double maxChildSize;

  @override
  _SnappableScrollableSheetState createState() =>
      _SnappableScrollableSheetState();
}

class _SnappableScrollableSheetState extends State<SnappableScrollableSheet>
    with SingleTickerProviderStateMixin {
  late DraggableScrollableNotification _draggableNotification;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    lowerBound: widget.minChildSize,
    upperBound: widget.maxChildSize,
  );

  @override
  Widget build(BuildContext context) {
    // We need access to the `ScrollEndNotification` to ensure the user is done
    // scrolling before we attempt any snapping behavior
    return NotificationListener<ScrollEndNotification>(
      onNotification: (endNotification) {
        if (_draggableNotification.extent == widget.minChildSize ||
            _draggableNotification.extent == widget.maxChildSize) {
          // We already scrolled to the max or min.
          return true;
        }
        if (_draggableNotification.extent >=
            (widget.maxChildSize + widget.minChildSize) / 2) {
          // The user scrolled more than halfway between mix and max size - snap
          // to the max size
          _controller.duration =
              _getDuration(_draggableNotification.extent, widget.maxChildSize);
          _controller.forward(from: _draggableNotification.extent);
        } else {
          setState(() {
            _controller.duration = _getDuration(
                _draggableNotification.extent, widget.minChildSize);
            _controller.reverse(from: _draggableNotification.extent);
          });
        }

        return false;
      },
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          _draggableNotification = notification;
          return false;
        },
        child: AnimatedBuilder(
          builder: (context, _) {
            return DraggableScrollableSheet(
              // Update the key on tick to ensure that the widget gets rebuilt
              key: Key(_controller.value.toString()),
              initialChildSize: _controller.value,
              minChildSize: _controller.value,
              maxChildSize: widget.maxChildSize,
              builder: widget.builder,
            );
          },
          animation: _controller,
        ),
      ),
    );
  }

  // Get the appropriate animation duration given the distance to be covered
  Duration _getDuration(double from, double to) {
    return Duration(
        milliseconds: 100 *
            (to - from).abs() ~/
            (widget.maxChildSize - widget.minChildSize));
  }
}
