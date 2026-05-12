import 'package:cafein/models/post.dart';
import 'package:cafein/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchShareController extends GetxController {
  final PostService _postService = PostService();

  final TextEditingController searchController = TextEditingController();
  final RxList<Post> searchResults = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final results = await _postService.searchPosts(query);
      searchResults.value = results;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
  }
}
