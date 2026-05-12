import 'package:cafein/controllers/podcast/podcast_controller.dart';
import 'package:cafein/pages/podcast/podcast_detail_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PodcastPage extends GetView<PodcastController> {
  const PodcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradient.pageBackgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 2.h),
              _buildSearchBar(),
              SizedBox(height: 2.h),
              Expanded(
                child: Obx(() {
                  // Loading state
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  // Error state
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 40.sp,
                            color: Colors.white.withAlpha(150),
                          ),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              controller.errorMessage.value,
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                fontSize: 14.sp,
                                color: Colors.white.withAlpha(200),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: () => controller.fetchPodcasts(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty state
                  if (controller.filteredPodcastList.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada podcast',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    itemCount: controller.filteredPodcastList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final podcast = controller.filteredPodcastList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PodcastDetailPage(podcast: podcast));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Hero(
                                      tag: podcast.imageUrl,
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          podcast.imageUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      podcast.title,
                                      style: TextStyleApp.bodyTextBold.copyWith(
                                        fontSize: 15.sp,
                                        color: ColorApp.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category_outlined,
                                          size: 12.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          podcast.category,
                                          style: TextStyleApp.bodyTextSmall
                                              .copyWith(
                                                color: Colors.grey,
                                                fontSize: 13.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Divider(
                                      color: ColorApp.grey.withAlpha(50),
                                      height: 1,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: 1.2.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildActionButton(
                                          icon: Icons.visibility_rounded,
                                          label: 'Lihat',
                                          color: ColorApp.green,
                                          onTap: () {
                                            _showImagePreview(podcast.imageUrl);
                                          },
                                        ),
                                        _verticalDivider(),
                                        _buildActionButton(
                                          icon: podcast.isBookmarked
                                              ? Icons.bookmark_rounded
                                              : Icons.bookmark_border_rounded,
                                          label: 'Bookmark',
                                          color: podcast.isBookmarked
                                              ? const Color(0xFFF57C00)
                                              : ColorApp.grey,
                                          onTap: () {
                                            controller.toggleBookmark(podcast);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
  }

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: Colors.black.withAlpha(200),
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: imageUrl,
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      useSafeArea: false,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        child: Column(
          children: [
            Icon(icon, size: 18.sp, color: color),
            SizedBox(height: 0.4.h),
            Text(
              label,
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 3.5.h,
      color: ColorApp.grey.withAlpha(50),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Image.asset(appImages.imgLogoCafein.path, height: 11.h),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Popcast CafeIN',
              style: TextStyleApp.bodyTextBold.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),

          // Filter Icon
          GestureDetector(
            onTap: () => _showFilterBottomSheet(),
            child: Obx(
              () => Icon(
                Icons.filter_list_rounded,
                color: controller.selectedCategories.isNotEmpty
                    ? ColorApp.colorSecondary
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(width: 4.w),

          GestureDetector(
            onTap: () => controller.toggleFilterBookmarks(),
            child: Obx(
              () => Icon(
                controller.isShowingBookmarks.value
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) => controller.searchPodcast(value),
        decoration: InputDecoration(
          hintText: 'Cari judul atau tema...',
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.searchPodcast('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Tema',
                  style: TextStyleApp.bodyTextBold.copyWith(fontSize: 16.sp),
                ),
                TextButton(
                  onPressed: () => controller.clearFilters(),
                  child: Text(
                    'Reset',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: 1.h),
            Obx(
              () => Column(
                children: controller.categories.map((category) {
                  final isSelected = controller.selectedCategories.contains(
                    category,
                  );
                  return CheckboxListTile(
                    title: Text(
                      category,
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                    value: isSelected,
                    activeColor: ColorApp.colorSecondary,
                    onChanged: (bool? value) {
                      controller.toggleCategory(category);
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.colorSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  'Terapkan',
                  style: TextStyleApp.bodyTextBold.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
