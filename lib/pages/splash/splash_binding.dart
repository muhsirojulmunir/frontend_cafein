import 'package:cafein/controllers/initial/initial_controller.dart';
import 'package:cafein/controllers/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<InitialController>(() => InitialController());
  }
}
