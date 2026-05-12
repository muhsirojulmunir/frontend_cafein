import 'package:cafein/models/auth_model.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:cafein/services/auth_service.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var selectedGender = 'L'.obs; // Default Laki-laki

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var rememberMe = false.obs;
  var resetToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedUsername();
  }

  void _loadSavedUsername() async {
    final savedUsername = await Token.getSavedUsername();
    if (savedUsername != null && savedUsername.isNotEmpty) {
      usernameController.text = savedUsername;
      rememberMe(true);
    }
  }

  void login({required String username, required String password}) async {
    // Client-side validation
    if (username.trim().isEmpty) {
      errorMessage('Username harus diisi');
      return;
    }
    if (password.trim().isEmpty) {
      errorMessage('Password harus diisi');
      return;
    }

    try {
      isLoading(true);
      errorMessage('');

      final firebaseToken = await PushNotificationService.getToken();

      AuthModel result = await _authService.login(
        username: username,
        password: password,
        firebaseToken: firebaseToken,
      );

      // Save session data
      await Token.saveSession(
        token: result.token,
        userId: result.user.id.toString(),
        level: result.user.level,
        username: result.user.username,
        email: result.user.email,
        fullname: result.user.fullname,
      );

      if (rememberMe.value) {
        await Token.saveSavedUsername(username);
      } else {
        await Token.removeSavedUsername();
      }

      Get.offAllNamed(PageName.home);
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (!isClosed) {
        isLoading(false);
      }
    }
  }

  void register({
    required String username,
    required String email,
    required String password,
    required String fullname,
    required String phone,
  }) async {
    // Client-side validation
    if (fullname.trim().isEmpty) {
      errorMessage('Nama lengkap harus diisi');
      return;
    }
    if (username.trim().isEmpty) {
      errorMessage('Username harus diisi');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage('Email tidak valid');
      return;
    }
    if (phone.trim().isEmpty) {
      errorMessage('Nomor telepon harus diisi');
      return;
    }
    if (password.length < 6) {
      errorMessage('Password minimal 6 karakter');
      return;
    }

    try {
      isLoading(true);
      errorMessage('');

      final firebaseToken = await PushNotificationService.getToken();

      AuthModel result = await _authService.register(
        username: username,
        email: email,
        password: password,
        fullname: fullname,
        phone: phone,
        gender: selectedGender.value,
        firebaseToken: firebaseToken,
      );

      // Menuju halaman verifikasi OTP dengan membawa parameter email
      Get.snackbar(
        'Pendaftaran Berhasil',
        result.message ?? 'Silakan periksa email Anda untuk kode OTP 4 digit.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.toNamed(PageName.verifyOtp, arguments: {'email': email});
    } catch (e) {
      String errStr = e.toString().replaceAll('Exception: ', '');
      if (errStr.contains('Duplicate entry') && errStr.contains('employees_phone_unique')) {
        errorMessage('Nomor telepon tersebut sudah digunakan. Silakan gunakan nomor lain.');
      } else if (errStr.contains('Duplicate entry') && errStr.contains('users_email_unique')) {
        errorMessage('Email tersebut sudah terdaftar. Silakan gunakan email lain atau login.');
      } else if (errStr.contains('Duplicate entry') && errStr.contains('users_username_unique')) {
        errorMessage('Username tersebut sudah dipakai. Silakan pilih username lain.');
      } else {
        errorMessage(errStr);
      }
    } finally {
      if (!isClosed) {
        isLoading(false);
      }
    }
  }

  Future<void> verifyRegistrationOtp(String email, String otp) async {
    try {
      isLoading(true);
      errorMessage('');

      AuthModel result = await _authService.verifyOtpRegistration(
        email: email,
        otp: otp,
      );

      // Save session data
      await Token.saveSession(
        token: result.token,
        userId: result.user.id.toString(),
        level: result.user.level,
        username: result.user.username,
        email: result.user.email,
        fullname: result.user.fullname,
      );

      Get.snackbar(
        'Verifikasi Berhasil',
        result.message ?? 'Anda telah berhasil masuk.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(PageName.home);
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (!isClosed) {
        isLoading(false);
      }
    }
  }

  Future<void> requestForgotOtp(String email) async {
    try {
      isLoading(true);
      errorMessage('');
      final msg = await _authService.requestForgotPassword(email);
      Get.snackbar('Sukses', msg,
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed(PageName.forgotPasswordOtp, arguments: {'email': email});
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (!isClosed) isLoading(false);
    }
  }

  Future<void> verifyForgotOtp(String email, String otp) async {
    try {
      isLoading(true);
      errorMessage('');
      final token = await _authService.verifyForgotPasswordOtp(email, otp);
      resetToken.value = token;
      Get.snackbar('Sukses', 'OTP Valid, silakan buat password baru',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed(PageName.forgotPasswordNew, arguments: {'email': email});
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (!isClosed) isLoading(false);
    }
  }

  Future<void> createNewPassword(String email) async {
    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage('Password tidak cocok');
      return;
    }
    if (newPasswordController.text.length < 6) {
      errorMessage('Password minimal 6 karakter');
      return;
    }

    try {
      isLoading(true);
      errorMessage('');
      final msg = await _authService.resetPassword(
          email, resetToken.value, newPasswordController.text);
      Get.snackbar('Sukses', msg,
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.until((route) => Get.currentRoute == PageName.login);
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (!isClosed) isLoading(false);
    }
  }

  void logout() async {
    try {
      await _authService.logout();
    } finally {
      await Token.clearSession();
      Get.offAllNamed(PageName.login);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
