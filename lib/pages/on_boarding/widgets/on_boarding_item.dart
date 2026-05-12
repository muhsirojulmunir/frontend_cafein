import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({
    super.key,
    required this.title,
    required this.image,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.5.w, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 25.h),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyleApp.titleText.copyWith(
              color: ColorApp.colorPrimary,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Visibility(
            visible: subtitle != null,
            child: Text(
              subtitle ?? '',
              style: TextStyleApp.bodyText.copyWith(
                color: ColorApp.black.withAlpha(150),
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
