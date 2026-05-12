import 'package:cafein/models/notification.dart';
import 'package:cafein/services/notification_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/routes/page_names.dart';
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

    // Navigate based on type
    if (item.postId != null && item.postId! > 0) {
      // Fetch post detail lalu navigasi ke PostDetailPage
      final post = await _postService.fetchPostById(item.postId!);
      if (post != null) {
        Get.toNamed(PageName.postDetail, arguments: post);
      } else {
        Get.snackbar('Error', 'Postingan tidak ditemukan', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
