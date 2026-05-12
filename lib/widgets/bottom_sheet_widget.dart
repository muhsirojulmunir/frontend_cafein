import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class BottomSheetWidget {
  /// simple Bottom Sheet
  static Future<T?> showSimpleBottomSheet<T>(
    BuildContext context, {
    required Widget bottomSheetContent,
    bool expand = false,
    bool enableDrag = true,
    required String titleText,
  }) {
    return showMaterialModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      backgroundColor: ColorApp.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(5.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titleText,
                      style: TextStyleApp.titleText.copyWith(
                        color: ColorApp.colorPrimary,
                        fontSize: 18.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, size: 24, color: ColorApp.black),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                bottomSheetContent,
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
      expand: expand,
      isDismissible: true,
      enableDrag: enableDrag,
    );
  }
}
