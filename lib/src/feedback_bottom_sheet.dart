import 'dart:math';

import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// Shows the text input in which the user can describe his feedback.
class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackBuilder,
    required this.onSubmit,
    required this.collapsedHeight,
  }) : super(key: key);

  final FeedbackBuilder feedbackBuilder;
  final OnSubmit onSubmit;
  final double collapsedHeight;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        minChildSize: collapsedHeight / MediaQuery.of(context).size.height,
        initialChildSize: collapsedHeight / MediaQuery.of(context).size.height,
        builder: (context, scrollController) {
          // We need to supply a navigator so that the contents of the bottom
          // sheet have access to an overlay (overlays are used by many material
          // widgets such as `TextField` and `DropDownButton`.
          // Typically, the navigator would be provided by a `MaterialApp`, but
          // `BetterFeedback` is used above `MaterialApp` in the widget tree so
          // that the nested navigation in navigate mode works properly.
          return ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
            child: Material(
              color: FeedbackTheme.of(context).feedbackSheetColor,
              child: Column(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 5,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Navigator(
                      onGenerateRoute: (_) => MaterialPageRoute<void>(
                        builder: (context) => feedbackBuilder(
                            context, onSubmit, scrollController),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double expandedHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
}
