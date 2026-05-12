import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:get/get.dart';

class FollowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowController>(() => FollowController());
  }
}
