import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final String image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
        decoration: BoxDecoration(
          boxShadow: [ElevationApp.elevation4pxBottom],
          borderRadius: BorderRadius.circular(30),
          color: ColorApp.white,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            gradient: AppGradient.menuGradient,
            color: ColorApp.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            spacing: 5.w,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: TextStyleApp.bodyTextBold.copyWith(
                        color: ColorApp.white,
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Text(
                      subtitle,
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        color: ColorApp.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(image, height: 12.5.h),
            ],
          ),
        ),
      ),
    );
  }
}
