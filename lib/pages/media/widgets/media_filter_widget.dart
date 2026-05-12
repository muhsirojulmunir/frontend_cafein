import 'package:cafein/controllers/media/media_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/bottom_sheet_widget.dart';
import 'package:cafein/widgets/dropdown_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MediaFilterWidget extends StatelessWidget {
  const MediaFilterWidget({super.key, required this.controller});
  final MediaController controller;

  // Daftar volume unik dari data
  static const List<String> _volumes = ['1', '2', '3', '4', '5', '6'];

  // Daftar tahun
  static const List<String> _years = [
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.5.w,
      child: Row(
        children: [
          // ── Search field ──
          Container(
            width: 73.5.w,
            height: 12.5.w,
            margin: EdgeInsets.only(bottom: 0.5.h),
            decoration: BoxDecoration(
              color: ColorApp.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [ElevationApp.elevation4pxBottom],
            ),
            child: TextFormField(
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 15.sp,
                color: ColorApp.black.withAlpha(150),
                fontWeight: FontWeight.normal,
              ),
              onChanged: (value) => controller.searchMedia(value),
              onFieldSubmitted: (value) => controller.searchMedia(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 22.sp),
                hintText: 'Cari judul, volume, atau tahun...',
                hintStyle: TextStyleApp.bodyTextSmall.copyWith(fontSize: 13.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.colorPrimary),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.5.w),

          // ── Filter button ──
          Obx(
            () => InkWell(
              onTap: () {
                // Simpan pilihan sementara
                String? tempVolume = controller.filterVolume.value.isEmpty
                    ? null
                    : controller.filterVolume.value;
                String? tempYear = controller.filterYear.value.isEmpty
                    ? null
                    : controller.filterYear.value;

                BottomSheetWidget.showSimpleBottomSheet(
                  context,
                  titleText: 'Filter Media',
                  bottomSheetContent: StatefulBuilder(
                    builder: (ctx, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Filter Volume ──
                          DropdownFieldWidget(
                            items: _volumes,
                            initialItem: tempVolume,
                            onChanged: (value) {
                              setState(() => tempVolume = value);
                            },
                            titleForm: 'Volume',
                            hintText: 'Pilih volume',
                          ),
                          SizedBox(height: 3.h),

                          // ── Filter Tahun ──
                          DropdownFieldWidget(
                            items: _years,
                            initialItem: tempYear,
                            onChanged: (value) {
                              setState(() => tempYear = value);
                            },
                            titleForm: 'Tahun',
                            hintText: 'Pilih tahun',
                          ),
                          SizedBox(height: 3.h),

                          // ── Tombol Reset & Apply ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset
                              InkWell(
                                onTap: () {
                                  controller.resetFilter();
                                  Get.back();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 43.5.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorApp.red.withAlpha(200),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      ElevationApp.elevation4pxBottom,
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        size: 18.sp,
                                        color: ColorApp.white,
                                      ),
                                      SizedBox(width: 1.5.w),
                                      Text(
                                        'Reset',
                                        style: TextStyleApp.bodyTextBold
                                            .copyWith(
                                              fontSize: 16.sp,
                                              color: ColorApp.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),

                              // Apply
                              InkWell(
                                onTap: () {
                                  controller.applyFilter(
                                    volume: tempVolume ?? '',
                                    year: tempYear ?? '',
                                  );
                                  Get.back();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 43.5.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorApp.colorPrimary,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      ElevationApp.elevation4pxBottom,
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 18.sp,
                                        color: ColorApp.white,
                                      ),
                                      SizedBox(width: 1.5.w),
                                      Text(
                                        'Apply',
                                        style: TextStyleApp.bodyTextBold
                                            .copyWith(
                                              fontSize: 16,
                                              color: ColorApp.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  enableDrag: false,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 12.5.w,
                height: 12.5.w,
                margin: EdgeInsets.only(bottom: 0.5.h),
                decoration: BoxDecoration(
                  color: controller.isActiveFilter.value
                      ? ColorApp.colorPrimary
                      : ColorApp.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isActiveFilter.value
                        ? ColorApp.colorPrimary
                        : ColorApp.grey,
                  ),
                  boxShadow: [ElevationApp.elevation4pxBottom],
                ),
                child: Icon(
                  Icons.filter_alt_outlined,
                  size: 22.sp,
                  color: controller.isActiveFilter.value
                      ? ColorApp.white
                      : ColorApp.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
