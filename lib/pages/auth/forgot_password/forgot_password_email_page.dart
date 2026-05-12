import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordEmailPage extends GetView<AuthController> {
  const ForgotPasswordEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        title: const Text('Lupa Password'),
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
                'Masukkan Email',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              Text(
                'Kami akan mengirimkan kode OTP untuk mengatur ulang password Anda',
                textAlign: TextAlign.center,
                style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.black.withAlpha(150)),
              ),
              SizedBox(height: 4.h),
              TextFormFieldWidget(
                titleForm: 'Email',
                hintText: 'Masukkan email terdaftar',
                isPassword: false,
                textEditingController: controller.emailController,
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
                        controller.requestForgotOtp(controller.emailController.text);
                      },
                      titleButton: 'Kirim OTP',
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
