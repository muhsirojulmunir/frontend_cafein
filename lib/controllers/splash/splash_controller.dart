import 'package:cafein/controllers/initial/initial_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  final InitialController initialController = Get.find();

  RxString version = ''.obs;

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    setup();
    super.onInit();
  }

  void setup() {
    Future.delayed(const Duration(seconds: 3), () {
      initialController.setup();
    });
  }
}
