import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:feedback/src/debug.dart';
import 'package:feedback/src/feedback_builder/string_feedback.dart';
import 'package:feedback/src/feedback_data.dart';
import 'package:feedback/src/feedback_widget.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:feedback/src/utilities/feedback_app.dart';
import 'package:feedback/src/utilities/renderer/renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSubmit = FutureOr<void> Function(BuildContext context, UserFeedback feedback);

/// A function that returns a Widget that prompts the user for feedback and
/// calls [OnSubmit] when the user wants to submit their feedback.
///
/// A non-null controller is provided if the sheet is set to draggable in the
/// feedback theme.
/// If the sheet is draggable, the non null controller should be passed into a
/// scrollable widget to make the feedback sheet expand when the widget is
/// scrolled. Typically, this will be a `ListView` or `SingleChildScrollView`
/// wrapping the feedback sheet's content.
/// See: [FeedbackThemeData.sheetIsDraggable] and [DraggableScrollableSheet].
typedef FeedbackBuilder<T, R> = Widget Function(
  BuildContext context,
  T route,
  // All the callbacks the sheet needs to communicate with `BetterFeedback`.
  FeedbackFormController<R> formController,
);

/// A drag handle to be placed at the top of a draggable feedback sheet.
///
/// This is a purely visual element that communicates to users that the sheet
/// can be dragged to expand it.
///
/// It should be placed in a stack over the sheet's scrollable element so that
/// users can click and drag on it-the drag handle ignores pointers so the drag
/// will pass through to the scrollable beneath.
// TODO(caseycrogers): Replace this with a pre-built drag handle above the
//   builder function once `DraggableScrollableController` is available in
//   production.
//   See: https://github.com/flutter/flutter/pull/92440.
class FeedbackSheetDragHandle extends StatelessWidget {
  /// Create a drag handle.
  const FeedbackSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedbackThemeData feedbackTheme = FeedbackTheme.of(context);
    return IgnorePointer(
      child: Container(
        height: 20,
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        alignment: Alignment.center,
        color: feedbackTheme.feedbackSheetColor,
        child: Container(
          height: 5,
          width: 30,
          decoration: BoxDecoration(
            color: feedbackTheme.dragHandleColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

/// A feedback widget that uses a custom widget and data type for
/// prompting the user for their feedback. This widget should be the root of
/// your widget tree. Specifically, it should be above any [Navigator] widgets,
/// including the navigator provided by [MaterialApp].
///
/// For example like this
/// ```dart
/// BetterFeedback(
///   child: MaterialApp(
///   title: 'App',
///   home: MyHomePage(),
/// );
/// ```
class BetterFeedback<T, R> extends StatefulWidget {
  static BetterFeedback<OnSubmit?, UserFeedback> simpleFeedback({
    Key? key,
    required Widget child,
    ThemeMode? themeMode,
    FeedbackThemeData? theme,
    FeedbackThemeData? darkTheme,
    List<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Locale? localeOverride,
    FeedbackMode mode = FeedbackMode.draw,
  }) =>
      BetterFeedback.customFeedback(
        key: key,
        feedbackBuilder: simpleFeedbackBuilder,
        themeMode: themeMode,
        darkTheme: darkTheme,
        localizationsDelegates: localizationsDelegates,
        localeOverride: localeOverride,
        mode: mode,
        child: child,
      );

  const BetterFeedback.customFeedback({
    super.key,
    required this.child,
    required this.feedbackBuilder,
    this.themeMode,
    this.theme,
    this.darkTheme,
    this.localizationsDelegates,
    this.localeOverride,
    this.mode = FeedbackMode.draw,
  });

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  /// Returns a widget that prompts the user for feedback and calls the provided
  /// submit function with their completed feedback. Typically, this involves
  /// some form fields and a submit button that calls [OnSubmit] when pressed.
  /// Defaults to [StringFeedback] which uses a single editable text field to
  /// prompt for input.
  final FeedbackBuilder<T, R> feedbackBuilder;

  /// Determines which theme will be used by the Feedback UI.
  /// If set to [ThemeMode.system], the choice of which theme to use will be based
  /// on the user's system preferences (using the [MediaQuery.platformBrightnessOf]).
  /// If set to [ThemeMode.light] the [theme] will be used, regardless of the user's
  /// system preference.  If [theme] isn't provided [FeedbackThemeData] will
  /// be used.
  /// If set to [ThemeMode.dark] the [darkTheme] will be used regardless of the
  /// user's system preference. If [darkTheme] isn't provided, will fallback to
  /// [theme]. If both [darkTheme] and [theme] aren't provided
  /// [FeedbackThemeData.dark] will be used.
  /// The default value is [ThemeMode.system].
  final ThemeMode? themeMode;

  /// The Theme, which gets used to style the feedback ui if the [themeMode] is
  /// ThemeMode.light or user's system preference is light.
  final FeedbackThemeData? theme;

  /// The theme, which gets used to style the feedback ui if the [themeMode] is
  /// ThemeMode.dark or user's system preference is dark.
  final FeedbackThemeData? darkTheme;

  /// The delegates for this library's FeedbackLocalization widget.
  /// You need to supply the following delegates if you choose to customize it.
  /// [MaterialLocalizations]
  /// [CupertinoLocalizations]
  /// [WidgetsLocalizations]
  /// an instance of [LocalizationsDelegate]<[FeedbackLocalizations]>
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Can be used to set the locale.
  /// If it is not set, the platform default locale is used.
  /// If no platform default locale exists, english is used.
  final Locale? localeOverride;

  /// Set the default mode when launching feedback.
  /// By default it will allow the user to navigate.
  /// See [FeedbackMode] for other options.
  final FeedbackMode mode;

  /// Call `BetterFeedback.of(context)` to get an
  /// instance of [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  ///
  /// For example:
  /// ```dart
  /// BetterFeedback.of(context).show(...);
  /// BetterFeedback.of(context).hide(...);
  /// ```
  static FeedbackController<T, R> of<T, R>(BuildContext context) {
    final feedbackData = context.dependOnInheritedWidgetOfExactType<FeedbackData<T, R>>();
    assert(
      feedbackData != null,
      'You need to add a ${BetterFeedback<T, R>} widget above this context!',
    );
    return feedbackData!.controller;
  }

  static FeedbackController<OnSubmit?, UserFeedback> simpleFeedbackOf(BuildContext context) {
    return of<OnSubmit?, UserFeedback>(context);
  }

  @override
  State<BetterFeedback<T, R>> createState() => _BetterFeedbackState();
}

class _BetterFeedbackState<T, R> extends State<BetterFeedback<T, R>> {
  FeedbackController<T, R> controller = FeedbackController();

  @override
  void initState() {
    super.initState();
    printRendererErrorMessageIfNecessary();
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
      themeMode: widget.themeMode,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      localizationsDelegates: widget.localizationsDelegates,
      localeOverride: widget.localeOverride,
      child: Builder(builder: (context) {
        return FeedbackData(
          controller: controller,
          child: Builder(
            builder: (context) {
              assert(debugCheckHasFeedbackLocalizations(context));
              return FeedbackWidget<T, R>(
                isVisible: controller.isVisible,
                route: controller.currentRoute,
                drawColors: FeedbackTheme.of(context).drawColors,
                mode: widget.mode,
                feedbackBuilder: widget.feedbackBuilder,
                child: widget.child,
              );
            },
          ),
        );
      }),
    );
  }

  void onUpdateOfController() {
    setState(() {});
  }
}
