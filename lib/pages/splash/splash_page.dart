import 'package:cafein/controllers/splash/splash_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorApp.white,
          body: Stack(
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: Center(
                  child: Image.asset(
                    'assets/images/img_logo_cafein_splash.png',
                    width: 50.w,
                  ),
                ),
              ),
              Obx(
                () => Positioned(
                  left: 16,
                  right: 16,
                  bottom: 2.5.h,
                  child: Text(
                    'Copyright © 2026\n Version ${controller.version.value}',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.black.withAlpha(100),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
