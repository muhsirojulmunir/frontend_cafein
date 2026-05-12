import 'package:cafein/models/aturan_model.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class AturanService {
  final ApiClient _apiClient = ApiClient();

  Future<List<AturanModel>> getAturan() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_REGULASI);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((item) =>
                AturanModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Failed to load data regulasi');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<JenisModel>> getJenis() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_JENIS);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : response.data['data'] ?? [];
        return data
            .map((item) =>
                JenisModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Failed to load jenis aturan');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<KategoriModel>> getKategori() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_KATEGORI);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : response.data['data'] ?? [];
        return data
            .map((item) =>
                KategoriModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Failed to load kategori aturan');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Build the download URL for a regulation PDF (public route, no token needed)
  Future<String> getDownloadUrl(int id) async {
    return '${AppConstants.BASE_URL}${AppConstants.API_DOWNLOAD_REGULASI}/$id';
  }

  /// Build the view URL for a regulation PDF (public route, no token needed)
  Future<String> getViewUrl(int id) async {
    return '${AppConstants.BASE_URL}${AppConstants.API_VIEW_REGULASI}/$id';
  }

  /// Build the download URL for a sub-regulation PDF by filename
  Future<String> getDownloadSubUrl(String filename) async {
    return '${AppConstants.BASE_URL}/cafein/downloadFileRegulasi/$filename';
  }

  /// Build the view URL for a sub-regulation PDF by filename
  Future<String> getViewSubUrl(String filename) async {
    return '${AppConstants.BASE_URL}/cafein/viewFileRegulasi/$filename';
  }
}

