import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VerifyOtpPage extends GetView<AuthController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil parameter email
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                appImages.imgLogoCafeinLogin.path,
                height: 20.h,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: 3.h),
              Text(
                'Cek Email Anda',
                style: TextStyleApp.bodyTextBold.copyWith(
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Kami telah mengirimkan 4 digit kode OTP ke email:\n$email',
                textAlign: TextAlign.center,
                style: TextStyleApp.bodyTextSmall.copyWith(
                  color: ColorApp.black.withAlpha(150),
                ),
              ),
              SizedBox(height: 5.h),
              
              // Custom OTP Input (Simple TextField for 4 digits)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    letterSpacing: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '----',
                    counterText: '',
                    hintStyle: TextStyle(
                      fontSize: 24.sp,
                      letterSpacing: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              SizedBox(height: 3.h),
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ButtonAuthWidget(
                        enable: true,
                        onTap: () {
                          if (controller.otpController.text.length != 4) {
                            controller.errorMessage('Kode OTP harus 4 digit.');
                            return;
                          }
                          controller.verifyRegistrationOtp(
                            email,
                            controller.otpController.text,
                          );
                        },
                        titleButton: 'Verifikasi',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
