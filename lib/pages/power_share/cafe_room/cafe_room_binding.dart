import 'package:cafein/controllers/power_share/cafe_room_controller.dart';
import 'package:get/get.dart';

class CafeRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CafeRoomController>(() => CafeRoomController());
  }
}
