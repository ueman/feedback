<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/feedback.svg" max-height="100" alt="Feedback" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/feedback"><img src="https://img.shields.io/pub/v/feedback.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman/feedback/actions/workflows/feedback.yml"><img src="https://github.com/ueman/feedback/actions/workflows/feedback.yml/badge.svg" alt="feedback workflow"></a>
  <a href="https://codecov.io/gh/ueman/feedback"><img src="https://codecov.io/gh/ueman/feedback/branch/master/graph/badge.svg" alt="code coverage"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/likes/feedback" alt="likes"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/popularity/feedback" alt="popularity"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/points/feedback" alt="pub points"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/ff.png" height="100" alt="Flutter Favorite" />
</p>

A Flutter package for obtaining better feedback. It allows the user to provide interactive feedback 
directly in the app, by annotating a screenshot of the current page, as well as by adding text.

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/example_0.1.0-beta.gif" width="200" alt="Example Image">
</p>

<p align="center">

[![Package of the week video](https://img.youtube.com/vi/yjsN2Goe_po/0.jpg)](https://www.youtube.com/watch?v=yjsN2Goe_po "feedback (Package of the Week)")

</p>

## Demo

An interactive web example is available here: <a href="https://ueman.github.io/feedback/"><img src="https://img.shields.io/badge/Try-Flutter%20Web%20demo-blue" alt="Online demo"></a>. It also contains a small tutorial on how to use this library.

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

Then, run `flutter pub get` in your terminal.

> If you're using Flutter for Web, you have to build the project with `flutter build web --web-renderer canvaskit`.
> For more information on the CanvasKit renderer please look into [Flutters documentation](https://flutter.dev/docs/development/tools/web-renderers).

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
Provide a way to hide the feedback panel by calling `BetterFeedback.of(context).hide();` 

### Use the feedback

Depending on your use case there are wide variety of solutions.
These are a couple suggestions:

#### GitLab plugin

The [feedback_gitlab](https://pub.dev/packages/feedback_gitlab) plugin creates 
an issue on [GitLab](https://about.gitlab.com/) for each feedback submitted by the users.

Just use it as shown in the following example. It openes the feedback ui and
after the user has submitted his feedback, it gets automatically uploaded 
to GitLab.

```dart
import 'package:feedback_gitlab/feedback_gitlab.dart';

BetterFeedback.of(context).showAndUploadToGitLab(
    projectId: 'project-Id', // Required, use your GitLab project id
    apiToken: 'api-token', // Required, use your GitLab API token
    gitlabUrl: 'gitlab.org', // Optional, defaults to 'gitlab.com'
);
```
The API token needs access to `read_api` and `write_repository`.
See [GitLabs docs](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#limiting-scopes-of-a-project-access-token)
for more information on API tokens.


#### Sentry plugin
The [feedback_sentry](https://pub.dev/packages/feedback_sentry) submits the 
feedback to Sentry as Sentry User Feedback. It works with [sentry](https://pub.dev/packages/sentry) and [sentry_flutter](https://pub.dev/packages/sentry_flutter). 

Just use it as shown in the following example. It openes the feedback ui and
after the user has submitted his feedback, it gets automatically uploaded 
to Sentry.

```dart
import 'package:feedback_sentry/feedback_sentry.dart';

BetterFeedback.of(context).showAndUploadToSentry(
    name: 'Foo Bar', // optional
    email: 'foo_bar@example.com', // optional
);
```

#### Other use cases

| Target                         | Notes                          |
|--------------------------------|--------------------------------|
| Upload to a server             | To upload the feedback to a server you should use for example a [MultipartRequest](https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html). |
| Share via platform share dialog | [share_plus on pub.dev](https://pub.dev/packages/share_plus). Also shown in the example. |
| Firebase | [Firestore](https://pub.dev/packages/cloud_firestore), [Cloud Storage](https://pub.dev/packages/firebase_storage), [Database](https://pub.dev/packages/firebase_database)
| Jira | Jira has a [REST API to create issues and upload files](https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/#creating-an-issue-examples) |
| Trello | Trello has a [REST API to create issues and upload files](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/) |
| E-Mail | You can use the users email client like [in the sample app](https://github.com/ueman/feedback/blob/master/feedback/example/lib/main.dart#L147-L160) to send feedback to yourself using the [flutter_email_sender](https://pub.dev/packages/flutter_email_sender) plugin. |

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
      localizationsDelegates: [
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
How the properties of `FeedbackThemeData` correspond to the view can be seen in the following image. 
<img src="https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png" max-height="400" alt="Theme Usages">

## Changing the localizations texts

You can customize the localizations as follows.
Create your own implementation of `FeedbackLocalizations` or subclass one of 
the existing translations, if you just want to change one or two texts.
Then create your own `GlobalFeedbackLocalizationsDelegate` and pass it to 
`BetterFeedback`.

```dart
class CustomFeedbackLocalizations implements FeedbackLocalizations {
  // ...
}

class CustomFeedbackLocalizationsDelegate
    extends GlobalFeedbackLocalizationsDelegate {
  static final supportedLocales = <Locale, FeedbackLocalizations>{
    // remember to change the locale identifier
    // as well as that defaultLocale (defaults to en) should ALWAYS be
    // present here or overridden
    const Locale('en'): const CustomFeedbackLocalizations(),
  };
}

void main() {
  runApp(
    BetterFeedback(
      child: const MyApp(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomFeedbackLocalizationsDelegate(),
      ],
    ),
  );
}
```

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
- Web only works with Flutter's CanvasKit Renderer. For more information on how to use it, see [Flutter Web Renderer docs](https://flutter.dev/docs/development/tools/web-renderers).
- If you are using [showDialog](https://api.flutter.dev/flutter/material/showDialog.html), you will notice that the [Dialog](https://api.flutter.dev/flutter/material/Dialog-class.html) is rendered above the `BetterFeedback`. To prevent this you have to set `useRootNavigator` in `showDialog` to `false`.

## 📣 Maintainer

Hey, I'm Jonas Uekötter. I created this awesome software. Visit my [GitHub profile](https://github.com/ueman) and follow me on [Twitter](https://twitter.com/ue_man). If you like this, please leave a like or star it on GitHub.

## Issues, questions and contributing

You can raise issues [here](https://github.com/ueman/feedback/issues).
If you've got a question do not hesitate to ask it [here](https://github.com/ueman/feedback/discussions).
Contributions are also welcome. You can do a pull request on GitHub [here](https://github.com/ueman/feedback/pulls). Please take a look at [`up for grabs`](https://github.com/ueman/feedback/issues?q=is%3Aopen+is%3Aissue+label%3Aup-for-grabs) issues first.
