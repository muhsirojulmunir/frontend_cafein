import 'package:cafein/models/user_model.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel> getProfile(String userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_PROFILE}/$userId',
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Gagal mengambil data profil');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
