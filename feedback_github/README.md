# feedback_github

## 🚀 Getting Started

### Setup

First, you will need to add `feedback_github` to your `pubspec.yaml`.
The latest version is <a href="https://pub.dev/packages/feedback_github"><img src="https://img.shields.io/pub/v/feedback_github.svg" alt="pub.dev"></a>.

```yaml
dependencies:
  flutter:
    sdk: flutter
  feedback_github:
    git: 
      url: https://github.com/defuncart/fork_feedback/
      path: feedback_github
      ref: feature/add-create-issue-on-github

dependency_overrides:
  feedback:
    git: 
      url: https://github.com/defuncart/fork_feedback/
      path: feedback
      ref: feature/add-create-issue-on-github
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
BetterFeedback.of(context).showAndUploadToGitHub(
  username: 'username',
  repository: 'repository',
  authToken: 'github_pat_',
  labels: ['feedback'],
  assignees: ['username'],
  customMarkdown: '**Hello World**',
  imageId: Uuid().v4(),
);
```
Provide a way to hide the feedback panel by calling  `BetterFeedback.of(context).hide();` 


## Repository Setup

The github repository `repository` for user `username` requires a `issue_images` branch where the images for issue can be uploaded to.

## 📣  Author

- Jonas Uekötter: [GitHub](https://github.com/ueman) and [Twitter](https://twitter.com/ue_man)

## Issues, questions and contributing

You can raise issues [here](https://github.com/ueman/feedback/issues).
If you've got a question do not hesitate to ask it [here](https://github.com/ueman/feedback/discussions).
Contributions are also welcome. You can do a pull request on GitHub [here](https://github.com/ueman/feedback/pulls). Please take a look at [`up for grabs`](https://github.com/ueman/feedback/issues?q=is%3Aopen+is%3Aissue+label%3Aup-for-grabs) issues first.

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to [sponsor](https://github.com/ueman#sponsor-me) me. By doing so, I will prioritize your issues or your pull-requests before the others.
