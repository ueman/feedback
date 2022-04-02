// ignore_for_file: public_member_api_docs

import 'dart:collection';

import 'package:flutter/widgets.dart';

typedef BoolCallback = bool Function();

class BackButtonInterceptor with WidgetsBindingObserver {
  BackButtonInterceptor._();

  @visibleForTesting
  static final BackButtonInterceptor instance = BackButtonInterceptor._();

  static final SplayTreeMap<double, List<BoolCallback>> _prioritizedCallbacks =
      SplayTreeMap();

  static void add(BoolCallback callback, {int? priority}) {
    if (_prioritizedCallbacks.isEmpty) {
      _mount();
    }
    final List<BoolCallback>? callbacksList = _prioritizedCallbacks[priority];
    if (callbacksList == null) {
      // Convert to double so that we have a valid maximum value to sort null
      // priorities last.
      _prioritizedCallbacks[priority?.toDouble() ?? double.infinity] = [
        callback
      ];
      return;
    }
    callbacksList.add(callback);
  }

  static void remove(BoolCallback callback) {
    _prioritizedCallbacks.values
        .any((callbackList) => callbackList.remove(callback));
    _prioritizedCallbacks.removeWhere((key, value) => value.isEmpty);
    if (_prioritizedCallbacks.isEmpty) {
      _unMount();
    }
  }

  static void _mount() {
    _binding!.addObserver(instance);
  }

  static void _unMount() {
    _prioritizedCallbacks.clear();
    _binding!.removeObserver(instance);
  }

  Iterable<BoolCallback> get _callbacks =>
      _prioritizedCallbacks.values.expand((lst) => lst);

  @override
  Future<bool> didPopRoute() async {
    if (_callbacks.isEmpty) {
      return await super.didPopRoute();
    }
    return _callbacks.any((callback) => callback());
  }

  // Needed because `WidgetsBinding.instance` is nullable up to 2.10
  // and non-nullable after 2.10.
  static WidgetsBinding? get _binding => WidgetsBinding.instance;
}
