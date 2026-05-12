import 'package:cafein/models/user_model.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/services/user_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var userModel = Rxn<UserModel>();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    try {
      isLoading(true);
      errorMessage('');
      String? userId = await Token.getUserId();
      if (userId != null) {
        var result = await _userService.getProfile(userId);
        userModel.value = result;
      } else {
        errorMessage('User ID tidak ditemukan');
      }
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }
}
