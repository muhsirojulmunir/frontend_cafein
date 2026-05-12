import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:cafein/controllers/power_share/user_profile_controller.dart';
import 'package:cafein/services/local/token.dart';
import 'package:get/get.dart' hide FormData;

class NavTabController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt tabIndex = 0.obs;
  RxInt currentUserId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final idStr = await Token.getUserId();
    if (idStr != null) {
      currentUserId.value = int.tryParse(idStr) ?? 0;
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;

    // Auto-refresh profil data ketika pindah ke tab Profil
    if (index == 3 && currentUserId.value != 0) {
      _refreshProfileData();
    }
    // Auto-refresh following feed ketika pindah ke tab Mengikuti
    if (index == 1) {
      _refreshFollowingFeed();
    }
  }

  void _refreshProfileData() {
    try {
      final tag = currentUserId.value.toString();
      if (Get.isRegistered<UserProfileController>(tag: tag)) {
        Get.find<UserProfileController>(tag: tag).refreshData();
      }
    } catch (_) {}
  }

  void _refreshFollowingFeed() {
    try {
      if (Get.isRegistered<FollowController>()) {
        Get.find<FollowController>().refreshPosts();
      }
    } catch (_) {}
  }

  String titleAppBar({required int index}) {
    if (index == 0) {
      return 'Beranda';
    } else if (index == 1) {
      return 'Mengikuti';
    } else if (index == 2) {
      return 'Cafe Room';
    } else {
      return 'Profil';
    }
  }
}
