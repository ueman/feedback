/// Position of the custom color picker icon.
enum CustomColorPosition {
  /// Places the custom color picker icon at the BEGINNING of the drawing colors list.
  leading,

  /// Places the custom color picker icon at the END of the drawing colors list.
  trailing;

  /// Returns true if the icon is placed at the beginning of the drawing colors list.
  bool get isLeading => this == CustomColorPosition.leading;

  /// Returns true if the icon is placed at the end of the drawing colors list.
  bool get isTrailing => this == CustomColorPosition.trailing;
}
