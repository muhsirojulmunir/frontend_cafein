import 'package:cafein/controllers/regulation/regulation_controller.dart';
import 'package:cafein/models/aturan_model.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegulationItemListWidget extends StatelessWidget {
  const RegulationItemListWidget({
    super.key,
    required this.controller,
    required this.data,
    required this.originalIndex,
  });

  final RegulationController controller;
  final AturanModel data;
  final int originalIndex;

  @override
  Widget build(BuildContext context) {
    final bool isBookmarked = controller.isBookmarked(data.id);

    // Build title: e.g. "UU No. 26 Tahun 2007" or just shortDesc
    final String title = _buildTitle();
    final String subtitle = data.shortDesc;
    final String type = data.namaJenis;
    final String category = data.namaKategori.join(', ');

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
                      // ── Judul regulasi ──
                      Text(
                        title,
                        style: TextStyleApp.bodyTextBold.copyWith(
                          fontSize: 15.sp,
                          color: ColorApp.colorPrimary,
                        ),
                      ),
                      SizedBox(height: 0.5.h),

                      // ── Subtitle / deskripsi ──
                      Text(
                        subtitle,
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.5.h),

                      // ── Chips: Jenis + Kategori ──
                      Row(
                        children: [
                          _buildTypeChip(type),
                          SizedBox(width: 2.w),
                          if (category.isNotEmpty)
                            Flexible(child: _buildCategoryChip(category)),
                          const Spacer(),
                          _buildStatusBadge(data.status),
                        ],
                      ),
                      SizedBox(height: 1.5.h),

                      // ── Divider ──
                      Divider(
                        color: ColorApp.grey.withAlpha(50),
                        height: 1,
                        thickness: 1,
                      ),
                      SizedBox(height: 1.h),

                      // ── Action buttons: Download, Lihat, Hirarki, Bookmark ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionButton(
                            icon: Icons.download_rounded,
                            label: 'Download',
                            color: ColorApp.colorPrimary,
                            onTap: () => controller.downloadPdf(data.id),
                          ),
                          _verticalDivider(),
                          _buildActionButton(
                            icon: Icons.visibility_rounded,
                            label: 'Lihat',
                            color: ColorApp.green,
                            onTap: () => controller.viewPdf(data.id),
                          ),
                          _verticalDivider(),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _buildActionButton(
                                icon: Icons.account_tree_rounded,
                                label: 'Hirarki',
                                color: Colors.blueAccent,
                                onTap: () =>
                                    _showHierarchy(context, isBookmarked),
                              ),
                              if (controller.subBookmarkedKeys.any(
                                (k) => k.startsWith("${data.id}_"),
                              ))
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF57C00),
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 1.5.w,
                                      minHeight: 1.5.w,
                                    ),
                                  ),
                                ),
                            ],
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

  void _showHierarchy(BuildContext context, bool isBookmarked) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: ColorApp.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
              child: Obx(
                () => ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 12.w,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hirarki Regulasi',
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: isBookmarked
                                ? const Color(0xFFF57C00)
                                : Colors.grey,
                            size: 22.sp,
                          ),
                          onPressed: () {
                            controller.toggleBookmark(data.id);
                            Navigator.pop(context);
                            final bool newBookmarkStatus = !isBookmarked;
                            _showHierarchy(
                              context,
                              newBookmarkStatus,
                            ); // Refresh modal with new status
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(height: 1.h),
                    _buildHierarchyItem('Regulasi', _buildTitle()),
                    _buildHierarchyItem(
                      'Kategori',
                      data.namaKategori.join(', '),
                    ),
                    _buildHierarchyItem('Status', data.status, isStatus: true),
                    const SizedBox(height: 15),
                    _buildHierarchyGroup(
                      'Aturan diatasnya (Parent)',
                      data.parentData,
                      'parent',
                    ),
                    const SizedBox(height: 15),
                    _buildHierarchyGroup(
                      'Aturan dibawahnya (Child)',
                      data.childData,
                      'child',
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHierarchyItem(
    String label,
    String value, {
    bool isStatus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              label,
              style: TextStyleApp.bodyTextSmallBold.copyWith(fontSize: 14.sp),
            ),
          ),
          Text(
            ' : ',
            style: TextStyleApp.bodyTextSmallBold.copyWith(fontSize: 14.sp),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isStatus
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusBadge(value),
                  )
                : Text(
                    value,
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, {bool isSmall = false}) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'berlaku':
        color = const Color(0xFF2E7D32); // Deep Green
        icon = Icons.check_circle_rounded;
        break;
      case 'diubah':
        color = const Color(0xFF1976D2); // Blue
        icon = Icons.edit_note_rounded;
        break;
      case 'dicabut':
        color = const Color(0xFFC62828); // Red
        icon = Icons.cancel_rounded;
        break;
      case 'tidak berlaku':
        color = Colors.grey[700]!;
        icon = Icons.info_rounded;
        break;
      case 'dibatalkan':
        color = Colors.orange[800]!;
        icon = Icons.error_rounded;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 11,
        vertical: isSmall ? 4 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmall ? 15.sp : 13.sp, color: color),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyleApp.bodyTextSmallBold.copyWith(
              color: color,
              fontSize: isSmall ? 11.sp : 11.sp,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchyGroup(String title, List<dynamic> items, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ColorApp.colorPrimary.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyleApp.bodyTextSmallBold.copyWith(
              color: ColorApp.colorPrimary,
              fontSize: 13.sp,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '- Tidak ada data -',
              style: TextStyleApp.bodyTextSmall.copyWith(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
          )
        else
          ...items.asMap().entries.map((entry) {
            final int index = entry.key;
            final dynamic item = entry.value;

            final String jenisName = item['jenis_name'] ?? 'Regulasi';
            final String nomor = item['nomor'] ?? '-';
            final String tahun = item['tahun'] ?? '-';
            final String tentang = item['tentang'] ?? '-';
            final String status = item['status'] ?? 'Berlaku';
            final String? filename = item['doc'];

            // Unique key for sub-item bookmarking: "mainId_parent_0"
            final String subKey = "${data.id}_${type}_$index";
            final bool isSubBookmarked = controller.isSubBookmarked(subKey);

            return Container(
              margin: const EdgeInsets.only(left: 12, bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: ColorApp.colorPrimary.withAlpha(120),
                    width: 4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '$jenisName No. $nomor Tahun $tahun',
                                style: TextStyleApp.bodyTextBold.copyWith(
                                  fontSize: 16.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildStatusBadge(status, isSmall: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tentang,
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filename != null && filename.isNotEmpty) ...[
                        _buildSmallActionButton(
                          icon: Icons.visibility_rounded,
                          color: ColorApp.green,
                          onTap: () => controller.viewSubPdf(filename),
                        ),
                        SizedBox(width: 2.w),
                        _buildSmallActionButton(
                          icon: Icons.download_rounded,
                          color: ColorApp.colorPrimary,
                          onTap: () => controller.downloadSubPdf(filename),
                        ),
                        SizedBox(width: 2.w),
                      ],
                      _buildSmallActionButton(
                        icon: isSubBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isSubBookmarked
                            ? const Color(0xFFF57C00)
                            : Colors.grey,
                        onTap: () {
                          controller.toggleSubBookmark(subKey);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20.sp, color: color),
      ),
    );
  }

  String _buildTitle() {
    final parts = <String>[];
    if (data.namaJenis.isNotEmpty) parts.add(data.namaJenis);
    if (data.nomor != null && data.nomor!.isNotEmpty) {
      parts.add('No. ${data.nomor}');
    }
    if (data.tahun != null && data.tahun!.isNotEmpty) {
      parts.add('Tahun ${data.tahun}');
    }
    return parts.isNotEmpty ? parts.join(' ') : data.shortDesc;
  }

  // ───────────────────────────────────────────────
  // Chip: Jenis Aturan — warna HIJAU
  // ───────────────────────────────────────────────
  Widget _buildTypeChip(String type) {
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
          Icon(Icons.gavel_rounded, size: 13.sp, color: ColorApp.green),
          SizedBox(width: 1.5.w),
          Text(
            type,
            style: TextStyleApp.bodyTextSmallBold.copyWith(
              fontSize: 12.sp,
              color: ColorApp.green,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Chip: Kategori — warna BIRU dengan label "Kategori:"
  // ───────────────────────────────────────────────
  Widget _buildCategoryChip(String category) {
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
            Icons.category_rounded,
            size: 13.sp,
            color: ColorApp.colorPrimary,
          ),
          SizedBox(width: 1.5.w),
          Text(
            'Kategori: ',
            style: TextStyleApp.bodyTextSmall.copyWith(
              fontSize: 11.sp,
              color: ColorApp.colorPrimary,
            ),
          ),
          Flexible(
            child: Text(
              category,
              style: TextStyleApp.bodyTextSmallBold.copyWith(
                fontSize: 12.sp,
                color: ColorApp.colorPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Action button (Download / Lihat / Bookmark)
  // ───────────────────────────────────────────────
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

  // ───────────────────────────────────────────────
  // Vertical divider between action buttons
  // ───────────────────────────────────────────────
  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 3.5.h,
      color: ColorApp.grey.withAlpha(50),
    );
  }
}
