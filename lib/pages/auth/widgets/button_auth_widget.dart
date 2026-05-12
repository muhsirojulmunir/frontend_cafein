import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonAuthWidget extends StatelessWidget {
  const ButtonAuthWidget({
    super.key,
    this.width,
    required this.enable,
    required this.titleButton,
    required this.onTap,
  });

  final double? width;
  final bool enable;
  final String titleButton;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: enable ? ColorApp.colorPrimary : ColorApp.grey.withAlpha(120),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [ElevationApp.elevation4pxBottom],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Center(
            child: Text(
              titleButton,
              style: TextStyleApp.bodyTextBold.copyWith(
                fontSize: 17.sp,
                color: ColorApp.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
