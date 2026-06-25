import 'package:cafein/models/media_model.dart';
import 'package:cafein/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaController extends GetxController {
  final MediaService _service = MediaService();

  RxBool isActiveFilter = false.obs;
  RxBool isLoading = true.obs;
  RxString errorMsg = ''.obs;
  RxInt selectedTabIndex = 0.obs;
  RxString searchQuery = ''.obs;
  RxString filterVolume = ''.obs;
  RxString filterYear = ''.obs;
  RxSet<int> bookmarkedIds = <int>{}.obs;

  var menuItems = <MediaModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedia();
  }

  Future<void> fetchMedia() async {
    try {
      isLoading(true);
      errorMsg('');
      final result = await _service.getMedia();
      menuItems.assignAll(result);
    } catch (e) {
      errorMsg(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }

  /// Items filtered by search query, volume, year, and tab
  List<MediaModel> get filteredMenuItems {
    List<MediaModel> items = menuItems;

    // Filter by search (title / volume / year)
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      items = items.where((item) {
        final title = item.namaMedia.toLowerCase();
        final volume = (item.noVolume ?? '').toLowerCase();
        final year = (item.tahun ?? '').toLowerCase();
        final headline = (item.headline ?? '').toLowerCase();
        return title.contains(q) ||
            volume.contains(q) ||
            year.contains(q) ||
            headline.contains(q);
      }).toList();
    }

    // Filter by volume
    if (isActiveFilter.value && filterVolume.value.isNotEmpty) {
      items = items
          .where((item) => item.noVolume == filterVolume.value)
          .toList();
    }

    // Filter by year
    if (isActiveFilter.value && filterYear.value.isNotEmpty) {
      items = items.where((item) => item.tahun == filterYear.value).toList();
    }

    // Filter by bookmark tab
    if (selectedTabIndex.value == 1) {
      items = items.where((item) => bookmarkedIds.contains(item.id)).toList();
    }

    return items;
  }

  /// Get the original index of an item in menuItems
  int getOriginalIndex(MediaModel item) {
    return menuItems.indexOf(item);
  }

  void toggleBookmark(int id) {
    if (bookmarkedIds.contains(id)) {
      bookmarkedIds.remove(id);
    } else {
      bookmarkedIds.add(id);
    }
    update();
  }

  bool isBookmarked(int id) {
    return bookmarkedIds.contains(id);
  }

  void applyFilter({String? volume, String? year}) {
    if (volume != null) filterVolume.value = volume;
    if (year != null) filterYear.value = year;
    isActiveFilter.value = true;
    update();
  }

  void resetFilter() {
    filterVolume.value = '';
    filterYear.value = '';
    isActiveFilter.value = false;
    update();
  }

  void searchMedia(String query) {
    searchQuery.value = query;
    update();
  }

  void switchTab(int index) {
    selectedTabIndex.value = index;
    update();
  }

  /// Download media attachment via external browser
  Future<void> downloadMedia(int id) async {
    try {
      final url = await _service.getDownloadUrl(id);
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mendownload file: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// View media attachment (PDF) via external browser
  Future<void> viewMedia(int id) async {
    try {
      final url = await _service.getViewUrl(id);
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuka file: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

}
