import 'package:cafein/controllers/power_share/ask_controller.dart';
import 'package:get/get.dart';

class AskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AskController>(() => AskController());
  }
}
