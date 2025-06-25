import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:sentry/sentry.dart';

void main() {
  test('adds one to input values', () async {
    final mockHub = MockHub();
    sendToSentry(
      hub: mockHub,
      name: 'foo',
      email: 'bar@foo.de',
    )(UserFeedback(
      screenshot: Uint8List.fromList([]),
      text: 'foo bar',
      extra: {'foo': 'bar'},
    ));

    final completed = await mockHub.completer.future;

    expect(completed, true);

    expect(mockHub.capturedFeedback?.message, 'foo bar');
    expect(mockHub.capturedFeedback!.unknown?['foo'], 'bar');
    expect(mockHub.capturedFeedback?.name, 'foo');
    expect(mockHub.capturedFeedback?.contactEmail, 'bar@foo.de');

    expect(mockHub.captureHint?.screenshot?.filename, "screenshot.png");
  });
}

class MockHub implements Hub {
  SentryFeedback? capturedFeedback;
  String? capturedMessage;
  Scope scope = Scope(SentryOptions());
  Completer<bool> completer = Completer<bool>();
  Hint? captureHint;

  @override
  Future<SentryId> captureMessage(
    String? message, {
    SentryLevel? level,
    String? template,
    List? params,
    Hint? hint,
    ScopeCallback? withScope,
  }) async {
    capturedMessage = message;
    withScope?.call(scope);
    return SentryId.newId();
  }

  @override
  Future<SentryId> captureFeedback(
    SentryFeedback feedback, {
    Hint? hint,
    ScopeCallback? withScope,
  }) async {
    capturedFeedback = feedback;
    withScope?.call(scope);
    captureHint = hint;
    completer.complete(true);
    return SentryId.newId();
  }

  // Used so that unneeded methods, do not need to be overridden.
  @override
  void noSuchMethod(Invocation invocation) {}
}
