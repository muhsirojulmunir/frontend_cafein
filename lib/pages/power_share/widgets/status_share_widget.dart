import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StatusShareWidget extends StatelessWidget {
  const StatusShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(PageName.ask),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 4.w),
          CircleAvatar(
            radius: 5.5.w,
            backgroundColor: ColorApp.colorPrimary.withOpacity(0.15),
            child: Icon(
              Icons.person_rounded,
              color: ColorApp.colorPrimary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Container(
              height: 11.w,
              margin: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                color: ColorApp.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [ElevationApp.elevation4pxBottom],
                border: Border.all(color: ColorApp.grey.withOpacity(0.3)),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Apa yang sedang kamu pikirkan?',
                style: TextStyleApp.bodyTextSmall.copyWith(
                  color: ColorApp.grey,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
