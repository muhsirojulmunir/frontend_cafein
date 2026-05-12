import 'package:cafein/controllers/power_share/user_profile_controller.dart';
import 'package:cafein/models/post.dart';
import 'package:cafein/pages/power_share/profile/edit_credential_page.dart';
import 'package:cafein/pages/power_share/profile/account_settings_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/services/post_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatelessWidget {
  final int userId;
  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == 0) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Use Get.put or Get.find based on tag to support multiple profile instances
    final controller = Get.put(
      UserProfileController(userId),
      tag: userId.toString(),
      permanent: false,
    );

    // If the controller was already there but userId changed in a new build with the same tag (unlikely but safe)
    // or if we need to force a refresh on certain conditions

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(IconlyLight.arrowLeft, color: ColorApp.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profil',
          style: TextStyleApp.bodyTextLarge.copyWith(color: ColorApp.black),
        ),
        actions: [
          Obx(() {
            if (controller.isLoading.value || controller.userData.isEmpty)
              return const SizedBox.shrink();
            final isOwner =
                controller.currentUserId.value ==
                controller.userData['id'].toString();
            if (!isOwner) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(IconlyLight.setting, color: ColorApp.black),
              onPressed: () {
                final user = controller.userData;
                Get.to(() => AccountSettingsPage(email: user['email'] ?? ''));
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.userData;
        final employees = user['employees'];
        final displayName =
            user['account_name']?.toString() ??
            user['username']?.toString() ??
            employees?['fullname']?.toString() ??
            employees?['nickname']?.toString() ??
            'User';
        final initial = displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : 'U';
        final isOwner = controller.currentUserId.value == user['id'].toString();

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Section ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: isOwner
                                ? () => controller.pickAndUploadImage()
                                : null,
                            child: CircleAvatar(
                              radius: 38.sp,
                              backgroundColor: ColorApp.colorPrimary
                                  .withOpacity(0.1),
                              child:
                                  (user['imageava'] != null &&
                                      user['imageava'].toString().isNotEmpty)
                                  ? FutureBuilder<Map<String, String>>(
                                      future: PostService().getImageHeaders(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }
                                        return ClipOval(
                                          child: Image.network(
                                            PostService().getProfileImageUrl(
                                              user['imageava'],
                                            ),
                                            headers: snapshot.data,
                                            width: 76.sp,
                                            height: 76.sp,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Text(
                                                      initial,
                                                      style: TextStyleApp
                                                          .titleText
                                                          .copyWith(
                                                            color: ColorApp
                                                                .colorPrimary,
                                                            fontSize: 24.sp,
                                                          ),
                                                    ),
                                          ),
                                        );
                                      },
                                    )
                                  : Text(
                                      initial,
                                      style: TextStyleApp.titleText.copyWith(
                                        color: ColorApp.colorPrimary,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                            ),
                          ),
                          if (isOwner)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4.dp),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B4E6B),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: TextStyleApp.bodyTextLarge.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isOwner)
                                  GestureDetector(
                                    onTap: () => _showEditNameDialog(
                                      context,
                                      controller,
                                      displayName,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.w),
                                      child: Icon(
                                        IconlyLight.edit,
                                        size: 14.sp,
                                        color: const Color(0xFF1B4E6B),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              employees?['pinned_text'] ??
                                  employees?['company'] ??
                                  '-',
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.grey,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // ── Badges Row ──
                            if (user['badges'] != null &&
                                (user['badges'] as List).isNotEmpty)
                              _buildBadgesRow(user['badges']),
                            SizedBox(height: 1.h),
                            _buildStatsRow(controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // ── Credentials Section ──
                if (isOwner || controller.credentials.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kredensial & Sorotan',
                              style: TextStyleApp.bodyTextBold.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            if (isOwner)
                              InkWell(
                                onTap: () =>
                                    Get.to(() => const EditCredentialPage()),
                                child: Text(
                                  'Tambah Kredensial',
                                  style: TextStyleApp.bodyTextSmall.copyWith(
                                    color: const Color(0xFF1B4E6B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (isOwner) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            'Kredensial yang ditampilkan di profil Anda',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        if (controller.credentials.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          ...controller.credentials.map(
                            (cred) => Padding(
                              padding: EdgeInsets.only(bottom: 0.8.h),
                              child: Row(
                                children: [
                                  Icon(
                                    _getCredentialIcon(cred['type'] ?? 0),
                                    size: 16.sp,
                                    color: cred['is_pinned'] == true
                                        ? const Color(0xFF1B4E6B)
                                        : ColorApp.grey,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      _getFormattedCredentialText(cred),
                                      style: TextStyleApp.bodyTextSmall
                                          .copyWith(
                                            fontSize: 14.sp,
                                            fontWeight:
                                                cred['is_pinned'] == true
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: cred['is_pinned'] == true
                                                ? const Color(0xFF1B4E6B)
                                                : ColorApp.black,
                                          ),
                                    ),
                                  ),
                                  if (isOwner)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => controller.togglePin(
                                            cred['id'],
                                            cred['type'],
                                          ),
                                          child: Icon(
                                            cred['is_pinned'] == true
                                                ? Icons.push_pin
                                                : Icons.push_pin_outlined,
                                            size: 17.sp,
                                            color: cred['is_pinned'] == true
                                                ? const Color(0xFF1B4E6B)
                                                : ColorApp.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        GestureDetector(
                                          onTap: () {
                                            final typeMap = {
                                              0: 'Keahlian',
                                              1: 'Pendidikan',
                                              2: 'Lokasi',
                                              3: 'Pekerjaan',
                                              4: 'Penghargaan',
                                              5: 'Topik',
                                              6: 'Nomor Telepon',
                                            };
                                            final typeName =
                                                typeMap[cred['type']] ??
                                                'Keahlian';
                                            Get.to(
                                              () => const EditCredentialPage(),
                                              arguments: {
                                                'id': cred['id'],
                                                'type': typeName,
                                                'description':
                                                    cred['credential_name'] ??
                                                    cred['description'] ??
                                                    '',
                                                // Extra fields for Education
                                                'school': cred['school'],
                                                'primary_major':
                                                    cred['primary_major'],
                                                'strata': cred['strata'],
                                                'degree_type':
                                                    cred['degree_type'],
                                                'graduation_year':
                                                    cred['graduation_year'],
                                              },
                                            );
                                          },
                                          child: Icon(
                                            IconlyLight.edit,
                                            size: 16.sp,
                                            color: const Color(0xFF1B4E6B),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        GestureDetector(
                                          onTap: () {
                                            _showDeleteCredentialConfirmation(
                                              context,
                                              controller,
                                              cred['id'],
                                              cred['type'],
                                            );
                                          },
                                          child: Icon(
                                            IconlyLight.delete,
                                            size: 16.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ] else if (isOwner) ...[
                          SizedBox(height: 1.h),
                          Text(
                            'Tambahkan kredensial untuk membagikan keahlian atau pendidikan Anda.',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              color: ColorApp.grey,
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Divider(),
                ],

                // ── Posts & Answers Section ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.selectedTab.value = 0,
                        child: Column(
                          children: [
                            Text(
                              'Postingan',
                              style: TextStyleApp.bodyTextBold.copyWith(
                                fontSize: 13.sp,
                                color: controller.selectedTab.value == 0
                                    ? ColorApp.colorPrimary
                                    : ColorApp.grey,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              height: 3,
                              width: 25.w,
                              color: controller.selectedTab.value == 0
                                  ? ColorApp.colorPrimary
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      if (isOwner) ...[
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () => controller.selectedTab.value = 1,
                          child: Column(
                            children: [
                              Text(
                                'Jawaban',
                                style: TextStyleApp.bodyTextBold.copyWith(
                                  fontSize: 13.sp,
                                  color: controller.selectedTab.value == 1
                                      ? ColorApp.colorPrimary
                                      : ColorApp.grey,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Container(
                                height: 3,
                                width: 25.w,
                                color: controller.selectedTab.value == 1
                                    ? ColorApp.colorPrimary
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final isPost = controller.selectedTab.value == 0;
                    final listData = isPost
                        ? controller.userPosts
                        : controller.userAnswers;
                    final emptyText = isPost
                        ? 'Belum ada postingan'
                        : 'Belum ada jawaban';

                    if (listData.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Text(
                            emptyText,
                            style: TextStyleApp.bodyTextSmall,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        return _CompactPostCard(
                          post: listData[index],
                          controller: controller, // Pass controller for actions
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow(UserProfileController controller) {
    return Row(
      children: [
        _buildStatItem('Post', controller.userPosts.length),
        SizedBox(width: 6.w),
        _buildStatItem('Pengikut', controller.followerCount.value),
        SizedBox(width: 6.w),
        _buildStatItem('Mengikuti', controller.followingCount.value),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: TextStyleApp.bodyTextBold.copyWith(fontSize: 16.sp),
        ),
        Text(
          label,
          style: TextStyleApp.bodyTextSmall.copyWith(
            color: ColorApp.grey,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesRow(List badges) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Wrap(
        spacing: 3.w,
        runSpacing: 1.5.h,
        children: badges.map((badge) {
          return GestureDetector(
            onTap: () => _showBadgeDetail(badge),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium, // Ikon Medali Ahli
                    size: 18.sp,
                    color: Colors.green.shade700,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    badge['name']?.toString() ?? '',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showBadgeDetail(dynamic badge) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: ColorApp.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Icon(
              Icons.workspace_premium,
              size: 50.sp,
              color: Colors.green, // Diubah ke Hijau
            ),
            SizedBox(height: 2.h),
            Text(
              badge['name']?.toString() ?? 'Lencana',
              style: TextStyleApp.bodyTextBold.copyWith(
                fontSize: 16.sp,
                color: ColorApp.colorPrimary, // Diubah ke Biru
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              badge['description']?.toString() ??
                  'Tidak ada deskripsi untuk lencana ini.',
              textAlign: TextAlign.center,
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 13.sp, // Ukuran diperbesar dari 11.sp
                color: ColorApp.black.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.colorPrimary, // Diubah ke Biru
                  foregroundColor: ColorApp.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Tutup',
                  style: TextStyleApp.bodyTextBold.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showDeleteCredentialConfirmation(
    BuildContext context,
    UserProfileController controller,
    int credentialId,
    int type,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Kredensial', style: TextStyleApp.bodyTextBold),
        content: Text(
          'Apakah Anda yakin ingin menghapus kredensial ini?',
          style: TextStyleApp.bodyTextSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteCredential(credentialId, type);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedCredentialText(Map<String, dynamic> cred) {
    final type = cred['type'] ?? 0;
    final text = cred['description'] ?? cred['credential_name'] ?? '';

    if (text.isEmpty) return '';

    switch (type) {
      case 1: // Pendidikan
        return 'Pernah belajar di $text';
      case 2: // Lokasi
        return 'Tinggal di $text';
      case 3: // Pekerjaan
        if (text.contains(' di ')) {
          final parts = text.split(' di ');
          return 'Bekerja sebagai ${parts[0]} di ${parts.sublist(1).join(' di ')}';
        }
        return 'Bekerja sebagai $text';
      case 4: // Penghargaan
        return 'Mendapatkan penghargaan $text';
      default:
        return text;
    }
  }

  IconData _getCredentialIcon(int type) {
    switch (type) {
      case 0: // Keahlian
        return Icons.psychology_outlined;
      case 1: // Pendidikan
        return Icons.school_outlined;
      case 2: // Lokasi
        return Icons.location_on_outlined;
      case 3: // Pekerjaan
        return Icons.work_outline_rounded;
      case 4: // Kehormatan
        return Icons.emoji_events_outlined;
      case 5: // Topik
        return Icons.tag_rounded;
      case 6: // Nomor Telepon
        return Icons.phone_outlined;
      default:
        return Icons.info_outline;
    }
  }

  void _showEditNameDialog(
    BuildContext context,
    UserProfileController controller,
    String currentName,
  ) {
    final nameController = TextEditingController(text: currentName);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Ubah Nama Tampilan', style: TextStyleApp.bodyTextBold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nama ini akan muncul di postingan dan profil Anda.',
              style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.grey),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Get.back();
                controller.updateAccountName(nameController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4E6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Simpan',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactPostCard extends StatelessWidget {
  final Post post;
  final UserProfileController controller;
  const _CompactPostCard({required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOwner = controller.currentUserId.value == post.idUser.toString();

      return GestureDetector(
        onTap: () {
          Get.toNamed('/postDetail', arguments: post.toJson());
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 1.h,
          ), // Slightly reduced vertical
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: ColorApp.colorPrimary.withOpacity(
              0.05,
            ), // Matches app tone instead of plain white
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorApp.colorPrimary.withOpacity(0.1),
            ), // Subtle border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.parentNickname != null)
                          Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: ColorApp.colorPrimary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorApp.colorPrimary.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.reply_rounded,
                                  size: 14.sp,
                                  color: ColorApp.colorPrimary,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: TextStyleApp.bodyTextSmall
                                          .copyWith(
                                            fontSize: 11.sp,
                                            color: ColorApp.black.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                      children: [
                                        const TextSpan(text: 'Membalas '),
                                        TextSpan(
                                          text: '@${post.parentNickname}',
                                          style: TextStyleApp.bodyTextBold
                                              .copyWith(
                                                fontSize: 11.sp,
                                                color: ColorApp.colorPrimary,
                                              ),
                                        ),
                                        if (post.parentTitle != null &&
                                            post.parentTitle!.isNotEmpty) ...[
                                          const TextSpan(text: ' di '),
                                          TextSpan(
                                            text: '"${post.parentTitle}"',
                                            style: TextStyleApp.bodyTextSmall
                                                .copyWith(
                                                  fontSize: 11.sp,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                        ] else if (post.parentDescription !=
                                                null &&
                                            post
                                                .parentDescription!
                                                .isNotEmpty) ...[
                                          const TextSpan(text: ' di '),
                                          TextSpan(
                                            text:
                                                post.parentDescription!.length >
                                                    30
                                                ? '"${post.parentDescription!.substring(0, 30)}..."'
                                                : '"${post.parentDescription}"',
                                            style: TextStyleApp.bodyTextSmall
                                                .copyWith(
                                                  fontSize: 11.sp,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (post.title != null)
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  post.title!,
                                  style: TextStyleApp.bodyTextBold.copyWith(
                                    fontSize: 15.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (post.badges != null &&
                                  post.badges!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(left: 1.w),
                                  child: Icon(
                                    Icons.emoji_events,
                                    size: 12.sp,
                                    color: const Color(0xFFD4AF37),
                                  ),
                                ),
                            ],
                          ),
                        if (post.knowFieldName != null)
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.5.w,
                              vertical: 0.4.h,
                            ),
                            decoration: BoxDecoration(
                              color: ColorApp.colorPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              post.knowFieldName!,
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.colorPrimary,
                                fontSize: 10.sp, // Increased from 9.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(height: 0.2.h),
                      ],
                    ),
                  ),
                  if (isOwner)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz,
                        color: ColorApp.grey,
                        size: 20.sp,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.toNamed('/edit-post', arguments: post);
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                IconlyLight.edit,
                                size: 18.sp,
                                color: ColorApp.black,
                              ),
                              SizedBox(width: 3.w),
                              Text('Ubah', style: TextStyleApp.bodyTextSmall),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                IconlyLight.delete,
                                size: 18.sp,
                                color: Colors.red,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Hapus',
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Text(
                post.description,
                style: TextStyleApp.bodyTextSmall.copyWith(
                  fontSize: 13.sp, // Increased from 11.sp to adjust with title
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (post.image != null && post.image!.isNotEmpty) ...[
                SizedBox(height: 1.5.h),
                FutureBuilder<Map<String, String>>(
                  future: PostService().getImageHeaders(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: double.infinity,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final String imageUrl = PostService().getImageUrl(
                      post.image!,
                    );
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        headers: snapshot.data,
                        width: double.infinity,
                        height: 20.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
              ],
              SizedBox(height: 1.h), // Slightly reduced from 1.5.h
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        IconlyLight.heart,
                        size: 13.sp,
                        color: ColorApp.grey,
                      ),
                      SizedBox(width: 1.5.w),
                      Text(
                        '${post.upvote}',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 10.sp,
                          color: ColorApp.grey,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(IconlyLight.chat, size: 13.sp, color: ColorApp.grey),
                    ],
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(post.createdAt),
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 10.sp,
                      color: ColorApp.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Postingan', style: TextStyleApp.bodyTextBold),
        content: Text(
          'Apakah Anda yakin ingin menghapus postingan ini?',
          style: TextStyleApp.bodyTextSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deletePost(post.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: TextStyleApp.bodyTextSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
