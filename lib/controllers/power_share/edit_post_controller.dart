import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/models/post.dart';
import 'package:cafein/services/cafe_room_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafein/controllers/power_share/user_profile_controller.dart';

class EditPostController extends GetxController {
  final Post post;
  EditPostController(this.post);

  final PostService _postService = PostService();
  final CafeRoomService _cafeRoomService = CafeRoomService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  PlatformFile? selectedFile;
  PlatformFile? selectedImage;
  
  final RxList<CafeRoom> availableRuang = <CafeRoom>[].obs;
  CafeRoom? selectedRuang;
  
  final RxMap<String, String> imageHeaders = <String, String>{}.obs;
  
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingRuang = false.obs;

  @override
  void onInit() {
    super.onInit();
    titleController.text = post.title ?? '';
    descriptionController.text = post.description;
    fetchCafeRooms();
    fetchImageHeaders();
  }

  Future<void> fetchImageHeaders() async {
    try {
      final headers = await _postService.getImageHeaders();
      imageHeaders.assignAll(headers);
      update(); // Trigger UI rebuild since we removed Obx in the UI
    } catch (_) {
      // Silent fail
    }
  }

  List<String> get ruangNames => availableRuang.map((room) => room.name).toList();

  Future<void> fetchCafeRooms() async {
    try {
      isLoadingRuang.value = true;
      final rooms = await _cafeRoomService.fetchCafeRooms();
      availableRuang.assignAll(rooms);
      
      // Try to match current post's knowField if it exists
      if (post.idKnowField != null) {
        final currentKnowFieldId = int.tryParse(post.idKnowField!);
        selectedRuang = availableRuang.firstWhereOrNull((room) => room.id == currentKnowFieldId);
      }
    } catch (_) {
      // Silent fail
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

  Future<void> updatePost() async {
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Deskripsi tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSubmitting.value = true;

      final success = await _postService.updatePost(
        postId: post.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        image: selectedImage,
        doc: selectedFile,
        codeIlmu: selectedRuang?.id.toString(),
      );

      if (success) {
        // Refresh profile if it exists
        if (Get.isRegistered<UserProfileController>(tag: post.idUser.toString())) {
          Get.find<UserProfileController>(tag: post.idUser.toString()).refreshData();
        }
        
        Get.back();

        Get.snackbar(
          'Berhasil',
          'Berhasil Mengubah Postingan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  String getImageUrl(String imageName) {
    return _postService.getImageUrl(imageName);
  }
}
