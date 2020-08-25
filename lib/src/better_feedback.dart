import 'package:feedback/src/feedback_controller.dart';
import 'package:feedback/src/feedback_functions.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/feedback_app.dart';
import 'package:flutter/material.dart';

/// This widget should be at the top of your widget tree.
class BetterFeedback extends StatefulWidget {
  const BetterFeedback({
    Key key,
    @required this.child,
    this.themeData,
  })  : assert(child != null),
        super(key: key);

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  final FeedbackThemeData themeData;

  /// Call `BetterFeedback.of(context)` to get an instance of
  /// [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FeedbackData>();

  @override
  _BetterFeedbackState createState() => _BetterFeedbackState();
}

class _BetterFeedbackState extends State<BetterFeedback> {
  FeedbackController controller = FeedbackController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onUpdateOfController);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onUpdateOfController);
  }

  @override
  Widget build(BuildContext context) {
    return FeedbackApp(
      data: widget.themeData,
      // The overlay is needed by the TextField
      // in the feedback bottom sheet.
      child: FeedbackData(
        controller: controller,
        child: Builder(
          builder: (context) {
            return FeedbackWidget(
              child: widget.child,
              isFeedbackVisible: controller.isVisible,
              drawColors: FeedbackTheme.of(context).drawColors,
            );
          },
        ),
      ),
    );
  }

  void onUpdateOfController() {
    setState(() {});
  }
}

class FeedbackData extends InheritedWidget {
  const FeedbackData({
    Key key,
    @required Widget child,
    @required this.controller,
  })  : assert(child != null),
        assert(controller != null),
        super(key: key, child: child);

  final FeedbackController controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }

  /// Shows the feedback view
  void show(OnFeedbackCallback callback) => controller.show(callback);

  /// Hides the feedback view
  void hide() => controller.hide();

  bool get isVisible => controller.isVisible;

  static FeedbackController of(BuildContext context) {
    final feedbackThemeData =
        context?.dependOnInheritedWidgetOfExactType<FeedbackData>();
    return feedbackThemeData?.controller;
  }
}
