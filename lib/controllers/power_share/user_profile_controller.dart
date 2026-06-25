import 'package:cafein/models/post.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/services/credential_service.dart';
import 'package:cafein/services/education_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
  final int userId;
  UserProfileController(this.userId);

  final PostService _postService = PostService();
  final CredentialService _credentialService = CredentialService();
  final EducationService _educationService = EducationService();

  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxList<Post> userPosts = <Post>[].obs;
  final RxList<Post> userAnswers = <Post>[].obs;
  final RxInt selectedTab = 0.obs;
  final RxList<dynamic> credentials = <dynamic>[].obs;
  final RxInt followerCount = 0.obs;
  final RxInt followingCount = 0.obs;

  final RxBool isLoading = true.obs;
  final RxString currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure current user ID is loaded before fetching profile data
    fetchCurrentUserId().then((_) => fetchProfileData());
  }

  Future<void> fetchCurrentUserId() async {
    currentUserId.value = await Token.getUserId() ?? '';
  }

  Future<void> deletePost(int postId) async {
    try {
      final success = await _postService.deletePost(postId);
      if (success) {
        userPosts.removeWhere((post) => post.id == postId);
        userAnswers.removeWhere((post) => post.id == postId);
        Get.snackbar(
          'Sukses',
          'Postingan berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus postingan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteCredential(int credentialId, int type) async {
    try {
      final response = type == 1
          ? await _educationService.deleteEducation(credentialId)
          : await _credentialService.deleteCredential(credentialId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        credentials.removeWhere(
          (c) => c['id'] == credentialId && c['type'] == type,
        );
        Get.snackbar(
          'Sukses',
          'Kredensial berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal menghapus kredensial',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus kredensial: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchProfileData() async {
    if (userId == 0) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;

      // Fetch data in parallel
      final results = await Future.wait([
        _postService.fetchUserProfile(userId),
        _postService.fetchUserPosts(userId),
        _postService.fetchUserFollowers(userId),
        _postService.fetchUserFollowing(userId),
        _postService.fetchUserCredentials(userId),
        _postService.fetchUserAnswers(userId),
      ]);

      userData.assignAll(results[0] as Map<String, dynamic>);
      userPosts.assignAll(results[1] as List<Post>);

      final followers = results[2] as List<dynamic>;
      final followings = results[3] as List<dynamic>;
      followerCount.value = followers.length;
      followingCount.value = followings.length;

      credentials.assignAll(results[4] as List<dynamic>);
      userAnswers.assignAll(results[5] as List<Post>);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchProfileData();
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Foto Profil',
            toolbarColor: const Color(0xFF1B4E6B),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: 'Sesuaikan Foto Profil',
            aspectRatioLockEnabled: true,
            cropStyle: CropStyle.circle,
          ),
        ],
      );

      if (croppedFile == null) return;

      // Check file size (max 2MB)
      final fileBytes = await croppedFile.readAsBytes();
      final sizeInMb = fileBytes.length / (1024 * 1024);
      if (sizeInMb > 2.0) {
        Get.snackbar(
          'Ukuran Terlalu Besar',
          'Mohon maaf, ukuran gambar (setelah dipotong) adalah ${sizeInMb.toStringAsFixed(2)}MB. Maksimal yang diperbolehkan adalah 2MB.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      isLoading.value = true;
      final errorMessage = await _postService.updateProfilePhoto(
        croppedFile.path,
      );

      if (errorMessage == null) {
        Get.snackbar(
          'Sukses',
          'Foto profil berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchProfileData();
      } else {
        Get.snackbar(
          'Gagal',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePin(int id, int type) async {
    try {
      final String sourceType = type == 1 ? 'education' : 'credential';
      final response = await _credentialService.pinCredential(id, sourceType);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh local data to reflect changes
        fetchProfileData();
        Get.snackbar(
          'Sukses',
          'Status pin berhasil diperbarui',
          backgroundColor: Color(0xFF1B4E6B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui pin: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateAccountName(String newName) async {
    try {
      isLoading.value = true;
      final success = await _postService.updateAccountName(newName);
      if (success) {
        Get.snackbar(
          'Sukses',
          'Nama berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchProfileData();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
