import 'package:cafein/controllers/media/media_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MediaTabWidget extends StatelessWidget {
  const MediaTabWidget({super.key, required this.controller});
  final MediaController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: ColorApp.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildTab(label: 'Semua', icon: Icons.list_alt_rounded, index: 0),
            SizedBox(width: 2.w),
            _buildTab(
              label: 'Bookmark',
              icon: Icons.bookmark_rounded,
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final isActive = controller.selectedTabIndex.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.switchTab(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            color: isActive ? ColorApp.colorPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive ? [ElevationApp.elevation4pxBottom] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isActive ? ColorApp.white : ColorApp.grey,
              ),
              SizedBox(width: 1.5.w),
              Text(
                label,
                style: TextStyleApp.bodyTextSmallBold.copyWith(
                  fontSize: 14.sp,
                  color: isActive ? ColorApp.white : ColorApp.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
