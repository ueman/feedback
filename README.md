<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/feedback.svg" max-height="100" alt="Feedback" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/feedback"><img src="https://img.shields.io/pub/v/feedback.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman/feedback/actions/workflows/feedback.yml"><img src="https://github.com/ueman/feedback/actions/workflows/feedback.yml/badge.svg" alt="feedback workflow"></a>
  <a href="https://codecov.io/gh/ueman/feedback"><img src="https://codecov.io/gh/ueman/feedback/branch/master/graph/badge.svg" alt="code coverage"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/likes" alt="likes"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/popularity" alt="popularity"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://badges.bar/feedback/pub%20points" alt="pub points"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/ff.png" height="100" alt="Flutter Favorite" />
</p>

---

💰 Using this library in a commercial product? Consider [becoming a sponsor](https://github.com/ueman#sponsor-me).

---

A Flutter package for obtaining better feedback. It allows the user to provide interactive feedback 
directly in the app, by annotating a screenshot of the current page, as well as by adding text.

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/example_0.1.0-beta.gif" width="200" alt="Example Image">
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

### Plugins

Depending on your use case there are wide variety of solutions.
These are a couple suggestions:

| Plugin                         | Package                          |
|--------------------------------|--------------------------------|
| GitLab Issue                   | [feedback_gitlab](https://pub.dev/packages/feedback_gitlab) |
| Sentry User Feedback           | [feedback_sentry](https://pub.dev/packages/feedback_sentry) |


| Target                         | Notes                          |
|--------------------------------|--------------------------------|
| Upload to a server             | To upload the feedback to a server you should use for example a [MultipartRequest](https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html). |
| Share via platform share dialog | [share_plus on pub.dev](https://pub.dev/packages/share_plus). Also shown in the example. |
| Firebase | [Firestore](https://pub.dev/packages/cloud_firestore), [Cloud Storage](https://pub.dev/packages/firebase_storage), [Database](https://pub.dev/packages/firebase_database)
|   Jira | Jira has a [REST API to create issues and upload files](https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/#creating-an-issue-examples) |
| Trello | Trello has a [REST API to create issues and upload files](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/) |
| E-Mail | You can use the users email client like [in the sample app](https://github.com/ueman/feedback/blob/master/example/lib/main.dart) to send feedback to yourself using the [flutter_email_sender](https://pub.dev/packages/flutter_email_sender) plugin. |


If you have sample code on how to upload it to a platform, I would appreciate a pull request to the example app.

## 📣  Maintainer

Hey, I'm Jonas Uekötter. I created this awesome software. Visit my [GitHub profile](https://github.com/ueman) and follow me on [Twitter](https://twitter.com/ue_man). If you like this, please leave a like or star it on GitHub.

## Contributors

<a href="https://github.com/ueman/feedback/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ueman/feedback" />
</a>
