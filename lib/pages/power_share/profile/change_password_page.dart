import 'package:cafein/controllers/power_share/settings_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

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
                // Get.close(3) removes Change, Verify, and Account Settings
                // Returns directly to UserProfilePage
                Get.close(3);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Text(
                  'Batal',
                  style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.black54, fontSize: 12.sp),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isUpdating.value ? null : () => controller.updatePassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: controller.isUpdating.value
                        ? SizedBox(
                            width: 3.w,
                            height: 3.w,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Simpan',
                            style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.sp),
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
              'Ubah Sandi',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'Silakan masukkan sandi baru Anda.',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.black54, height: 1.5, fontSize: 12.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Kata Sandi Baru',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 13.sp),
            ),
            SizedBox(height: 1.h),
            Obx(() => TextField(
                  controller: controller.newPasswordController,
                  obscureText: controller.isNewPasswordObscured.value,
                  style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 12.sp),
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
                        controller.isNewPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black45,
                        size: 16.sp,
                      ),
                      onPressed: controller.toggleNewPasswordVisibility,
                    ),
                  ),
                )),
            SizedBox(height: 3.h),
            Text(
              'Konfirmasi Kata Sandi Baru',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 13.sp),
            ),
            SizedBox(height: 1.h),
            Obx(() => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.isConfirmPasswordObscured.value,
                  style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 12.sp),
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
                        controller.isConfirmPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black45,
                        size: 16.sp,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
