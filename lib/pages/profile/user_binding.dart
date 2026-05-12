import 'package:cafein/controllers/profile/user_controller.dart';
import 'package:get/get.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
