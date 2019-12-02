// Kopiert und angepasst von
// https://github.com/EPNW/painter/blob/master/lib/painter.dart
import 'package:flutter/widgets.dart' hide Image;

class Painter extends StatefulWidget {
  Painter(this.painterController)
      : super(key: ValueKey<PainterController>(painterController));

  final PainterController painterController;

  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  @override
  Widget build(BuildContext context) {
    Widget child =  CustomPaint(
      willChange: true,
      painter:  _PainterPainter(
        widget.painterController._pathHistory,
        repaint: widget.painterController,
      ),
    );

    child =  GestureDetector(
      child: child,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
    );

    return  Container(
      child: child,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _onPanStart(DragStartDetails start) {
    final Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    final Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }
}

class _PainterPainter extends CustomPainter {
  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  final _PathHistory _path;

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  _PathHistory() {
    _paths =  <MapEntry<Path, Paint>>[];
    _inDrag = false;
    _backgroundPaint =  Paint();
  }

  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  Paint _backgroundPaint;
  bool _inDrag;


  set backgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (!_inDrag && _paths.isNotEmpty) {
      _paths.removeLast();
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
  }

  void add(Offset startPoint) {
    if (_inDrag) {
      return;
    }
    _inDrag = true;
    final Path path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    _paths.add(MapEntry<Path, Paint>(path, currentPaint));
  }

  void updateCurrent(Offset nextPoint) {
    if (!_inDrag) {
      return;
    }
    final Path path = _paths.last.key;
    path.lineTo(nextPoint.dx, nextPoint.dy);
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
       Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      _backgroundPaint,
    );
    for (final MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}

class PainterController extends ChangeNotifier {
  PainterController() {
    _pathHistory =  _PathHistory();
  }

  Color _drawColor =  const Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = const Color.fromARGB(255, 255, 255, 255);

  double _thickness = 1;
  _PathHistory _pathHistory;

  Color get drawColor => _drawColor;
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    final Paint paint =  Paint();
    paint.color = drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    _pathHistory.backgroundColor = backgroundColor;
    notifyListeners();
  }

  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }
}
