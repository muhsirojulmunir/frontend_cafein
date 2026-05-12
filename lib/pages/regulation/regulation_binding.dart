import 'package:cafein/controllers/regulation/regulation_controller.dart';
import 'package:get/get.dart';

class RegulationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegulationController>(() => RegulationController());
  }
}
