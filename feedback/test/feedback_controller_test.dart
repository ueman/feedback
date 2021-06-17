import 'package:feedback/src/feedback_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackController', () {
    test(' default is hidden', () {
      final controller = FeedbackController();
      expect(controller.isVisible, false);
    });

    test(' change visibility from hidden to visible', () {
      final controller = FeedbackController();
      var listenerWasCalled = false;
      controller.addListener(() {
        listenerWasCalled = true;
      });

      controller.show((_) {});
      expect(controller.isVisible, true);
      expect(listenerWasCalled, true);
    });

    test(' change visibility from visible to hidden', () {
      final controller = FeedbackController();
      controller.show((_) {});
      var listenerWasCalled = false;
      controller.addListener(() {
        listenerWasCalled = true;
      });

      controller.hide();
      expect(controller.isVisible, false);
      expect(listenerWasCalled, true);
    });
  });
}
