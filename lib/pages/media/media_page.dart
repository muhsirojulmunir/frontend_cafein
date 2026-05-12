import 'package:cafein/controllers/media/media_controller.dart';
import 'package:cafein/pages/media/widgets/media_filter_widget.dart';
import 'package:cafein/pages/media/widgets/media_item_list_widget.dart';
import 'package:cafein/pages/media/widgets/media_tab_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MediaController>(
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
                    'Media',
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
                    child: MediaFilterWidget(controller: controller),
                  ),
                  SizedBox(height: 1.5.h),

                  // ── Tabs: Semua / Bookmark ──
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: MediaTabWidget(controller: controller),
                  ),
                  SizedBox(height: 1.5.h),

                  // ── Item List ──
                  Expanded(
                    child: Obx(() {
                      // Loading state
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Error state
                      if (controller.errorMsg.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 40.sp,
                                color: ColorApp.grey.withAlpha(100),
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
                              SizedBox(height: 2.h),
                              ElevatedButton(
                                onPressed: () => controller.fetchMedia(),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      }

                      final items = controller.filteredMenuItems;

                      if (items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.selectedTabIndex.value == 1
                                    ? Icons.bookmark_border_rounded
                                    : Icons.search_off_rounded,
                                size: 40.sp,
                                color: ColorApp.grey.withAlpha(100),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                controller.selectedTabIndex.value == 1
                                    ? 'Belum ada media yang di-bookmark'
                                    : 'Media tidak ditemukan',
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

                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final originalIndex = controller.getOriginalIndex(
                            item,
                          );
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: MediaItemListWidget(
                              controller: controller,
                              data: item,
                              originalIndex: originalIndex,
                            ),
                          );
                        },
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
                            'Media Konsultan',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              fontSize: 13.sp,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Media',
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Temukan berita, artikel,\ndan pembaruan terkini.',
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            fontSize: 13.sp,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Gambar ilustrasi kanan ──
                  Image.asset(
                    appImages.imgMedia.path,
                    height: 20.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.newspaper_rounded,
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
