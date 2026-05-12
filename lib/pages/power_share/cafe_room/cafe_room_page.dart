import 'package:cafein/controllers/power_share/cafe_room_controller.dart';
import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/pages/power_share/cafe_room/widgets/header_cafe_room_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CafeRoomPage extends StatelessWidget {
  const CafeRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CafeRoomController>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          const HeaderCafeRoomWidget(),
          Expanded(
            child: RefreshIndicator(
              color: ColorApp.colorPrimary,
              onRefresh: controller.refreshData,
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return _buildShimmerGrid();
                }

                // Error state
                if (controller.hasError.value) {
                  return _buildErrorState(controller);
                }

                // Empty state
                if (controller.cafeRooms.isEmpty) {
                  return _buildEmptyState();
                }

                // Data state
                return _buildDataGrid(controller);
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer / skeleton loading grid
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: ColorApp.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE0E0E0).withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle shimmer
              _shimmerBox(54, 54, isCircle: true),
              SizedBox(height: 12),
              // Title shimmer
              _shimmerBox(24, 85.0),
              SizedBox(height: 15),
              // Badge shimmer
              _shimmerBox(14, 55.0),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double height, double width, {bool isCircle = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value,
          duration: const Duration(milliseconds: 800),
          child: Container(
            height: height,
            width: isCircle ? height : width,
            decoration: BoxDecoration(
              color: ColorApp.grey.withOpacity(0.15),
              borderRadius: isCircle ? null : BorderRadius.circular(6),
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }

  /// Error state with retry
  Widget _buildErrorState(CafeRoomController controller) {
    return ListView(
      // ListView to allow pull-to-refresh on error state
      children: [
        SizedBox(height: 10.h),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: ColorApp.red.withOpacity(0.7),
              ),
              SizedBox(height: 2.h),
              Text(
                'Terjadi Kesalahan',
                style: TextStyleApp.bodyTextBold.copyWith(
                  color: ColorApp.black,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                onPressed: controller.retry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  'Coba Lagi',
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.colorPrimary,
                  foregroundColor: ColorApp.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: 10.h),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.meeting_room_outlined,
                size: 64,
                color: ColorApp.grey.withOpacity(0.5),
              ),
              SizedBox(height: 2.h),
              Text(
                'Belum ada Cafe Room',
                style: TextStyleApp.bodyTextBold.copyWith(
                  color: ColorApp.black,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Data ruang belum tersedia saat ini',
                style: TextStyleApp.bodyTextSmall.copyWith(
                  color: ColorApp.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Main data grid
  Widget _buildDataGrid(CafeRoomController controller) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: controller.cafeRooms.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final CafeRoom room = controller.cafeRooms[index];
        return _buildRoomCard(room);
      },
    );
  }

  Widget _buildRoomCard(CafeRoom room) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0E0E0).withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: ColorApp.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(PageName.cafeRoomDetail, arguments: room);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorApp.colorPrimary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.meeting_room_rounded,
                  color: ColorApp.colorPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 10),
              // Room name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  room.name,
                  style: TextStyleApp.bodyTextBold.copyWith(
                    fontSize: 13.sp,
                    color: ColorApp.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              // Code badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: ColorApp.colorPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  room.codeIlmu,
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    fontSize: 11.sp,
                    color: ColorApp.colorPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
