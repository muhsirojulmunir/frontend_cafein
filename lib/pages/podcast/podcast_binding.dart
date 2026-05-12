import 'package:cafein/controllers/podcast/podcast_controller.dart';
import 'package:get/get.dart';

class PodcastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodcastController>(() => PodcastController());
  }
}
