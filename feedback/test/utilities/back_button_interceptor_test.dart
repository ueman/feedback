import 'package:feedback/src/utilities/back_button_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$BackButtonInterceptor', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final backButtonInterceptor = BackButtonInterceptor();

    var called = false;

    backButtonInterceptor.add(() {
      called = true;
      return false;
    });

    await backButtonInterceptor.didPopRoute();

    expect(called, isTrue);
  });
}
