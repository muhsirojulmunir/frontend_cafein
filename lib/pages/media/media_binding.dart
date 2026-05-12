import 'package:cafein/controllers/media/media_controller.dart';
import 'package:get/get.dart';

class MediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaController>(() => MediaController());
  }
}
