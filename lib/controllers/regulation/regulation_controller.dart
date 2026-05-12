import 'package:cafein/models/aturan_model.dart';
import 'package:cafein/services/aturan_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RegulationController extends GetxController {
  final AturanService _service = AturanService();

  RxBool isActiveFilter = false.obs;
  RxBool isLoading = true.obs;
  RxString errorMsg = ''.obs;
  RxInt selectedTabIndex = 0.obs;
  RxString searchQuery = ''.obs;
  RxString filterJenis = ''.obs;
  RxString filterKategori = ''.obs;
  RxSet<int> bookmarkedIds = <int>{}.obs;
  RxSet<String> subBookmarkedKeys = <String>{}.obs;

  var menuItems = <AturanModel>[].obs;
  var jenisList = <JenisModel>[].obs;
  var kategoriList = <KategoriModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      errorMsg('');

      final results = await Future.wait([
        _service.getAturan(),
        _service.getJenis(),
        _service.getKategori(),
      ]);

      menuItems.assignAll(results[0] as List<AturanModel>);
      jenisList.assignAll(results[1] as List<JenisModel>);
      kategoriList.assignAll(results[2] as List<KategoriModel>);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.contains('500')) {
        errorMsg('Terjadi kesalahan pada server.\nSilakan coba lagi nanti.');
      } else if (msg.contains('Network') || msg.contains('Connection')) {
        errorMsg('Koneksi gagal.\nPeriksa jaringan internet Anda.');
      } else {
        errorMsg(msg);
      }
    } finally {
      isLoading(false);
    }
  }

  /// Items filtered by search query, jenis, kategori, and tab (semua / bookmark)
  List<AturanModel> get filteredMenuItems {
    List<AturanModel> items = menuItems;

    // Filter by search
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      items = items.where((item) {
        final title = item.shortDesc.toLowerCase();
        final jenis = item.namaJenis.toLowerCase();
        final nomor = (item.nomor ?? '').toLowerCase();
        final kategori = item.namaKategori.join(', ').toLowerCase();
        return title.contains(q) ||
            jenis.contains(q) ||
            nomor.contains(q) ||
            kategori.contains(q);
      }).toList();
    }

    // Filter by jenis
    if (isActiveFilter.value && filterJenis.value.isNotEmpty) {
      items = items
          .where((item) => item.namaJenis == filterJenis.value)
          .toList();
    }

    // Filter by kategori
    if (isActiveFilter.value && filterKategori.value.isNotEmpty) {
      items = items
          .where((item) => item.namaKategori.contains(filterKategori.value))
          .toList();
    }

    // Filter by bookmark tab
    if (selectedTabIndex.value == 1) {
      items = items.where((item) {
        // Check if main regulation is bookmarked
        if (bookmarkedIds.contains(item.id)) return true;

        // Check if any sub-item is bookmarked
        // Format of subBookmarkedKeys: "mainId_parent_index" or "mainId_child_index"
        final String prefix = "${item.id}_";
        return subBookmarkedKeys.any((key) => key.startsWith(prefix));
      }).toList();
    }

    return items;
  }

  /// Get the original index of an item in menuItems
  int getOriginalIndex(AturanModel item) {
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

  void toggleSubBookmark(String key) {
    if (subBookmarkedKeys.contains(key)) {
      subBookmarkedKeys.remove(key);
    } else {
      subBookmarkedKeys.add(key);
    }
    update();
  }

  bool isSubBookmarked(String key) {
    return subBookmarkedKeys.contains(key);
  }

  void applyFilter({String? jenis, String? kategori}) {
    if (jenis != null) filterJenis.value = jenis;
    if (kategori != null) filterKategori.value = kategori;
    isActiveFilter.value = true;
    update();
  }

  void resetFilter() {
    filterJenis.value = '';
    filterKategori.value = '';
    isActiveFilter.value = false;
    update();
  }

  void searchRegulations(String query) {
    searchQuery.value = query;
    update();
  }

  void switchTab(int index) {
    selectedTabIndex.value = index;
    update();
  }

  /// Download a regulation PDF via external browser
  Future<void> downloadPdf(int id) async {
    try {
      final url = await _service.getDownloadUrl(id);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka link download',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  /// View a regulation PDF via external browser
  Future<void> viewPdf(int id) async {
    try {
      final url = await _service.getViewUrl(id);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka dokumen',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  /// Download a sub-regulation PDF via external browser (by filename)
  Future<void> downloadSubPdf(String filename) async {
    try {
      final url = await _service.getDownloadSubUrl(filename);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendownload: $e');
    }
  }

  /// View a sub-regulation PDF via external browser (by filename)
  Future<void> viewSubPdf(String filename) async {
    try {
      final url = await _service.getViewSubUrl(filename);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuka file: $e');
    }
  }
}
