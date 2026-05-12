import 'package:cafein/controllers/power_share/cafe_room_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HeaderCafeRoomWidget extends StatelessWidget {
  const HeaderCafeRoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CafeRoomController>();
    final double jarakAntarCafe = 0.7.h; // Jarak antar daftar cafe
    final double jarakKeTemukanRuang = 1.2.h; // Jarak antar "Temukan Ruang"
    final double ukuranFontCafe = 13.sp; // Memperbesar/memperkecil font ruangan
    final double ukuranIconCafe =
        22.sp; // Memperbesar/memperkecil ukuran icon orang

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          // Followed Rooms Section
          Obx(() {
            if (controller.followedRooms.isEmpty ||
                controller.searchQuery.value.isNotEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: controller.followedRooms.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final room = controller.followedRooms[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(PageName.cafeRoomDetail, arguments: room);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical:
                                jarakAntarCafe, // ⚙️ Menggunakan variabel jarakAntarCafe
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.group_rounded,
                                color: ColorApp.colorPrimary,
                                size: ukuranIconCafe,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  room.name,
                                  style: TextStyleApp.bodyTextBold.copyWith(
                                    color: ColorApp.colorPrimary,
                                    fontSize: ukuranFontCafe,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: ColorApp.colorPrimary,
                                size: ukuranIconCafe,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          // ⚙️ Jarak ini diatur dari variabel jarakKeTemukanRuang di atas
          SizedBox(height: jarakKeTemukanRuang),
          Text(
            'Temukan Ruang',
            style: TextStyleApp.bodyTextBold.copyWith(
              color: ColorApp.colorSecondary,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            'Ruang yang mungkin kamu suka',
            style: TextStyleApp.bodyTextSmall.copyWith(
              color: ColorApp.colorPrimary,
            ),
          ),
          SizedBox(height: 1.5.h),
          // Search field
          TextField(
            controller: controller.searchController,
            onChanged: controller.onSearch,
            style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.black),
            decoration: InputDecoration(
              hintText: 'Cari ruang...',
              hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                color: ColorApp.grey,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: ColorApp.colorPrimary,
                size: 22,
              ),
              suffixIcon: Obx(() {
                // Read the observable searchQuery so GetX can track it
                final hasText = controller.searchQuery.value.isNotEmpty;
                if (hasText) {
                  return GestureDetector(
                    onTap: controller.clearSearch,
                    child: Icon(
                      Icons.close_rounded,
                      color: ColorApp.grey,
                      size: 20,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              filled: true,
              fillColor: ColorApp.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.2.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorApp.grey.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorApp.grey.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorApp.colorPrimary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
        ],
      ),
    );
  }
}
