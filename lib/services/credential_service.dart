import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:dio/dio.dart';

class CredentialService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> addCredential({
    required int type,
    required String description,
  }) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/credential/store',
      data: {
        'type': type,
        'description': description,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> updateCredential({
    required int id,
    required int type,
    required String description,
    int hide = 0,
  }) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/credential/update/$id',
      data: {
        'type': type,
        'description': description,
        'hide': hide,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> getCredentials(int userId) async {
    final token = await Token.getToken();
    return await _apiClient.dio.get(
      '/credential/indexUser/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> deleteCredential(int id) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/credential/destroy/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> pinCredential(int id, String type) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/credential/pin',
      data: {
        'id': id,
        'type': type,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
