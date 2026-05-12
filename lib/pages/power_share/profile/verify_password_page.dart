import 'package:cafein/controllers/power_share/settings_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sizer/sizer.dart';

class VerifyPasswordPage extends StatelessWidget {
  const VerifyPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(IconlyLight.arrowLeft, color: ColorApp.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                // Get.close(2) removes VerifyPasswordPage and AccountSettingsPage
                // Returns user directly to UserProfilePage
                Get.close(2);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Text(
                  'Batal',
                  style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.black54, fontSize: 14.sp),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isVerifying.value ? null : () => controller.verifyOldPassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: controller.isVerifying.value
                        ? SizedBox(
                            width: 3.w,
                            height: 3.w,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Lanjut',
                            style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                          ),
                  )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Password',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'Untuk alasan keamanan, silahkan masukkan password Anda untuk melanjutkan.',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.black54, height: 1.5, fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Password',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: 1.h),
            Obx(() => TextField(
                  controller: controller.oldPasswordController,
                  obscureText: controller.isOldPasswordObscured.value,
                  style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 14.sp),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ColorApp.colorPrimary),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isOldPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black45,
                        size: 20.sp,
                      ),
                      onPressed: controller.toggleOldPasswordVisibility,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
