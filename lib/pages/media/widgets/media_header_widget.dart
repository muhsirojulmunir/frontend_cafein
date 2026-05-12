import 'package:cafein/controllers/media/media_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MediaHeaderWidget extends StatelessWidget {
  const MediaHeaderWidget({super.key, required this.controller});
  final MediaController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorApp.colorPrimary, ColorApp.colorPrimary.withAlpha(180)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [ElevationApp.elevation4pxBottom],
      ),
      child: Column(
        children: [
          // ── Bookmark icon di kanan atas ──
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.bookmark_rounded,
              color: ColorApp.white,
              size: 20.sp,
            ),
          ),

          // ── Judul ──
          Text(
            'Media',
            style: TextStyleApp.bodyTextLarge.copyWith(
              fontSize: 17.sp,
              color: ColorApp.white,
            ),
          ),
          SizedBox(height: 1.5.h),

          // ── Gambar ilustrasi ──
          Image.asset(
            appImages.imgMedia.path,
            height: 10.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 2.h),

          // ── Search bar + Filter ──
          Row(
            children: [
              // Search field
              Expanded(
                child: Container(
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    onChanged: (value) => controller.searchMedia(value),
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 14.sp,
                      color: ColorApp.black.withAlpha(150),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20.sp,
                        color: ColorApp.grey,
                      ),
                      hintText: 'Cari...',
                      hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                        fontSize: 14.sp,
                        color: ColorApp.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorApp.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),

              // Search icon button
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: ColorApp.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorApp.white.withAlpha(80)),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: ColorApp.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 2.w),

              // Filter icon button
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: ColorApp.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorApp.white.withAlpha(80)),
                ),
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: ColorApp.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
