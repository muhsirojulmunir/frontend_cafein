import 'package:cafein/controllers/regulation/regulation_controller.dart';
import 'package:cafein/pages/regulation/widgets/regulation_filter_widget.dart';
import 'package:cafein/pages/regulation/widgets/regulation_item_list_widget.dart';
import 'package:cafein/pages/regulation/widgets/regulation_tab_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegulationPage extends StatelessWidget {
  const RegulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegulationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F9),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // ── Sliver App Bar dengan Header Banner ──
              SliverAppBar(
                expandedHeight: 26.h,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: ColorApp.colorPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                title: AnimatedOpacity(
                  opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    'Regulasi',
                    style: TextStyleApp.bodyTextBold.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _buildHeaderBanner(),
                ),
              ),
            ],
            body: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // ── Search & Filter ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                    child: RegulationFilterWidget(controller: controller),
                  ),
                  SizedBox(height: 1.5.h),

                  // ── Tabs: Semua / Bookmark ──
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: RegulationTabWidget(controller: controller),
                  ),
                  SizedBox(height: 1.5.h),

                  // ── Item List ──
                  Expanded(
                    child: Obx(() {
                      // Loading state — shimmer skeleton
                      if (controller.isLoading.value) {
                        return _buildShimmerLoading();
                      }

                      // Error state
                      if (controller.errorMsg.value.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withAlpha(20),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.error_outline_rounded,
                                    size: 40.sp,
                                    color: Colors.red.withAlpha(180),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  controller.errorMsg.value,
                                  style: TextStyleApp.bodyTextSmall.copyWith(
                                    fontSize: 14.sp,
                                    color: ColorApp.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 2.5.h),
                                ElevatedButton.icon(
                                  onPressed: () => controller.fetchData(),
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Coba Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorApp.colorPrimary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 1.5.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final items = controller.filteredMenuItems;

                      // Empty state
                      if (items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: ColorApp.grey.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  controller.selectedTabIndex.value == 1
                                      ? Icons.bookmark_border_rounded
                                      : Icons.search_off_rounded,
                                  size: 40.sp,
                                  color: ColorApp.grey.withAlpha(100),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                controller.selectedTabIndex.value == 1
                                    ? 'Belum ada regulasi yang di-bookmark'
                                    : 'Regulasi tidak ditemukan',
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  fontSize: 14.sp,
                                  color: ColorApp.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      // Regulation list with pull-to-refresh
                      return RefreshIndicator(
                        onRefresh: () => controller.fetchData(),
                        color: ColorApp.colorPrimary,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final originalIndex = controller.getOriginalIndex(
                              item,
                            );
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.5.h),
                              child: RegulationItemListWidget(
                                controller: controller,
                                data: item,
                                originalIndex: originalIndex,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Shimmer Loading Skeleton ──
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.5.h),
          child: _ShimmerCard(),
        );
      },
    );
  }

  // ── Header Banner ──
  Widget _buildHeaderBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E4E78), Color(0xFF1A7A55)],
        ),
      ),
      child: Stack(
        children: [
          // Lingkaran dekoratif belakang
          Positioned(
            top: -3.h,
            right: -8.w,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(18),
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            left: -6.w,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(12),
              ),
            ),
          ),

          // Konten utama
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(6.w, 1.h, 6.w, 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Teks kiri ──
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Dokumen Resmi',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              fontSize: 13.sp,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Regulasi',
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Kebijakan & panduan resmi\nuntuk semua kebutuhan Anda.',
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            fontSize: 13.sp,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Gambar Logo regulasi ──
                  Image.asset(
                    appImages.imgRegulasi.path,
                    height: 20.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.gavel_rounded,
                      size: 50.sp,
                      color: Colors.white.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer Card Widget ──
class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [ElevationApp.elevation4pxBottom],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left accent bar
                  Container(width: 1.5.w, color: Colors.grey.withAlpha(40)),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(width: 70.w, height: 1.8.h),
                          SizedBox(height: 1.h),
                          _shimmerBox(width: 55.w, height: 1.4.h),
                          SizedBox(height: 0.5.h),
                          _shimmerBox(width: 40.w, height: 1.4.h),
                          SizedBox(height: 1.5.h),
                          Row(
                            children: [
                              _shimmerBox(width: 22.w, height: 3.h),
                              SizedBox(width: 2.w),
                              _shimmerBox(width: 30.w, height: 3.h),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Divider(
                            color: Colors.grey.withAlpha(30),
                            height: 1,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _shimmerBox(width: 16.w, height: 3.5.h),
                              _shimmerBox(width: 16.w, height: 3.5.h),
                              _shimmerBox(width: 16.w, height: 3.5.h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

