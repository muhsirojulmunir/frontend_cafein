import 'package:cafein/controllers/home/home_controller.dart';
import 'package:cafein/pages/home/widgets/home_menu_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showLogoutDialog(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.exit_to_app_rounded, color: ColorApp.red, size: 24.sp),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: TextStyleApp.bodyTextBold.copyWith(
                fontSize: 16.sp,
                color: ColorApp.colorSecondary,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyleApp.bodyTextSmall.copyWith(
            color: ColorApp.black.withAlpha(180),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Batal',
              style: TextStyleApp.bodyTextSmallBold.copyWith(
                color: ColorApp.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Menggunakan HomeController untuk logout supaya aman dan tidak error rute
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
              style: TextStyleApp.bodyTextSmallBold.copyWith(
                color: ColorApp.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorApp.white,
          body: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(appImages.bgHome.path),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(), // Scroll interaktif
                slivers: [
                  // === HEADER: Logout Button + Logo + Teks ===
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          SizedBox(height: 1.h),
                          // Tombol Logout di pojok kiri atas
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () =>
                                  _showLogoutDialog(context, controller),
                              icon: Icon(
                                Icons.exit_to_app_rounded,
                                color: ColorApp.colorPrimary,
                                size: 24.sp,
                              ),
                            ),
                          ),
                          // Jarak antara tombol logout dan teks
                          SizedBox(height: 2.h),
                          Text(
                            'Selamat datang di Cafein',
                            style: TextStyleApp.bodyTextBold.copyWith(
                              fontSize: 18.sp,
                              color: ColorApp.colorSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.1.h),
                          Text(
                            'Dapatkan info regulasi terbaru, jelajahi media, dan bagikan pengetahuan di satu tempat.',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              color: ColorApp.black.withAlpha(100),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                  ),

                  // === MENU ITEMS ===
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final menu = controller.menuItems[index];
                      return HomeMenuWidget(
                        title: menu['title'],
                        subtitle: menu['subtitle'],
                        image: menu['image'],
                        onTap: () {
                          Get.toNamed(menu['route']);
                        },
                      );
                    }, childCount: controller.menuItems.length),
                  ),

                  // Padding bawah agar menu tidak terpotong navbar
                  SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
