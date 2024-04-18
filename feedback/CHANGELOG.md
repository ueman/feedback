## [3.1.0]

- Fix dialog pop issue [#293](https://github.com/ueman/feedback/pull/293). This may break custom feedback builder. Make sure to test those before updating.

## [3.0.1]

* Theme is now able to configure more UI elements

## [3.0.0]

* Require Flutter 3.10.0
* Require Dart 3.0.0
* Add dark mode
* Improve feedback controller

## [2.6.0]

* Require Flutter 3.0.0

## [2.5.0]

* Added polish language
* Requires at least Flutter 2.10.0
* Compatibility with Flutter 3
* Reuses MediaQuery if available

## [2.4.1]

* Fix backspace not working in some cases ([#120](https://github.com/ueman/feedback/issues/120), [#177](https://github.com/ueman/feedback/issues/177))

## [2.4.0]

* Improve overriding of localization texts

## [2.3.1]

* Removed `meta` dependency

## [2.3.0]

* bottom sheet gets closed on back press
* Added support for the following languages: russian (ru), ukrainian (uk), turkish (tr), simimplified chinese (zh)
* *Breaking* if you're using a custom `feedbackBuilder`
* Fixes [152](https://github.com/ueman/feedback/issues/152), [138](https://github.com/ueman/feedback/issues/138), [88](https://github.com/ueman/feedback/issues/88)

## [2.2.1]

* The feedback ui always opens in the configured mode [#137](https://github.com/ueman/feedback/pull/137)
* Added support for arabic language [#140](https://github.com/ueman/feedback/pull/140)

## [2.2.0+4]

* Improve documentation

## [2.2.0+3]

* Use correct license text

## [2.2.0]

- `BetterFeedback.of()` now returns a `FeebdackController` instead of `FeedbackData`. This should be non-breaking change for most users.
- Improve documentation

## [2.1.0]

- The back button now [intelligently](https://github.com/ueman/feedback/issues/116) reverses drawings and closes the drawing mode
- OnFeedbackCallback accepts a FutureOr<void>. Previously it just accepted void callbacks.

## [2.0.0]

THIS IS A BREAKING CHANGE

- Current feedback mode is highlighted
- Add ability to add custom feedback forms
- `BetterFeedback.of()` returns an instance or throws
- `BetterFeedback.of().show()` gives an instance of `UserFeedback`
- Removed `consoleFeedbackFunction` and `alertFeedbackFunction`
- Default feedback mode changed to draw

## [1.2.2]

- Documentation update

## [1.2.1]

- Enter-Button on the keyboard dismisses the keyboard
- Improved example app

## [1.2.0]

- Add option for changing the quality and size of the screenshot (`BetterFeedback.pixelRatio`)

## [1.1.0]

- Fix Flutter Web (#13, #50)
- Add option for changing the default feedback mode

## [1.0.2]

- Fix: Color Icon buttons are bigger to improve accessibility
- Fix: Clear drawing after sending feedback (#46)

## [1.0.1]
- Fix an [issue](https://github.com/ueman/feedback/issues/42) where the drawing would't make it onto the feedback image

## [1.0.0]
- stable null safe release

## [1.0.0-nullsafety.2]
- Update meta to ^1.3.0

## [1.0.0-nullsafety.1]
- Fix deprecation warnings

## [1.0.0-nullsafety.0+1]
- Improve Readme

## [1.0.0-nullsafety]
- Migrated to nullsafety

## [1.0.0-beta]
- Removed dependency on MaterialApp
- Use Flutter mechanism for localization
- Theming is now done through FeedbackTheme

## [0.2.1+1] - 06. April 2020

- better readme

## [0.2.1] - 08. March 2020

### Changed
- Text instead of Icons for drawing and navigating
- round stroke caps for drawn paths

## [0.2.0] - 22. February 2020

This is the first non-beta version.

### Added
- Colors are now more customizable

### Changed
- Usage of the ControlsColumn hides the keyboard,
  which should result in better usability


## [0.1.0-beta] - 15. February 2020
### Fixed
- Screenshots are taken correctly without any transparent border
- The bottom insets are taken into consideration while the feedback view is active

### Changed
- Hopefully the new icons in the ControlsColumn are more intuitive

## [0.0.1] - 8. February 2020

* initial release
