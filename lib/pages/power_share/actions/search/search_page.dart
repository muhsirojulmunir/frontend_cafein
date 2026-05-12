import 'package:cafein/controllers/power_share/search_share_controller.dart';
import 'package:cafein/pages/power_share/cafe_room/post_detail_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SearchPage extends GetView<SearchShareController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBarWidget(title: 'Cari Postingan', leadingIcon: true),
      body: Column(
        children: [
          // ── Search Input ──
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 13.sp),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => controller.search(value),
                decoration: InputDecoration(
                  hintText: 'Cari topik atau kata kunci...',
                  hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.grey,
                    fontSize: 13.sp,
                  ),
                  prefixIcon: Icon(
                    IconlyLight.search,
                    color: ColorApp.colorPrimary,
                    size: 20.sp,
                  ),
                  suffixIcon: Obx(
                    () => controller.searchText.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: controller.clearSearch,
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),

          // ── Results List ──
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.searchResults.isEmpty) {
                if (controller.searchController.text.isEmpty) {
                  return _buildEmptyState(
                    icon: IconlyLight.search,
                    title: 'Cari Sesuatu',
                    desc: 'Temukan diskusi menarik di Berbagi',
                  );
                }
                return _buildEmptyState(
                  icon: IconlyLight.infoSquare,
                  title: 'Tidak Ditemukan',
                  desc: 'Maaf, postingan tidak ditemukan.',
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final post = controller.searchResults[index];
                  return _buildResultTile(post);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(dynamic post) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorApp.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(4.w),
        onTap: () {
          Get.to(
            () => const PostDetailPage(),
            arguments: post.toJson(),
            transition: Transition.cupertino,
          );
        },
        title: Text(
          post.title ?? 'Tanpa Judul',
          style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.description ?? '',
                style: TextStyleApp.bodyTextSmall.copyWith(
                  fontSize: 12.sp,
                  color: ColorApp.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Icon(
                    IconlyLight.profile,
                    size: 12.sp,
                    color: ColorApp.colorPrimary,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    post.fullname ?? 'Pengguna',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorApp.colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Icon(
          IconlyLight.arrowRight2,
          size: 18.sp,
          color: ColorApp.grey,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50.sp, color: ColorApp.grey.withOpacity(0.3)),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyleApp.bodyTextBold.copyWith(
              fontSize: 16.sp,
              color: ColorApp.grey,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            desc,
            style: TextStyleApp.bodyTextSmall.copyWith(
              fontSize: 12.sp,
              color: ColorApp.grey,
            ),
          ),
        ],
      ),
    );
  }
}
