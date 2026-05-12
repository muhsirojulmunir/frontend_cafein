import 'package:cafein/controllers/media/media_controller.dart';
import 'package:cafein/models/media_model.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MediaItemListWidget extends StatelessWidget {
  const MediaItemListWidget({
    super.key,
    required this.controller,
    required this.data,
    required this.originalIndex,
  });

  final MediaController controller;
  final MediaModel data;
  final int originalIndex;

  @override
  Widget build(BuildContext context) {
    final bool isBookmarked = controller.isBookmarked(data.id);

    return Container(
      margin: EdgeInsets.only(bottom: 0.5.h),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [ElevationApp.elevation4pxBottom],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Left accent bar (navy blue) ──
              Container(width: 1.5.w, color: ColorApp.colorPrimary),

              // ── Content ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Judul ──
                      Text(
                        data.namaMedia,
                        style: TextStyleApp.bodyTextBold.copyWith(
                          fontSize: 14.sp,
                          color: ColorApp.colorPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // ── Headline ──
                      if (data.headline != null && data.headline!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: Text(
                            data.headline!,
                            style: TextStyleApp.bodyTextBold.copyWith(
                              fontSize: 13.sp,
                              color: ColorApp.colorPrimary,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      SizedBox(height: 1.h),

                      // ── Chip Volume & Tahun ──
                      Row(
                        children: [
                          if (data.noVolume != null &&
                              data.noVolume!.isNotEmpty)
                            _buildVolumeChip('Vol. ${data.noVolume}'),
                          if (data.noVolume != null &&
                              data.noVolume!.isNotEmpty)
                            SizedBox(width: 2.w),
                          if (data.tahun != null && data.tahun!.isNotEmpty)
                            _buildYearChip(data.tahun!),
                        ],
                      ),
                      SizedBox(height: 1.5.h),

                      // ── Gambar cover dari API (network) ──
                      if (data.coverUrl.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    InteractiveViewer(
                                      panEnabled: true,
                                      minScale: 0.5,
                                      maxScale: 2.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          data.coverUrl,
                                          fit: BoxFit.contain,
                                          width: 85.w,
                                          height: 50.h,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              data.coverUrl,
                              height: 16.h,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                height: 10.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorApp.colorPrimary.withAlpha(15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 30.sp,
                                  color: ColorApp.grey,
                                ),
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      height: 16.h,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ),
                      if (data.coverUrl.isEmpty)
                        Container(
                          height: 10.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorApp.colorPrimary.withAlpha(15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            size: 30.sp,
                            color: ColorApp.grey,
                          ),
                        ),
                      SizedBox(height: 1.5.h),

                      // ── Divider ──
                      Divider(
                        color: ColorApp.grey.withAlpha(50),
                        height: 1,
                        thickness: 1,
                      ),
                      SizedBox(height: 1.h),

                      // ── Action buttons: Download, Lihat, Bookmark ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.download_rounded,
                            label: 'Download',
                            color: ColorApp.colorPrimary,
                            onTap: () => controller.downloadMedia(data.id),
                          ),
                          _verticalDivider(),
                          _buildActionButton(
                            icon: Icons.visibility_rounded,
                            label: 'Lihat',
                            color: ColorApp.green,
                            onTap: () => controller.viewMedia(data.id),
                          ),
                          _verticalDivider(),
                          _buildActionButton(
                            icon: isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            label: 'Bookmark',
                            color: isBookmarked
                                ? const Color(0xFFF57C00)
                                : ColorApp.grey,
                            onTap: () => controller.toggleBookmark(data.id),
                          ),
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
  }

  // ── Chip Volume (HIJAU seperti chip jenis di Regulasi) ──
  Widget _buildVolumeChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: ColorApp.green.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorApp.green.withAlpha(80), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.library_books_rounded, size: 13.sp, color: ColorApp.green),
          SizedBox(width: 1.5.w),
          Text(
            label,
            style: TextStyleApp.bodyTextSmallBold.copyWith(
              fontSize: 12.sp,
              color: ColorApp.green,
            ),
          ),
        ],
      ),
    );
  }

  // ── Chip Tahun (BIRU seperti chip kategori di Regulasi) ──
  Widget _buildYearChip(String year) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: ColorApp.colorPrimary.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorApp.colorPrimary.withAlpha(60),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 13.sp,
            color: ColorApp.colorPrimary,
          ),
          SizedBox(width: 1.5.w),
          Text(
            'Tahun: $year',
            style: TextStyleApp.bodyTextSmallBold.copyWith(
              fontSize: 12.sp,
              color: ColorApp.colorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Action button (icon + label) — sama seperti Regulasi ──
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
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Vertical divider antara action buttons ──
  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 3.5.h,
      color: ColorApp.grey.withAlpha(50),
    );
  }
}
