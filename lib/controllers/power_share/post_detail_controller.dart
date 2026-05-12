import 'package:cafein/models/comment.dart';
import 'package:cafein/services/comment_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailController extends GetxController {
  final CommentService _commentService = CommentService();
  final PostService _postService = PostService();

  late final Map<String, dynamic> post;
  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool isLoadingComments = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLiked = false.obs;
  final RxInt likeCount = 0.obs;
  final RxInt commentCount = 0.obs;

  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode commentFocusNode = FocusNode();

  final Rx<Comment?> replyingTo = Rx<Comment?>(null);

  @override
  void onInit() {
    super.onInit();
    post = Get.arguments as Map<String, dynamic>;
    likeCount.value = _safeInt(post['upvote']);
    isLiked.value = post['vote_status'] == 1;
    fetchComments();
  }

  @override
  void onClose() {
    commentController.dispose();
    scrollController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  int get postId => _safeInt(post['id']);

  void setReplyTo(Comment comment) {
    replyingTo.value = comment;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    replyingTo.value = null;
  }

  Future<void> fetchComments() async {
    try {
      isLoadingComments.value = true;
      final result = await _commentService.fetchComments(postId);
      // The API returns the original post as the first item, with actual
      // comments nested inside its repliedData. Extract only the real
      // comments so the post description is not duplicated.
      if (result.isNotEmpty && result.first.repliedData.isNotEmpty) {
        final actualComments = result.first.repliedData;
        comments.assignAll(actualComments);
        commentCount.value = _countNested(actualComments);
      } else if (result.isNotEmpty && result.first.repliedData.isEmpty) {
        // Post exists but has no comments
        comments.clear();
        commentCount.value = 0;
      } else {
        comments.assignAll(result);
        commentCount.value = _countNested(result);
      }
    } catch (_) {
      comments.clear();
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> submitComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final targetId = replyingTo.value?.id ?? postId;

    try {
      isSubmitting.value = true;
      final success = await _commentService.addComment(
        postId: targetId,
        title: 'Komentar',
        description: text,
      );
      if (success) {
        commentController.clear();
        replyingTo.value = null;
        await fetchComments();
        // Scroll to bottom to show new comment
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Gagal mengirim komentar',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> toggleLike() async {
    final wasLiked = isLiked.value;
    final oldCount = likeCount.value;

    // Optimistic
    isLiked.value = !wasLiked;
    likeCount.value = wasLiked ? (oldCount - 1).clamp(0, 999999) : oldCount + 1;

    try {
      await _postService.vote(postId: postId, voteStatus: wasLiked ? 2 : 1);
    } catch (_) {
      isLiked.value = wasLiked;
      likeCount.value = oldCount;
      Get.snackbar(
        'Error',
        'Gagal memberikan like',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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

  String timeAgoFromDateTime(DateTime? dt) {
    if (dt == null) return '';
    return timeAgo(dt.toIso8601String());
  }

  int _countNested(List<Comment> list) {
    int count = list.length;
    for (final c in list) {
      count += _countNested(c.repliedData);
    }
    return count;
  }

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
