import 'package:cafein/controllers/pelatihan/pelatihan_controller.dart';
import 'package:get/get.dart';

class PelatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelatihanController>(() => PelatihanController());
  }
}
