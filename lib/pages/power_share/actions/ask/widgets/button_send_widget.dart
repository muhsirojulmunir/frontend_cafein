import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonSendWidget extends StatelessWidget {
  const ButtonSendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorApp.colorPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [ElevationApp.elevation4pxBottom],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 2.w,
            children: [
              Text(
                'Send',
                style: TextStyleApp.bodyTextBold.copyWith(
                  fontSize: 17.sp,
                  color: ColorApp.white,
                ),
              ),
              Icon(Icons.send, color: ColorApp.white),
            ],
          ),
        ),
      ),
    );
  }
}
