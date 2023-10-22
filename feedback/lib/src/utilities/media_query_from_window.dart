// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// copied from https://github.com/flutter/flutter/blob/1ad9baa8b9/packages/flutter/lib/src/widgets/app.dart#L1417
/// Builds [MediaQuery] from `window` by listening to [WidgetsBinding].
///
/// It is performed in a standalone widget to rebuild **only** [MediaQuery] and
/// its dependents when `window` changes, instead of rebuilding the entire
/// widget tree.
class MediaQueryFromWindow extends StatefulWidget {
  const MediaQueryFromWindow({super.key, required this.child});

  final Widget child;

  @override
  State<MediaQueryFromWindow> createState() => _MediaQueryFromWindowsState();
}

class _MediaQueryFromWindowsState extends State<MediaQueryFromWindow>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _binding!.addObserver(this);
  }

  // ACCESSIBILITY

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {
      // The properties of window have changed. We use them in our build
      // function, so we need setState(), but we don't cache anything locally.
    });
  }

  // METRICS

  @override
  void didChangeMetrics() {
    setState(() {
      // The properties of window have changed. We use them in our build
      // function, so we need setState(), but we don't cache anything locally.
    });
  }

  @override
  void didChangeTextScaleFactor() {
    setState(() {
      // The textScaleFactor property of window has changed. We reference
      // window in our build function, so we need to call setState(), but
      // we don't need to cache anything locally.
    });
  }

  // RENDERING
  @override
  void didChangePlatformBrightness() {
    setState(() {
      // The platformBrightness property of window has changed. We reference
      // window in our build function, so we need to call setState(), but
      // we don't need to cache anything locally.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _binding!.removeObserver(this);
    super.dispose();
  }

  // Needed because `WidgetsBinding.instance` is nullable up to 2.10
  // and non-nullable after 2.10.
  WidgetsBinding? get _binding => WidgetsBinding.instance;
}
