import 'package:cafein/models/media_model.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class MediaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MediaModel>> getMedia() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_MEDIA);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data
            .map((item) =>
                MediaModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Failed to load data media');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Build the download URL for a media attachment (public route, no token needed)
  Future<String> getDownloadUrl(int id) async {
    return '${AppConstants.BASE_URL}${AppConstants.API_DOWNLOAD_MEDIA}/$id';
  }

  /// Build the view URL for a media attachment (public route, no token needed)
  Future<String> getViewUrl(int id) async {
    return '${AppConstants.BASE_URL}${AppConstants.API_VIEW_MEDIA}/$id';
  }
}
