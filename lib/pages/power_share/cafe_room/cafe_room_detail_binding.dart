import 'package:cafein/controllers/power_share/cafe_room_detail_controller.dart';
import 'package:get/get.dart';

class CafeRoomDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CafeRoomDetailController>(() => CafeRoomDetailController());
  }
}
