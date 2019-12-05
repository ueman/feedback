import 'package:feeback/src/feedback_adapter.dart';
import 'package:feeback/src/feedback_controller.dart';
import 'package:feeback/src/feedback_widget.dart';
import 'package:flutter/widgets.dart';

/// This widget should be at the top of your widget tree.
class BetterFeedback extends StatefulWidget {
  const BetterFeedback({
    Key key,
    this.child,
    this.onFeedback,
    this.feedbackAdapter,
  })  : assert(onFeedback != null || feedbackAdapter != null,
            'Either onFeedback or feedbackAdapter must be non null'),
        super(key: key);

  /// Gets called when the user submits his feedback
  final OnFeedbackCallback onFeedback;

  /// Gets called when the user submits his feedback
  final FeedbackAdapter feedbackAdapter;

  /// The application to wrap
  final Widget child;

  /// Call `BetterFeedback.of(context)` to get an instance of
  /// [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(FeedbackData) as FeedbackData;

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
    return FeedbackData(
      controller: controller,
      child: FeedbackWidget(
        child: widget.child,
        isFeedbackVisible: controller.isVisible,
        feedbackAdapter: widget.feedbackAdapter ??
            CallbackFeedbackAdapter(widget.onFeedback),
      ),
    );
  }

  void onUpdateOfController() {
    setState(() {});
  }
}

class FeedbackData extends InheritedWidget {
  const FeedbackData(
      {Key key, @required Widget child, @required this.controller})
      : assert(child != null),
        assert(controller != null),
        super(key: key, child: child);

  final FeedbackController controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }

  /// Shows the feedback view
  void show() => controller.show();

  /// Hides the feedback view
  void hide() => controller.hide();
}
