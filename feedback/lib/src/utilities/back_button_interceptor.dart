// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

typedef BoolCallback = bool Function();

class BackButtonInterceptor with WidgetsBindingObserver {
  BoolCallback? _callback;

  void add(BoolCallback callback) {
    if (_callback == null) {
      WidgetsBinding.instance!.addObserver(this);
    }
    _callback = callback;
  }

  void dispose() {
    _callback = null;
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Future<bool> didPopRoute() async {
    return _callback?.call() ?? await super.didPopRoute();
  }
}
