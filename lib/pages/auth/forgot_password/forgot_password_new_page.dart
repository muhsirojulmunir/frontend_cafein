import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordNewPage extends GetView<AuthController> {
  const ForgotPasswordNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments?['email'] ?? '';

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        title: const Text('Password Baru'),
        centerTitle: true,
        backgroundColor: ColorApp.white,
        elevation: 0,
        foregroundColor: ColorApp.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Column(
            children: [
              Image.asset(
                appImages.imgLogoCafeinLogin.path,
                height: 20.h,
              ),
              SizedBox(height: 3.h),
              Text(
                'Buat Password Baru',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              Text(
                'Silakan masukkan password baru Anda',
                style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.black.withAlpha(150)),
              ),
              SizedBox(height: 4.h),
              TextFormFieldWidget(
                titleForm: 'Password Baru',
                hintText: 'Minimal 6 karakter',
                isPassword: true,
                textEditingController: controller.newPasswordController,
              ),
              SizedBox(height: 2.h),
              TextFormFieldWidget(
                titleForm: 'Konfirmasi Password',
                hintText: 'Ulangi password baru',
                isPassword: true,
                textEditingController: controller.confirmPasswordController,
              ),
              SizedBox(height: 1.h),
              Obx(() => controller.errorMessage.isNotEmpty
                  ? Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red))
                  : const SizedBox.shrink()),
              SizedBox(height: 4.h),
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ButtonAuthWidget(
                      enable: true,
                      onTap: () {
                        controller.createNewPassword(email);
                      },
                      titleButton: 'Simpan Password',
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
