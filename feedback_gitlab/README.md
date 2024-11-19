# feedback_gitlab

## 🚀 Getting Started

### Setup

First, you will need to add `feedback_gitlab` to your `pubspec.yaml`.
The latest version is <a href="https://pub.dev/packages/feedback_gitlab"><img src="https://img.shields.io/pub/v/feedback_gitlab.svg" alt="pub.dev"></a>.

```yaml
dependencies:
  flutter:
    sdk: flutter
  feedback_gitlab: x.y.z # use the latest version found on pub.dev
```

Then, run `flutter pub get` in your terminal.

### Use it

Just wrap your app in a `BetterFeedback` widget.
To show the feedback view just call `BetterFeedback.of(context).show(...);`.
The callback gets called when the user submits his feedback. 

```dart
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    BetterFeedback(
      child: const MyApp(),
    ),
  );
}
```

Provide a way to show the feedback panel by calling 
```dart
BetterFeedback.of(context).showAndUploadToGitLab(
    projectId: 'project-Id',
    apiToken: 'api-token',
);
```
Provide a way to hide the feedback panel by calling  `BetterFeedback.of(context).hide();` 


## 📣  Author

- Jonas Uekötter: [GitHub](https://github.com/ueman) and [Twitter](https://twitter.com/ue_man)

## Issues, questions and contributing

You can raise issues [here](https://github.com/ueman/feedback/issues).
If you've got a question do not hesitate to ask it [here](https://github.com/ueman/feedback/discussions).
Contributions are also welcome. You can do a pull request on GitHub [here](https://github.com/ueman/feedback/pulls). Please take a look at [`up for grabs`](https://github.com/ueman/feedback/issues?q=is%3Aopen+is%3Aissue+label%3Aup-for-grabs) issues first.
