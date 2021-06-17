import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_controller.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/feedback_builder/string_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/feedback_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feedback/src/l18n/translation.dart';

/// The function to be called when the user submits their feedback.
typedef OnSubmit = void Function(
  String feedback, {
  Map<String, dynamic>? extras,
});

/// A function that returns a Widget that prompts the user for feedback and
/// calls [OnSubmit] when the user wants to submit their feedback.
typedef FeedbackBuilder = Widget Function(BuildContext, OnSubmit);

/// Function which gets called when the user submits his feedback.
/// [feedback] is the user generated feedback. A string, by default.
/// [screenshot] is a raw png encoded image.
/// [OnFeedbackCallback] should cast [feedback] to the appropriate type.
typedef OnFeedbackCallback = void Function(UserFeedback);

/// A feedback widget that uses a custom widget and data type for
/// prompting the user for their feedback. This widget should be at the top of
/// your widget tree. Specifically, it should be above any [Navigator] widgets,
/// including the navigator provided by [MaterialApp].
class BetterFeedback extends StatefulWidget {
  const BetterFeedback({
    Key? key,
    required this.child,
    this.feedbackBuilder,
    this.theme,
    this.localizationsDelegates,
    this.localeOverride,
    this.mode = FeedbackMode.draw,
    this.pixelRatio = 3.0,
  })  : assert(
          pixelRatio > 0,
          'pixelRatio needs to be larger than 0',
        ),
        super(key: key);

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  /// Returns a widget that prompts the user for feedback and calls the provided
  /// submit function with their completed feedback. Typically, this involves
  /// some form fields and a submit button that calls [OnSubmit] when pressed.
  /// Defaults to [StringFeedback] which uses a single editable text field to
  /// prompt for input.
  final FeedbackBuilder? feedbackBuilder;

  /// Theme which gets used to style the feedback mode.
  final FeedbackThemeData? theme;

  /// The delegates for this library's FeedbackLocalization widget.
  /// You need to supply the following delegates if you choose to customize it.
  /// [MaterialLocalizations]
  /// [CupertinoLocalizations]
  /// [WidgetsLocalizations]
  /// an instance of [LocalizationsDelegate]<[FeedbackLocalizations]>
  final List<LocalizationsDelegate>? localizationsDelegates;

  /// Can be used to set the locale.
  /// If it is not set, the platform default locale is used.
  /// If no platform default locale exists, english is used.
  final Locale? localeOverride;

  /// Set the default mode when launching feedback.
  /// By default it will allow the user to navigate.
  /// See [FeedbackMode] for other options.
  final FeedbackMode mode;

  /// The pixelRatio describes the scale between
  /// the logical pixels and the size of the output image.
  /// Specifying 1.0 will give you a 1:1 mapping between
  /// logical pixels and the output pixels in the image.
  /// The default is a pixel ration of 3 and a value below 1 is not recommended.
  ///
  /// See [RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)
  /// for the underlying implementation.
  final double pixelRatio;

  /// Call `BetterFeedback.of(context)` to get an
  /// instance of [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData of(BuildContext context) {
    final feedbackData =
        context.dependOnInheritedWidgetOfExactType<FeedbackData>();
    assert(
      feedbackData != null,
      'You need to add a $BetterFeedback widget above this context!',
    );
    return feedbackData!;
  }

  @override
  _BetterFeedbackState createState() => _BetterFeedbackState();
}

class _BetterFeedbackState extends State<BetterFeedback> {
  FeedbackController controller = FeedbackController();

  bool feedbackVisible = false;

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
      data: widget.theme,
      localizationsDelegates: widget.localizationsDelegates,
      localeOverride: widget.localeOverride,
      child: Builder(builder: (context) {
        return FeedbackData(
          controller: controller,
          child: Builder(
            builder: (context) {
              assert(debugCheckHasFeedbackLocalizations(context));
              return FeedbackWidget(
                child: widget.child,
                isFeedbackVisible: feedbackVisible,
                drawColors: FeedbackTheme.of(context).drawColors,
                mode: widget.mode,
                pixelRatio: widget.pixelRatio,
                feedbackBuilder:
                    widget.feedbackBuilder ?? simpleFeedbackBuilder,
              );
            },
          ),
        );
      }),
    );
  }

  void onUpdateOfController() {
    setState(() {
      feedbackVisible = controller.isVisible;
    });
  }
}

class FeedbackData extends InheritedWidget {
  const FeedbackData({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

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
        context.dependOnInheritedWidgetOfExactType<FeedbackData>();

    assert(
      feedbackThemeData != null,
      'You need to add a $BetterFeedback widget above this context!',
    );
    return feedbackThemeData!.controller;
  }
}
