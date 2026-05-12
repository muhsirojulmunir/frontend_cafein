import 'package:cafein/routes/page_names.dart';
import 'package:cafein/services/local/first_install.dart';
import 'package:cafein/services/local/token.dart';
import 'package:get/get.dart';

class InitialController extends GetxController {
  Future<void> setup() async {
    bool? firstInstall = await FirstInstall.getFirstInstall();
    if (firstInstall == null || firstInstall == true) {
      Get.offAllNamed(PageName.onboarding);
    } else {
      await checkToken();
    }
  }

  Future<void> checkToken() async {
    String? token = await Token.getToken();
    bool? firstInstall = await FirstInstall.getFirstInstall();
    if (token == null) {
      if (firstInstall == true) {
        Get.offAllNamed(PageName.onboarding);
      } else {
        Get.offAllNamed(PageName.login);
      }
    } else {
      Get.offAllNamed(PageName.home); // Masuk ke Dashboard jika token ada
    }
  }

  Future<void> saveAuth({
    required String token,
    required String userId,
    required int level,
  }) async {
    await Token.saveSession(token: token, userId: userId, level: level);
    checkToken();
  }

  Future<void> logout() async {
    Token.clearSession();
    checkToken();
  }
}
