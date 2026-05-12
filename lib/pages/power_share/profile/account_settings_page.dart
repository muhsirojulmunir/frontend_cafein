import 'package:cafein/controllers/power_share/settings_controller.dart';
import 'package:cafein/pages/power_share/profile/verify_password_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sizer/sizer.dart';

class AccountSettingsPage extends StatelessWidget {
  final String email;
  const AccountSettingsPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(IconlyLight.arrowLeft, color: ColorApp.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Setelan Akun',
          style: TextStyleApp.bodyTextLarge.copyWith(color: ColorApp.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: ColorApp.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                'Surel',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 1.5.h),
            const Divider(height: 1, color: Colors.black12),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: TextStyleApp.bodyTextBold.copyWith(fontSize: 13.sp),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Surel Utama',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: Colors.black54,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                'Sandi',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 1.5.h),
            const Divider(height: 1, color: Colors.black12),
            InkWell(
              onTap: () {
                Get.to(() => const VerifyPasswordPage());
              },
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Row(
                  children: [
                    Text(
                      'Ubah Sandi',
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        color: ColorApp.colorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                'Lainnya',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 1.5.h),
            const Divider(height: 1, color: Colors.black12),
            InkWell(
              onTap: () {
                _showLogoutConfirmation(context, Get.find<SettingsController>());
              },
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Row(
                  children: [
                    Icon(IconlyLight.logout, color: Colors.red, size: 20.sp),
                    SizedBox(width: 3.w),
                    Text(
                      'Keluar dari Akun',
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, SettingsController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Konfirmasi Keluar',
          style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 12.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Keluar',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
