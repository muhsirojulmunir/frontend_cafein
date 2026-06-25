import 'package:cafein/controllers/regulation/regulation_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/bottom_sheet_widget.dart';
import 'package:cafein/widgets/dropdown_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegulationFilterWidget extends StatelessWidget {
  const RegulationFilterWidget({super.key, required this.controller});
  final RegulationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.5.w,
      child: Row(
        children: [
          Expanded(
            child: Container(
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
              onChanged: (value) => controller.searchRegulations(value),
              onFieldSubmitted: (value) => controller.searchRegulations(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 22.sp),
                hintText: 'Search',
                hintStyle: TextStyleApp.bodyTextSmall.copyWith(fontSize: 15.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.colorPrimary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorApp.red),
                ),
              ),
            ),
          ),
          ),
          SizedBox(width: 2.5.w),
          Obx(
            () => InkWell(
              onTap: () {
                // Build dropdown items from API data
                final jenisItems = controller.jenisList
                    .map((j) => j.name)
                    .toList();
                final kategoriItems = controller.kategoriList
                    .map((k) => k.name)
                    .toList();

                BottomSheetWidget.showSimpleBottomSheet(
                  context,
                  titleText: 'Filter',
                  bottomSheetContent: Column(
                    children: [
                      DropdownFieldWidget(
                        items: jenisItems.isEmpty
                            ? const ['Memuat...']
                            : jenisItems,
                        initialItem: controller.filterJenis.value.isNotEmpty
                            ? controller.filterJenis.value
                            : null,
                        onChanged: (value) {
                          if (value != null && value != 'Memuat...') {
                            controller.filterJenis.value = value;
                          }
                        },
                        titleForm: 'Jenis Aturan',
                        hintText: 'Pilih jenis aturan',
                      ),
                      SizedBox(height: 3.h),
                      DropdownFieldWidget(
                        items: kategoriItems.isEmpty
                            ? const ['Memuat...']
                            : kategoriItems,
                        initialItem:
                            controller.filterKategori.value.isNotEmpty
                                ? controller.filterKategori.value
                                : null,
                        onChanged: (value) {
                          if (value != null && value != 'Memuat...') {
                            controller.filterKategori.value = value;
                          }
                        },
                        titleForm: 'Kategori Aturan',
                        hintText: 'Pilih kategori aturan',
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                boxShadow: [ElevationApp.elevation4pxBottom],
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
                                    style: TextStyleApp.bodyTextBold.copyWith(
                                      fontSize: 16.sp,
                                      color: ColorApp.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          InkWell(
                            onTap: () async {
                              controller.applyFilter(
                                jenis: controller.filterJenis.value,
                                kategori: controller.filterKategori.value,
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
                                boxShadow: [ElevationApp.elevation4pxBottom],
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
                                    style: TextStyleApp.bodyTextBold.copyWith(
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
