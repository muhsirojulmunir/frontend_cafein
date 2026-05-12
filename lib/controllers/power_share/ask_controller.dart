import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/services/cafe_room_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/controllers/power_share/share_controller.dart';
import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskController extends GetxController {
  final PostService _postService = PostService();

  final List<Map<String, dynamic>> aturan = [
    {'title': 'Buat pertanyaan yang baik dan benar'},
    {'title': 'Pastikan pertanyaan Anda belum pernah diajukan'},
    {'title': 'Pastikan pertanyaan Anda singkat padat, dan lugas'},
    {'title': 'Perikas kembali tata bahasa dan ejaan anda'},
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  PlatformFile? selectedFile;
  PlatformFile? selectedImage;
  
  final CafeRoomService _cafeRoomService = CafeRoomService();
  final RxList<CafeRoom> availableRuang = <CafeRoom>[].obs;
  CafeRoom? selectedRuang;
  
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingRuang = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if a room was passed as an argument (e.g. from Cafe Room Detail)
    if (Get.arguments is CafeRoom) {
      selectedRuang = Get.arguments as CafeRoom;
    }
    fetchCafeRooms();
  }

  List<String> get ruangNames => availableRuang.map((room) => room.name).toList();

  Future<void> fetchCafeRooms() async {
    try {
      isLoadingRuang.value = true;
      final rooms = await _cafeRoomService.fetchCafeRooms();
      availableRuang.assignAll(rooms);
    } catch (_) {
      // Handle error or silent fail
    } finally {
      isLoadingRuang.value = false;
      update();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      selectedImage = result.files.first;
      update();
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null) {
      selectedFile = result.files.first;
      update();
    }
  }

  void updateRuang(String? name) {
    if (name == null) {
      selectedRuang = null;
    } else {
      selectedRuang = availableRuang.firstWhereOrNull((room) => room.name == name);
    }
    update();
  }

  void removeFile() {
    selectedFile = null;
    update();
  }

  void removeImage() {
    selectedImage = null;
    update();
  }

  Future<void> submitPost() async {
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Deskripsi tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSubmitting.value = true;

      final success = await _postService.createPost(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        image: selectedImage,
        doc: selectedFile,
        codeIlmu: selectedRuang?.id.toString(),
      );

      if (success) {
        Get.snackbar('Berhasil', 'Posting berhasil dibuat!',
            snackPosition: SnackPosition.BOTTOM);
        // Clear form
        titleController.clear();
        descriptionController.clear();
        selectedFile = null;
        selectedImage = null;
        selectedRuang = null;
        update();

        // Refresh feeds
        if (Get.isRegistered<ShareController>()) {
          Get.find<ShareController>().refreshPosts();
        }
        if (Get.isRegistered<FollowController>()) {
          Get.find<FollowController>().refreshPosts();
        }

        // Redirect to own profile
        final userIdStr = await Token.getUserId();
        if (userIdStr != null) {
          final userId = int.tryParse(userIdStr) ?? 0;
          Get.off(() => UserProfilePage(userId: userId));
        } else {
          Get.back(); // Fallback to feed
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
