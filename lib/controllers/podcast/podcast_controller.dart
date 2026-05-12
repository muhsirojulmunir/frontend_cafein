import 'package:cafein/models/podcast_model.dart';
import 'package:cafein/services/podcast_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PodcastController extends GetxController {
  final PodcastService _service = PodcastService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var podcastList = <PodcastModel>[].obs;
  var filteredPodcastList = <PodcastModel>[].obs;
  var isShowingBookmarks = false.obs;

  // New observables for search and filtering
  var searchQuery = ''.obs;
  var selectedCategories = <String>[].obs; // Empty means show all
  var categories = <String>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    fetchPodcasts();
    super.onInit();
  }

  void fetchPodcasts() async {
    try {
      isLoading(true);
      errorMessage('');
      var result = await _service.getPodcast();
      podcastList.assignAll(result);

      // Extract unique categories
      var uniqueCategories =
          result.map((p) => p.kategori).where((k) => k.isNotEmpty).toSet().toList();
      uniqueCategories.sort();
      categories.assignAll(uniqueCategories);

      _applyFilters();
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void searchPodcast(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _applyFilters();
  }

  void clearFilters() {
    selectedCategories.clear();
    _applyFilters();
  }

  void toggleBookmark(PodcastModel podcast) {
    podcast.isBookmarked = !podcast.isBookmarked;
    podcastList.refresh();
    _applyFilters();
  }

  void toggleFilterBookmarks() {
    isShowingBookmarks.value = !isShowingBookmarks.value;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();
    
    var list = podcastList.where((p) {
      final matchesQuery =
          query.isEmpty ||
          p.judul.toLowerCase().contains(query) ||
          p.kategori.toLowerCase().contains(query);
      
      final matchesCategory = selectedCategories.isEmpty || 
                             selectedCategories.contains(p.kategori);
      
      final matchesBookmark = !isShowingBookmarks.value || p.isBookmarked;
      
      return matchesQuery && matchesCategory && matchesBookmark;
    }).toList();

    filteredPodcastList.assignAll(list);
  }
}
