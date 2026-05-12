import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordOtpPage extends GetView<AuthController> {
  const ForgotPasswordOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments?['email'] ?? '';

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        title: const Text('Verifikasi OTP'),
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
                'Cek Email Anda',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              Text(
                'Masukkan 4 digit kode OTP yang telah dikirim ke $email',
                textAlign: TextAlign.center,
                style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.black.withAlpha(150)),
              ),
              SizedBox(height: 5.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.sp, letterSpacing: 10.0, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '----',
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Obx(() => controller.errorMessage.isNotEmpty
                  ? Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red))
                  : const SizedBox.shrink()),
              SizedBox(height: 4.h),
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ButtonAuthWidget(
                      enable: true,
                      onTap: () {
                        controller.verifyForgotOtp(email, controller.otpController.text);
                      },
                      titleButton: 'Verifikasi',
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
