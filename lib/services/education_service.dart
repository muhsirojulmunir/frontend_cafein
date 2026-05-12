import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:dio/dio.dart';

class EducationService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> addEducation({
    required String school,
    required String primaryMajor,
    String? secondaryMajor,
    required int strata,
    String? degreeType,
    required int graduationYear,
  }) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/education/store',
      data: {
        'school': school,
        'primary_major': primaryMajor,
        if (secondaryMajor != null && secondaryMajor.isNotEmpty) 'secondary_major': secondaryMajor,
        'strata': strata,
        if (degreeType != null && degreeType.isNotEmpty) 'degree_type': degreeType,
        'graduation_year': graduationYear,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> updateEducation({
    required int id,
    required String school,
    required String primaryMajor,
    String? secondaryMajor,
    required int strata,
    String? degreeType,
    required int graduationYear,
  }) async {
    final token = await Token.getToken();
    return await _apiClient.dio.post(
      '/education/update/$id',
      data: {
        'school': school,
        'primary_major': primaryMajor,
        if (secondaryMajor != null && secondaryMajor.isNotEmpty) 'secondary_major': secondaryMajor,
        'strata': strata,
        if (degreeType != null && degreeType.isNotEmpty) 'degree_type': degreeType,
        'graduation_year': graduationYear,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> getEducations() async {
    final token = await Token.getToken();
    return await _apiClient.dio.get(
      '/education/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> deleteEducation(int id) async {
    final token = await Token.getToken();
    return await _apiClient.dio.get(
      '/education/userDestroy/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
