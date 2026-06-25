import 'package:cafein/models/notification.dart';
import 'package:cafein/services/notification_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();
  final PostService _postService = PostService();

  var notifications = <NotificationItem>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      errorMessage('');

      final result = await _service.fetchNotifications();
      notifications.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void onNotificationTap(NotificationItem item) async {
    // Mark as read
    if (!item.isRead) {
      item.isRead = true;
      _service.markAsRead(item.id);
      notifications.refresh();
    }

    final notifType = item.resolvedType;

    if (notifType == 'follow') {
      // Notifikasi follow → navigasi ke profil user yang mengikuti
      if (item.actorUserId != null && item.actorUserId! > 0) {
        Get.to(() => UserProfilePage(userId: item.actorUserId!));
      } else {
        Get.snackbar('Info', 'Tidak dapat membuka profil pengguna',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
      }
    } else if (notifType == 'like' || notifType == 'comment') {
      // Notifikasi like/comment → navigasi ke detail postingan
      if (item.postId != null && item.postId! > 0) {
        final post = await _postService.fetchPostById(item.postId!);
        if (post != null) {
          Get.toNamed(PageName.postDetail, arguments: post);
        } else {
          Get.snackbar('Error', 'Postingan tidak ditemukan',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }
    } else {
      // Tipe lainnya — coba navigasi ke postingan jika ada postId
      if (item.postId != null && item.postId! > 0) {
        final post = await _postService.fetchPostById(item.postId!);
        if (post != null) {
          Get.toNamed(PageName.postDetail, arguments: post);
        }
      } else if (item.actorUserId != null && item.actorUserId! > 0) {
        Get.to(() => UserProfilePage(userId: item.actorUserId!));
      }
    }
  }
}
