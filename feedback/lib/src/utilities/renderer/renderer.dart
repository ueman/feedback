// ignore_for_file: public_member_api_docs
// coverage:ignore-file

import 'package:feedback/src/utilities/renderer/_io_renderer.dart'
    if (dart.library.html) 'package:feedback/src/utilities/renderer/_html_renderer.dart'
    as impl;

void printRendererErrorMessageIfNecessary() => impl.printErrorMessage();
