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
