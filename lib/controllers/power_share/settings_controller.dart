import 'package:cafein/services/local/token.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:cafein/services/auth_service.dart';
import 'package:cafein/pages/power_share/profile/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final AuthService _authService = AuthService();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPasswordObscured = true.obs;
  final isNewPasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;

  final isVerifying = false.obs;
  final isUpdating = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordObscured.value = !isOldPasswordObscured.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordObscured.value = !isNewPasswordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  Future<void> verifyOldPassword() async {
    final password = oldPasswordController.text.trim();
    if (password.isEmpty) {
      Get.snackbar('Error', 'Masukkan password saat ini',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isVerifying.value = true;
      final isValid = await _authService.validatePassword(password);
      if (isValid) {
        // Go to Change Password Page
        Get.to(() => const ChangePasswordPage());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> updatePassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('Error', 'Semua kolom harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isUpdating.value = true;
      final success = await _authService.updatePassword(newPass);
      if (success) {
        Get.snackbar('Berhasil', 'Password Anda berhasil diubah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        
        // Return to PowerShare (Home)
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Show loading or confirmation if needed, but usually just logout
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Call Backend Logout (Optional but good practice)
      await _authService.logout();

      // 2. Clear Local Session (Crucial)
      await Token.clearSession();

      // 3. Close loading dialog
      Get.back();

      // 4. Redirect to Login and clear navigation stack
      Get.offAllNamed(PageName.login);

      Get.snackbar(
        'Berhasil',
        'Anda telah keluar dari aplikasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar(
        'Error',
        'Gagal keluar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
