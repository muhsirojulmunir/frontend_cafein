import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:cafein/pages/power_share/widgets/content_share_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FollowPage extends StatelessWidget {
  const FollowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowController>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return _buildShimmerList();
        }

        // Error state
        if (controller.hasError.value) {
          return _buildErrorState(controller);
        }

        // Empty state
        if (controller.posts.isEmpty) {
          return _buildEmptyState(controller);
        }

        // Data state
        return RefreshIndicator(
          color: ColorApp.colorPrimary,
          onRefresh: controller.refreshPosts,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                const ContentShareWidget(isHome: false),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          color: ColorApp.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmer(40, 40, isCircle: true),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmer(14, 120),
                      SizedBox(height: 6),
                      _shimmer(10, 80),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              _shimmer(200, double.infinity),
              SizedBox(height: 1.h),
              _shimmer(14, 180),
              SizedBox(height: 6),
              _shimmer(12, 250),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmer(double height, double width, {bool isCircle = false}) {
    return Container(
      height: height,
      width: isCircle ? height : width,
      decoration: BoxDecoration(
        color: ColorApp.grey.withOpacity(0.12),
        borderRadius: isCircle ? null : BorderRadius.circular(6),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }

  Widget _buildErrorState(FollowController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: ColorApp.red.withOpacity(0.6)),
            SizedBox(height: 2.h),
            Text('Terjadi Kesalahan',
                style: TextStyleApp.bodyTextBold.copyWith(fontSize: 13.sp)),
            SizedBox(height: 1.h),
            Text(controller.errorMessage.value,
                style:
                    TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.grey),
                textAlign: TextAlign.center),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: controller.retry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text('Coba Lagi',
                  style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.colorPrimary,
                foregroundColor: ColorApp.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(FollowController controller) {
    return RefreshIndicator(
      color: ColorApp.colorPrimary,
      onRefresh: controller.refreshPosts,
      child: ListView(
        children: [
          SizedBox(height: 15.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.people_outline_rounded,
                    size: 56, color: ColorApp.grey.withOpacity(0.5)),
                SizedBox(height: 2.h),
                Text('Belum ada posting',
                    style:
                        TextStyleApp.bodyTextBold.copyWith(fontSize: 13.sp)),
                SizedBox(height: 1.h),
                Text('Ikuti pengguna lain untuk melihat posting mereka',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                        color: ColorApp.grey),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
