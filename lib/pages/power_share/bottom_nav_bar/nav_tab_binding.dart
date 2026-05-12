import 'package:cafein/controllers/power_share/cafe_room_controller.dart';
import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:cafein/controllers/power_share/nav_tab_controller.dart';
import 'package:cafein/controllers/power_share/share_controller.dart';
import 'package:cafein/controllers/power_share/notification_controller.dart';
import 'package:get/get.dart';

class NavTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavTabController>(() => NavTabController());
    Get.lazyPut<ShareController>(() => ShareController());
    Get.lazyPut<FollowController>(() => FollowController());
    Get.lazyPut<CafeRoomController>(() => CafeRoomController());
    Get.put<NotificationController>(NotificationController());
  }
}
