<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/feedback.svg" max-height="100" alt="Feedback" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/feedback"><img src="https://img.shields.io/pub/v/feedback.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman/feedback/actions?query=workflow%3Abuild"><img src="https://github.com/ueman/feedback/workflows/build/badge.svg?branch=master" alt="GitHub Workflow Status"></a>
  <a href="https://codecov.io/gh/ueman/feedback"><img src="https://codecov.io/gh/ueman/feedback/branch/master/graph/badge.svg" alt="code coverage"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/likes" alt="likes"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/popularity" alt="popularity"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/pub%20points" alt="pub points"></a>
</p>

---

A Flutter package for obtaining better feedback. It allows the user to provide interactive feedback 
directly in the app, by annotating a screenshot of the current page, as well as by adding text.

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/example_0.1.0-beta.gif" width="200" alt="Example Image">
</p>

## Demo

An interactive web example is available here: <a href="https://flutter-feedback.netlify.app/"><img src="https://img.shields.io/badge/Try-Flutter%20Web%20demo-blue" alt="Online demo"></a>. It also contains a small tutorial on how to use this library.

## Motivation

It is often quite hard to achieve a very good user experience. The most important
aspect of creating a good user experience is to obtain and to listen to feedback
of your user. Focus groups are one solution to this problem but it is quite expensive. Another solution is to use this library to obtain direct feedback
of your users. This library is lightweight and easy to integrate and makes it
really easy for your users to send valuable feedback to you.

By obtaining the feedback with an annotated image it is much easier for you
get a good understanding of your users problem with a certain feature or screen
of your app. It is like the saying "A picture is worth a thousand words" because
a textual description can be interpreted in many ways which makes it harder to
understand.

## 🚀 Getting Started

### Setup

First, you will need to add `feedback` to your `pubspec.yaml`.
The latest version is <a href="https://pub.dev/packages/feedback"><img src="https://img.shields.io/pub/v/feedback.svg" alt="pub.dev"></a>.

```yaml
dependencies:
  flutter:
    sdk: flutter
  feedback: x.y.z # use the latest version found on pub.dev
```

Then, run `flutter packages get` in your terminal.

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
BetterFeedback.of(context).show((UserFeedback feedback) {
  // Do something with the feedback
});
```
Provide a way to hide the feedback panel by calling  `BetterFeedback.of(context).hide();` 

### Use the feedback

Depending on your use case there are wide variety of solutions.
These are a couple suggestions:

| Target |   Notes |
|--------|---------|
| Upload to a server | To upload the feedback to a server you should use for example a [MultipartRequest](https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html). |
| GitLab Issue | GitLab has a [REST API to create issues](https://docs.gitlab.com/ee/api/issues.html) |
| Share via platform share dialog | [share_plus on pub.dev](https://pub.dev/packages/share_plus). Also shown in the example. |
| Firebase | [Firestore](https://pub.dev/packages/cloud_firestore), [Cloud Storage](https://pub.dev/packages/firebase_storage), [Database](https://pub.dev/packages/firebase_database)
|   Jira | Jira has a [REST API to create issues and upload files](https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/#creating-an-issue-examples) |
| Trello | Trello has a [REST API to create issues and upload files](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/) |
| E-Mail | You can use the users email client like [in the sample app](https://github.com/ueman/feedback/blob/master/example/lib/main.dart) to send feedback to yourself using the [flutter_email_sender](https://pub.dev/packages/flutter_email_sender) plugin. |


If you have sample code on how to upload it to a platform, I would appreciate a pull request to the example app.

### 🎨 Configuration & customization

```dart
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    BetterFeedback(
      child: const MyApp(),
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalFeedbackLocalizationsDelegate(),
      ],
      localeOverride: const Locale('en'),
    ),
  );
}
```
You can customize the text by using custom `localizationsDelegates`.
How the properties of `FeedbackThemeData` correspond to the view can be seen in the following image. 
<img src="https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png" max-height="400" alt="Theme Usages">

## 💡 Tips, tricks and usage scenarios

- You can combine this with [device_info_plus](https://pub.dev/packages/device_info_plus)
and [package_info_plus](https://pub.dev/packages/package_info_plus) to 
get additional information about the users environment to better understand
his feedback and debug his issues. 
- You can record the users navigation with a [NavigatorObserver](https://api.flutter.dev/flutter/widgets/NavigatorObserver-class.html) and send it as an addition to the 
feedback of the user. This way you know how the user got to the location shown
in the screenshot.
- Use it as an internal quality control tool

## ⚠️ Known Issues and limitations

- Platform views are invisible in screenshots (like [webview](https://pub.dev/packages/webview_flutter) or [Google Maps](https://pub.dev/packages/google_maps_flutter)). For further details, see this [Flutter issue](https://github.com/flutter/flutter/issues/25306).
- Web only works with Flutter's CanvasKit Renderer, for more information see [Flutter Web Renderer docs](https://flutter.dev/docs/development/tools/web-renderers).

## 📣  Author

- Jonas Uekötter: [GitHub](https://github.com/ueman) and [Twitter](https://twitter.com/ue_man)

## Issues, questions and contributing

You can raise issues [here](https://github.com/ueman/feedback/issues).
If you've got a question do not hesitate to ask it [here](https://github.com/ueman/feedback/discussions).
Contributions are also welcome. You can do a pull request on GitHub [here](https://github.com/ueman/feedback/pulls). Please take a look at [`up for grabs`](https://github.com/ueman/feedback/issues?q=is%3Aopen+is%3Aissue+label%3Aup-for-grabs) issues first.

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to [sponsor](https://github.com/ueman#sponsor-me) me. By doing so, I will prioritize your issues or your pull-requests before the others.
