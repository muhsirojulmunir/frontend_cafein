import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/models/comment.dart';
import 'package:cafein/services/cafe_room_service.dart';
import 'package:cafein/services/comment_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/controllers/power_share/cafe_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CafeRoomDetailController extends GetxController {
  final CafeRoomService _cafeRoomService = CafeRoomService();
  final PostService _postService = PostService();
  final CommentService _commentService = CommentService();

  late final CafeRoom room;
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFollowing = false.obs;
  final RxBool isFollowLoading = false.obs;

  // Comment state per post (keyed by post id)
  final RxMap<int, bool> expandedComments = <int, bool>{}.obs;
  final RxMap<int, List<Comment>> postComments = <int, List<Comment>>{}.obs;
  final RxMap<int, bool> isLoadingComments = <int, bool>{}.obs;
  final RxMap<int, int> commentCounts = <int, int>{}.obs;

  // Like state per post
  final RxMap<int, bool> isLiked = <int, bool>{}.obs;
  final RxMap<int, int> likeCounts = <int, int>{}.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    room = Get.arguments as CafeRoom;
    _loadData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      fetchRoomPosts(),
      fetchFollowStatus(),
    ]);
  }

  Future<void> fetchRoomPosts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await _cafeRoomService.fetchRoomPosts(room.codeIlmu);
      posts.assignAll(result);

      // Initialize like states from post data
      for (final post in result) {
        final postId = _safeInt(post['id']);
        if (postId > 0) {
          likeCounts[postId] = _safeInt(post['upvote']);
          isLiked[postId] = post['vote_status'] == 1;
          // Initialize comment counts (will be fetched on demand)
          commentCounts[postId] = 0;
        }
      }

      // Fetch comment counts in background
      _fetchAllCommentCounts();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAllCommentCounts() async {
    for (final post in posts) {
      final postId = _safeInt(post['id']);
      if (postId > 0) {
        try {
          final count = await _commentService.fetchCommentCount(postId);
          commentCounts[postId] = count;
        } catch (_) {}
      }
    }
  }

  Future<void> fetchFollowStatus() async {
    try {
      final result = await _cafeRoomService.getRoomFollowStatus(room.codeIlmu);
      final status = result['status_follow'];
      isFollowing.value = (status == 1);
    } catch (_) {
      isFollowing.value = false;
    }
  }

  Future<void> toggleFollow() async {
    if (isFollowLoading.value) return;
    try {
      isFollowLoading.value = true;
      final oldStatus = isFollowing.value;
      // Optimistic update
      isFollowing.value = !oldStatus;

      final success = await _cafeRoomService.toggleRoomFollow(room.codeIlmu);
      if (!success) {
        isFollowing.value = oldStatus;
        Get.snackbar('Error', 'Gagal mengubah status ikuti',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        // Automatically refresh root cafe room list
        try {
          Get.find<CafeRoomController>().refreshData();
        } catch (_) {}
      }
    } catch (_) {
      isFollowing.value = !isFollowing.value;
      Get.snackbar('Error', 'Gagal mengubah status ikuti',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isFollowLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  // ─────────────────────────────── Like ───────────────────────────────

  /// Toggle like on a post (optimistic)
  Future<void> toggleLike(int postIndex) async {
    if (postIndex < 0 || postIndex >= posts.length) return;
    final post = posts[postIndex];
    final postId = _safeInt(post['id']);
    if (postId <= 0) return;

    final wasLiked = isLiked[postId] ?? false;
    final oldCount = likeCounts[postId] ?? 0;

    // Optimistic update
    isLiked[postId] = !wasLiked;
    likeCounts[postId] = wasLiked ? (oldCount - 1).clamp(0, 999999) : oldCount + 1;

    try {
      // vote_status 1 = upvote, 2 = downvote
      // If already liked, send vote_status=2 to "undo" (backend uses updateOrCreate)
      await _postService.vote(
        postId: postId,
        voteStatus: wasLiked ? 2 : 1,
      );
    } catch (_) {
      // Revert on failure
      isLiked[postId] = wasLiked;
      likeCounts[postId] = oldCount;
      Get.snackbar('Error', 'Gagal memberikan like',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ─────────────────────────── Comments ───────────────────────────────

  /// Toggle comments visibility for a post
  Future<void> toggleComments(int postId) async {
    final isExpanded = expandedComments[postId] ?? false;

    if (isExpanded) {
      // Hide comments
      expandedComments[postId] = false;
    } else {
      // Show comments — fetch if not cached
      expandedComments[postId] = true;
      if (postComments[postId] == null || postComments[postId]!.isEmpty) {
        await fetchComments(postId);
      }
    }
  }

  /// Fetch comments for a specific post
  Future<void> fetchComments(int postId) async {
    try {
      isLoadingComments[postId] = true;
      final result = await _commentService.fetchComments(postId);
      // The API returns the original post as the first item, with actual
      // comments nested inside its repliedData. Extract only the real
      // comments so the post description is not duplicated.
      List<Comment> actualComments;
      if (result.isNotEmpty && result.first.repliedData.isNotEmpty) {
        actualComments = result.first.repliedData;
      } else if (result.isNotEmpty && result.first.repliedData.isEmpty) {
        actualComments = [];
      } else {
        actualComments = result;
      }
      postComments[postId] = actualComments;
      commentCounts[postId] = _countNested(actualComments);
    } catch (_) {
      postComments[postId] = [];
    } finally {
      isLoadingComments[postId] = false;
    }
  }

  /// Submit a new comment
  Future<bool> submitComment(int postId, String description) async {
    if (description.trim().isEmpty) return false;

    try {
      final success = await _commentService.addComment(
        postId: postId,
        title: 'Komentar',
        description: description.trim(),
      );
      if (success) {
        // Refresh comments to show the new one
        await fetchComments(postId);
        return true;
      }
      return false;
    } catch (_) {
      Get.snackbar('Error', 'Gagal mengirim komentar',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  int _countNested(List<Comment> comments) {
    int count = comments.length;
    for (final c in comments) {
      count += _countNested(c.repliedData);
    }
    return count;
  }

  // ─────────────────────────── Vote (legacy) ─────────────────────────

  /// Vote on a post (legacy method kept for compatibility)
  Future<void> vote(int postIndex, int voteStatus) async {
    if (postIndex < 0 || postIndex >= posts.length) return;
    final post = posts[postIndex];
    final postId = post['id'];
    if (postId == null) return;

    try {
      await _postService.vote(
          postId: int.parse(postId.toString()), voteStatus: voteStatus);
      // Refresh to get updated data
      await fetchRoomPosts();
    } catch (_) {
      Get.snackbar('Error', 'Gagal memberikan vote',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ─────────────────────────── Helpers ────────────────────────────────

  /// Get image URL
  String getImageUrl(String imageName) {
    return _cafeRoomService.getImageUrl(imageName);
  }

  /// Get auth headers for image loading
  Future<Map<String, String>> getImageHeaders() async {
    return _cafeRoomService.getImageHeaders();
  }

  String timeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final timestamp = DateTime.tryParse(dateStr);
    if (timestamp == null) return '';
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()} tahun lalu';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()} bulan lalu';
    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()} minggu lalu';
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
