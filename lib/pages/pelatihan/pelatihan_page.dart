import 'package:cafein/controllers/pelatihan/pelatihan_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PelatihanPage extends GetView<PelatihanController> {
  const PelatihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradient.pageBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'CafeIN',
          style: TextStyleApp.bodyTextBold.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 85.w,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pelatihan',
                style: TextStyleApp.bodyTextBold.copyWith(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              // Illustration from assets
              Image.asset(
                'assets/images/img_pelatihan.png',
                height: 20.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 15.h,
                    width: 15.h,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50.sp,
                      color: ColorApp.colorPrimary,
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              Text(
                'Akses pelatihan eksklusif langsung\ndari perangkat Anda.',
                textAlign: TextAlign.center,
                style: TextStyleApp.bodyText.copyWith(
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Klik tombol di bawah untuk membuka\nportal web kami.',
                textAlign: TextAlign.center,
                style: TextStyleApp.bodyText.copyWith(
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.launchTrainingUrl(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                      0xFF0F5699,
                    ), // Darker blue for button
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Buka web pelatihan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
