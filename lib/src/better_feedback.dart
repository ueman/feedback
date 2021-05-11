import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_controller.dart';
import 'package:feedback/src/feedback_functions.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/string_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/feedback_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feedback/src/l18n/translation.dart';

typedef OnSubmit<T> = void Function(BuildContext context, T feedback);

typedef GetFeedback<T> = Widget Function(OnSubmit<T>);

/// The default `BetterFeedback` class. This widget should be at the top of your
/// widget tree.
/// Only prompts for single-string feedback. If you want to prompt the user for
/// more complex/customized feedback (eg you want to include a drop down that
/// asks a user if their feedback is a bug report or feature request), use
/// `CustomizedBetterFeedback` instead.
class BetterFeedback extends CustomizedBetterFeedback<String> {
  const BetterFeedback({
    Key? key,
    required Widget child,
    FeedbackThemeData? theme,
    List<LocalizationsDelegate>? localizationsDelegates,
    Locale? localeOverride,
    FeedbackMode mode = FeedbackMode.navigate,
    double pixelRatio = 3.0,
  }) : super(
          key: key,
          child: child,
          theme: theme,
          localizationsDelegates: localizationsDelegates,
          localeOverride: localeOverride,
          mode: mode,
          pixelRatio: pixelRatio,
          getFeedback: getStringFeedback,
        );

  /// Call `BetterFeedback.of(context)` to get an instance of
  /// [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData<String>? of(BuildContext context) =>
      CustomizedBetterFeedback.of<String>(context);
}

/// A feedback widget that uses a custom widget and data type for
/// prompting the user for their feedback. This widget should be at the top of
/// your widget tree.
/// If you only need basic feedback in the form of a single text field, use
/// `BetterFeedback` instead.
class CustomizedBetterFeedback<T> extends StatefulWidget {
  const CustomizedBetterFeedback({
    Key? key,
    required this.child,
    required this.getFeedback,
    this.theme,
    this.localizationsDelegates,
    this.localeOverride,
    this.mode = FeedbackMode.navigate,
    this.pixelRatio = 3.0,
  })  : assert(
          pixelRatio > 0,
          'pixelRatio needs to be larger than 0',
        ),
        super(key: key);

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  /// Returns a widget that prompts the user for feedback and calls the provided
  /// submit function with their completed feedback.
  final GetFeedback<T> getFeedback;

  /// Theme wich gets used to style the feedback mode.
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

  /// Call `CustomizedBetterFeedback<your_data_type>.of(context)` to get an
  /// instance of [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData<T>? of<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FeedbackData<T>>();

  @override
  _BetterFeedbackState createState() => _BetterFeedbackState<T>();
}

class _BetterFeedbackState<T> extends State<BetterFeedback> {
  FeedbackController<T> controller = FeedbackController<T>();

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
        return FeedbackData<T>(
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
                getFeedback: widget.getFeedback,
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

class FeedbackData<T> extends InheritedWidget {
  const FeedbackData({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  final FeedbackController<T> controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }

  /// Shows the feedback view
  void show(OnFeedbackCallback<T> callback) => controller.show(callback);

  /// Hides the feedback view
  void hide() => controller.hide();

  bool get isVisible => controller.isVisible;

  static FeedbackController<T>? of<T>(BuildContext context) {
    final feedbackThemeData =
        context.dependOnInheritedWidgetOfExactType<FeedbackData<T>>();
    return feedbackThemeData?.controller;
  }
}
