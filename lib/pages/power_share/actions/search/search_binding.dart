import 'package:cafein/controllers/power_share/search_share_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchShareController>(() => SearchShareController());
  }
}
