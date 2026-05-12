import 'package:cafein/models/post.dart';
import 'package:cafein/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareController extends GetxController {
  final PostService _postService = PostService();

  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  int _currentPage = 1;
  int _lastPage = 1;
  bool get hasMore => _currentPage < _lastPage;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        hasMore) {
      loadMorePosts();
    }
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      _currentPage = 1;

      final result = await _postService.fetchFeed(page: 1);
      final List<Post> fetchedPosts = result['posts'];
      _lastPage = result['lastPage'];
      _currentPage = result['currentPage'];
      posts.assignAll(fetchedPosts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore.value || !hasMore) return;
    try {
      isLoadingMore.value = true;
      final nextPage = _currentPage + 1;
      final result = await _postService.fetchFeed(page: nextPage);
      final List<Post> fetchedPosts = result['posts'];
      _lastPage = result['lastPage'];
      _currentPage = result['currentPage'];
      posts.addAll(fetchedPosts);
    } catch (_) {
      // Silent fail on pagination — user can pull-to-refresh
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  /// Optimistic upvote/downvote
  Future<void> vote(int index, int voteStatus) async {
    final post = posts[index];
    final oldVoteStatus = post.voteStatus;
    final oldUpvote = post.upvote;
    final oldDownvote = post.downvote;

    // Optimistic update
    if (post.voteStatus == voteStatus) {
      // Toggle off — same vote again
      post.voteStatus = null;
      if (voteStatus == 1) post.upvote--;
      if (voteStatus == 2) post.downvote--;
    } else {
      // Undo old vote
      if (post.voteStatus == 1) post.upvote--;
      if (post.voteStatus == 2) post.downvote--;
      // Apply new vote
      post.voteStatus = voteStatus;
      if (voteStatus == 1) post.upvote++;
      if (voteStatus == 2) post.downvote++;
    }
    posts.refresh();

    try {
      await _postService.vote(postId: post.id, voteStatus: voteStatus);
    } catch (_) {
      // Revert on failure
      post.voteStatus = oldVoteStatus;
      post.upvote = oldUpvote;
      post.downvote = oldDownvote;
      posts.refresh();
      Get.snackbar('Error', 'Gagal memberikan vote',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Follow / Unfollow user
  Future<void> toggleFollow(int index) async {
    final post = posts[index];
    final oldStatus = post.followStatus;
    final newStatus = (post.followStatus == 1) ? 3 : 1; // 1=follow, 3=unfollow

    // Optimistic update
    post.followStatus = newStatus;
    posts.refresh();

    try {
      await _postService.followUser(
        userId: post.idUser,
        followStatus: newStatus,
      );
    } catch (_) {
      // Revert on failure
      post.followStatus = oldStatus;
      posts.refresh();
      Get.snackbar('Error', 'Gagal mengubah status follow',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Delete post
  Future<void> deletePost(int postId) async {
    try {
      final success = await _postService.deletePost(postId);
      if (success) {
        posts.removeWhere((p) => p.id == postId);
        posts.refresh();
        Get.snackbar('Berhasil', 'Postingan dihapus',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Get image URL for a post
  String getImageUrl(String imageName) {
    return _postService.getImageUrl(imageName);
  }

  /// Get auth headers for image loading
  Future<Map<String, String>> getImageHeaders() async {
    return _postService.getImageHeaders();
  }

  Future<void> retry() async {
    await fetchPosts();
  }
}
