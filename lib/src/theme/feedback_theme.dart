import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _defaultDrawColors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
];

/// This is the same as Colors.grey[50]
/// or the default value of ThemeData.canvasColor
const _lightGrey = Color(0xFFFAFAFA);

const _defaultBottomSheetDescriptionStyle = TextStyle(
  color: Colors.black,
);

class FeedbackThemeData {
  FeedbackThemeData({
    this.background = Colors.grey,
    this.feedbackSheetColor = _lightGrey,
    this.drawColors = _defaultDrawColors,
    this.bottomSheetDescriptionStyle = _defaultBottomSheetDescriptionStyle,
  })  : assert(background != null),
        assert(feedbackSheetColor != null),
        assert(bottomSheetDescriptionStyle != null),
        // if the user chooses to supply custom drawing colors,
        // make sure there is at least on color to draw with
        assert(
          // ignore: prefer_is_empty
          drawColors != null && drawColors.length > 0,
          'There must be at least one color to draw with',
        );

  /// The background of the feedback view.
  final Color background;

  /// The background color of the bottomsheet in which the user can input
  /// his feedback and thougts.
  final Color feedbackSheetColor;

  /// Colors which can be used to draw while in feedback mode.
  final List<Color> drawColors;

  /// Text Style of the text above of the feedback text input.
  final TextStyle bottomSheetDescriptionStyle;
}

class FeedbackTheme extends InheritedTheme {
  /// Creates a feedback theme that controls the color, opacity, and size of
  /// descendant widgets.
  ///
  /// Both [data] and [child] arguments must not be null.
  const FeedbackTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  final FeedbackThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FeedbackThemeData theme = FeedbackTheme.of(context);
  /// ```
  static FeedbackThemeData of(BuildContext context) {
    final feedbackThemeData =
        context.dependOnInheritedWidgetOfExactType<FeedbackTheme>();
    return feedbackThemeData?.data ?? FeedbackThemeData();
  }

  @override
  bool updateShouldNotify(FeedbackTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final theme = context.findAncestorWidgetOfExactType<FeedbackTheme>();
    return identical(this, theme)
        ? child
        : FeedbackTheme(data: data, child: child);
  }
}
