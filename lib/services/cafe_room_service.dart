import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class CafeRoomService {
  final ApiClient _apiClient = ApiClient();

  Future<List<CafeRoom>> fetchCafeRooms({String? query}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (query != null && query.trim().isNotEmpty) {
        queryParams['query'] = query.trim();
      }

      final response = await _apiClient.dio.get(
        AppConstants.API_CAFE_ROOM,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data
            .map((item) =>
                CafeRoom.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Gagal memuat data Cafe Room');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        final message =
            e.response?.data?['message'] ?? 'Gagal memuat data Cafe Room';
        throw Exception(message);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<CafeRoom>> fetchFollowedRooms() async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.API_KNOW_FIELD_SHOW_FOLLOW,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : (response.data['data'] ?? []);
        return data
            .map((item) =>
                CafeRoom.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Gagal memuat ruang yang diikuti');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch posts in a specific room by codeIlmu
  Future<List<Map<String, dynamic>>> fetchRoomPosts(String codeIlmu) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_KNOW_FIELD_SHOW_DETAIL}/$codeIlmu',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        return [];
      } else {
        throw Exception('Gagal memuat postingan ruang');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 500) {
        return []; // no posts yet
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get follow status for a room
  Future<Map<String, dynamic>> getRoomFollowStatus(String codeIlmu) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_KNOW_FIELD_SHOW}/$codeIlmu',
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      return {'status_follow': 2};
    } on DioException catch (_) {
      return {'status_follow': 2};
    }
  }

  /// Toggle follow for a room
  Future<bool> toggleRoomFollow(String codeIlmu) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_KNOW_FIELD_FOLLOW,
        data: {'codeIlmu': codeIlmu},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Gagal mengubah status ikuti: ${e.message}');
    }
  }

  /// Get image headers for authenticated image loading
  Future<Map<String, String>> getImageHeaders() async {
    final token = await Token.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  /// Get the full URL for a post image
  String getImageUrl(String imageName) {
    return '${AppConstants.BASE_URL}${AppConstants.API_POSTING_SHOW_IMAGE}/$imageName';
  }
}
