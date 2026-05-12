import 'package:dio/dio.dart';
import 'package:cafein/utils/constants.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:get/get.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await Token.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['login-type'] = '1';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle 401 Unauthorized — token expired
          if (e.response?.statusCode == 401) {
            Token.clearSession();
            Get.offAllNamed(PageName.login);
            Get.snackbar(
              'Sesi Berakhir',
              'Silakan login kembali',
              snackPosition: SnackPosition.TOP,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }
}
