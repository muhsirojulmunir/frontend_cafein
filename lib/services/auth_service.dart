import 'package:cafein/models/auth_model.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthModel> login({
    required String username,
    required String password,
    String? firebaseToken,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_LOGIN,
        data: {
          'username': username,
          'password': password,
          'firebase_token': firebaseToken,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        // Validation error
        final msg = response.data['msg'];
        throw Exception(_parseErrorMsg(msg));
      } else if (response.statusCode == 401) {
        // Wrong credentials or inactive account
        final msg = response.data['msg'];
        throw Exception(_parseErrorMsg(msg));
      } else {
        throw Exception('Login gagal');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['msg'];
        throw Exception(_parseErrorMsg(msg) ?? 'Login gagal');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AuthModel> register({
    required String username,
    required String email,
    required String password,
    required String fullname,
    required String phone,
    required String gender,
    String? firebaseToken,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_REGISTER,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullname': fullname,
          'phone': phone,
          'gender': gender,
          'firebase_token': firebaseToken,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final msg = response.data['msg'];
        throw Exception(_parseErrorMsg(msg));
      } else {
        final msg = response.data['msg'];
        throw Exception(_parseErrorMsg(msg) ?? 'Registrasi gagal');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['msg'];
        throw Exception(_parseErrorMsg(msg) ?? 'Registrasi gagal');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AuthModel> verifyOtpRegistration({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/verifyOtpMobile',
        data: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final msg = response.data['msg'];
        throw Exception(_parseErrorMsg(msg));
      } else {
        throw Exception('Verifikasi gagal');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['msg'];
        throw Exception(_parseErrorMsg(msg) ?? 'Verifikasi gagal');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<String> requestForgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        '/requestForgotOtpMobile',
        data: {'email': email},
      );
      return response.data['msg'] ?? 'Kode OTP berhasil dikirim';
    } on DioException catch (e) {
      final msg = e.response?.data['msg'] ?? e.response?.data['message'];
      throw Exception(_parseErrorMsg(msg) ?? 'Gagal meminta reset password');
    }
  }

  Future<String> verifyForgotPasswordOtp(String email, String otp) async {
    try {
      final response = await _apiClient.dio.post(
        '/verifyForgotOtpMobile',
        data: {'email': email, 'otp': otp},
      );
      return response.data['data']['reset_token'] ?? '';
    } on DioException catch (e) {
      final msg = e.response?.data['msg'] ?? e.response?.data['message'];
      throw Exception(_parseErrorMsg(msg) ?? 'Kode OTP salah');
    }
  }

  Future<String> resetPassword(String email, String resetToken, String newPassword) async {
    try {
      final response = await _apiClient.dio.post(
        '/resetPasswordMobile',
        data: {
          'email': email,
          'reset_token': resetToken,
          'new_password': newPassword
        },
      );
      return response.data['msg'] ?? 'Password berhasil diubah';
    } on DioException catch (e) {
      final msg = e.response?.data['msg'] ?? e.response?.data['message'];
      throw Exception(_parseErrorMsg(msg) ?? 'Gagal mengubah password');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.get(AppConstants.API_LOGOUT);
    } catch (_) {
      // Ignore logout errors — we clear local session regardless
    }
  }

  Future<bool> validatePassword(String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/validatePasswordMobile', // Using ApiClient base URL
        data: {'password': password},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        throw Exception(e.response?.data['msg'] ?? 'Password tidak cocok');
      }
      throw Exception('Gagal memverifikasi password');
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      final response = await _apiClient.dio.post(
        '/updatePasswordMobile',
        data: {'new_password': newPassword},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        throw Exception(
          _parseErrorMsg(e.response?.data['msg']) ?? 'Gagal mengubah password',
        );
      }
      throw Exception('Gagal mengubah password');
    }
  }

  /// Parse error message from backend's `msg` field.
  /// `msg` can be a String or a Map<String, List<String>>.
  String? _parseErrorMsg(dynamic msg) {
    if (msg == null) return null;
    if (msg is String) return msg;
    if (msg is Map) {
      final messages = <String>[];
      msg.forEach((key, value) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else {
          messages.add(value.toString());
        }
      });
      return messages.join('\n');
    }
    return msg.toString();
  }
}
