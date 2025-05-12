import 'package:get/get.dart';
import 'package:to_do_list/features/splash_screen/splash_screen_controller.dart';


class SplashScreenBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SplashScreenController());
  }
}
