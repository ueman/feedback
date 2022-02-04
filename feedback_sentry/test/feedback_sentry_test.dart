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

    expect(mockHub.capturedMessage, 'foo bar');

    expect(mockHub.capturedFeedback?.comments, 'foo bar\n{foo: bar}');
    expect(mockHub.capturedFeedback?.name, 'foo');
    expect(mockHub.capturedFeedback?.email, 'bar@foo.de');

    expect(mockHub.scope.attachements.length, 1);
  });
}

class MockHub implements Hub {
  SentryUserFeedback? capturedFeedback;
  String? capturedMessage;
  Scope scope = Scope(SentryOptions());
  Completer<bool> completer = Completer<bool>();

  @override
  Future<SentryId> captureMessage(
    String? message, {
    SentryLevel? level,
    String? template,
    List? params,
    hint,
    ScopeCallback? withScope,
  }) async {
    capturedMessage = message;
    withScope?.call(scope);
    return SentryId.newId();
  }

  @override
  Future<void> captureUserFeedback(SentryUserFeedback userFeedback) async {
    capturedFeedback = userFeedback;
    completer.complete(true);
  }

  // The following code is not used

  @override
  void configureScope(ScopeCallback callback) {}

  @override
  void addBreadcrumb(Breadcrumb crumb, {hint}) {}

  @override
  void bindClient(SentryClient client) {}

  @override
  Future<SentryId> captureEvent(
    SentryEvent event, {
    stackTrace,
    hint,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SentryId> captureException(
    throwable, {
    stackTrace,
    hint,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Hub clone() {
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    throw UnimplementedError();
  }

  @override
  bool get isEnabled => throw UnimplementedError();

  @override
  SentryId get lastEventId => throw UnimplementedError();

  @override
  Future<SentryId> captureTransaction(SentryTransaction transaction) {
    throw UnimplementedError();
  }

  @override
  ISentrySpan? getSpan() {
    throw UnimplementedError();
  }

  @override
  void setSpanContext(throwable, ISentrySpan span, String transaction) {}

  @override
  ISentrySpan startTransaction(
    String name,
    String operation, {
    String? description,
    bool? bindToScope,
    Map<String, dynamic>? customSamplingContext,
  }) {
    throw UnimplementedError();
  }

  @override
  ISentrySpan startTransactionWithContext(
    SentryTransactionContext transactionContext, {
    Map<String, dynamic>? customSamplingContext,
    bool? bindToScope,
  }) {
    throw UnimplementedError();
  }
}
