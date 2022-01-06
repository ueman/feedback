import 'package:feedback/src/utilities/back_button_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$BackButtonInterceptor', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    var called = false;

    BackButtonInterceptor.add(() {
      called = true;
      return false;
    });

    BackButtonInterceptor.instance.didPopRoute();

    expect(called, isTrue);
  });
}
