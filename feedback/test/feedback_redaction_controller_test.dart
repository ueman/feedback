import 'package:feedback/src/feedback_redaction_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackRedactionController', () {
    test(' default is unredacted', () {
      final controller = FeedbackRedactionController();
      expect(controller.isRedacted, false);
    });

    test(' change redaction from unredacted to redacted', () {
      final controller = FeedbackRedactionController();

      var listenerWasCalled = false;
      controller.addListener(() {
        listenerWasCalled = true;
      });

      controller.redact();
      expect(controller.isRedacted, true);
      expect(listenerWasCalled, true);
    });

    test(' change redaction from redacted to unredacted', () {
      final controller = FeedbackRedactionController();
      controller.redact();

      var listenerWasCalled = false;
      controller.addListener(() {
        listenerWasCalled = true;
      });

      controller.unredact();
      expect(controller.isRedacted, false);
      expect(listenerWasCalled, true);
    });
  });
}
