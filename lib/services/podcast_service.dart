import 'package:cafein/models/podcast_model.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class PodcastService {
  final ApiClient _apiClient = ApiClient();

  Future<List<PodcastModel>> getPodcast() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_PODCAST);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data
            .map((item) =>
                PodcastModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Failed to load data podcast');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
