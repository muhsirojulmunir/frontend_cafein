import 'dart:async';
import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/services/cafe_room_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CafeRoomController extends GetxController {
  final CafeRoomService _service = CafeRoomService();

  final RxList<CafeRoom> cafeRooms = <CafeRoom>[].obs;
  final RxList<CafeRoom> followedRooms = <CafeRoom>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchCafeRooms({String? query}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final results = await Future.wait([
        _service.fetchCafeRooms(query: query),
        if (query == null || query.isEmpty)
          _service.fetchFollowedRooms()
        else
          Future.value(<CafeRoom>[]),
      ]);

      cafeRooms.assignAll(results[0]);
      if (query == null || query.isEmpty) {
        followedRooms.assignAll(results[1]);
      } else {
        followedRooms.clear();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchCafeRooms(query: query.isEmpty ? null : query);
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    fetchCafeRooms();
  }

  Future<void> retry() async {
    final query = searchController.text.trim();
    await fetchCafeRooms(query: query.isEmpty ? null : query);
  }

  Future<void> refreshData() async {
    final query = searchController.text.trim();
    await fetchCafeRooms(query: query.isEmpty ? null : query);
  }
}
