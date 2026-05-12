import 'package:cafein/controllers/power_share/cafe_room_detail_controller.dart';
import 'package:cafein/models/comment.dart';
import 'package:cafein/pages/power_share/cafe_room/post_detail_page.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CafeRoomDetailPage extends StatelessWidget {
  const CafeRoomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CafeRoomDetailController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          // ── Premium Header ──
          _buildHeader(controller),
          // ── Content ──
          Expanded(
            child: RefreshIndicator(
              color: ColorApp.colorPrimary,
              onRefresh: controller.refreshData,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerList();
                }
                if (controller.hasError.value) {
                  return _buildErrorState(controller);
                }
                if (controller.posts.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildPostList(controller);
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header with gradient, back button, room info, and follow button
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(CafeRoomDetailController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradient.menuGradient,
        boxShadow: [
          BoxShadow(
            color: ColorApp.colorPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 5.w, 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: Back + Room Name ──
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // Room icon + name
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.meeting_room_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                        SizedBox(width: 2.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.room.name,
                                style: TextStyleApp.titleText.copyWith(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                controller.room.codeIlmu,
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              // ── Info row: post count + follow button ──
              Obx(() {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      // Post count
                      Icon(
                        IconlyLight.document,
                        color: Colors.white.withOpacity(0.9),
                        size: 18.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${controller.posts.length} Postingan',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Spacer(),
                      // Follow button
                      GestureDetector(
                        onTap: controller.toggleFollow,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.2.h,
                          ),
                          decoration: BoxDecoration(
                            color: controller.isFollowing.value
                                ? Colors.white.withOpacity(0.15)
                                : const Color(0xFF4FC3F7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: controller.isFollowing.value
                                  ? Colors.white.withOpacity(0.4)
                                  : const Color(0xFF4FC3F7),
                              width: 1.5,
                            ),
                            boxShadow: controller.isFollowing.value
                                ? []
                                : [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4FC3F7,
                                      ).withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: controller.isFollowLoading.value
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      controller.isFollowing.value
                                          ? Icons.check_rounded
                                          : Icons.add_rounded,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      controller.isFollowing.value
                                          ? 'Mengikuti'
                                          : 'Ikuti',
                                      style: TextStyleApp.bodyTextBold.copyWith(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Post List
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPostList(CafeRoomDetailController controller) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      itemCount: controller.posts.length,
      itemBuilder: (context, index) {
        final post = controller.posts[index];
        return _RoomPostCard(post: post, index: index, controller: controller);
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shimmer Loading
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmer(40, 40, isCircle: true),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmer(12, 120),
                      SizedBox(height: 6),
                      _shimmer(10, 80),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              _shimmer(14, double.infinity),
              SizedBox(height: 8),
              _shimmer(12, 200),
              SizedBox(height: 8),
              _shimmer(12, 160),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmer(double height, double width, {bool isCircle = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value,
          duration: const Duration(milliseconds: 900),
          child: Container(
            height: height,
            width: isCircle ? height : width,
            decoration: BoxDecoration(
              color: ColorApp.grey.withOpacity(0.12),
              borderRadius: isCircle ? null : BorderRadius.circular(6),
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Error State
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildErrorState(CafeRoomDetailController controller) {
    return ListView(
      children: [
        SizedBox(height: 10.h),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: ColorApp.red.withOpacity(0.6),
              ),
              SizedBox(height: 2.h),
              Text(
                'Terjadi Kesalahan',
                style: TextStyleApp.bodyTextBold.copyWith(
                  color: ColorApp.black,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  'Coba Lagi',
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.colorPrimary,
                  foregroundColor: ColorApp.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Empty State
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: 12.h),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorApp.colorPrimary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.forum_outlined,
                  size: 48,
                  color: ColorApp.colorPrimary.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Belum ada pertanyaan',
                style: TextStyleApp.bodyTextBold.copyWith(
                  color: ColorApp.black,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Jadilah yang pertama bertanya\ndi ruang ini!',
                style: TextStyleApp.bodyTextSmall.copyWith(
                  color: ColorApp.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Room Post Card Widget — with Like, Comment toggle, Profile nav
// ─────────────────────────────────────────────────────────────────────────────
class _RoomPostCard extends StatelessWidget {
  const _RoomPostCard({
    required this.post,
    required this.index,
    required this.controller,
  });

  final Map<String, dynamic> post;
  final int index;
  final CafeRoomDetailController controller;

  int get _postId {
    final id = post['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Extract user data
    final user = post['user'] as Map<String, dynamic>?;
    final nickname =
        user?['nickname']?.toString() ??
        post['nickname']?.toString() ??
        'Pengguna';
    final fullname =
        user?['fullname']?.toString() ??
        post['fullname']?.toString() ??
        nickname;
    final company =
        user?['company']?.toString() ?? post['company']?.toString() ?? '';
    final initial = fullname.isNotEmpty ? fullname[0].toUpperCase() : 'P';

    final title = post['title']?.toString() ?? '';
    final description = post['description']?.toString() ?? '';
    final image = post['image']?.toString();
    final createdAt = post['created_at']?.toString();
    final idUser = post['id_user'];

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: ColorApp.colorPrimary.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar + user info (tappable → profile) ──
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.w, 4.w, 0),
            child: Row(
              children: [
                // Avatar → Profile
                GestureDetector(
                  onTap: () => _goToProfile(idUser),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorApp.colorPrimary,
                          ColorApp.colorPrimary.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.colorPrimary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: TextStyleApp.bodyTextBold.copyWith(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _goToProfile(idUser),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullname,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 14.sp,
                            color: ColorApp.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (company.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 0.2.h),
                            child: Text(
                              company,
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.grey,
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Timestamp
                if (createdAt != null)
                  Text(
                    controller.timeAgo(createdAt),
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.grey,
                      fontSize: 11.sp,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 1.2.h),

          // ── Title & Description (tappable → post detail) ──
          GestureDetector(
            onTap: () => _goToPostDetail(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      title,
                      style: TextStyleApp.bodyTextBold.copyWith(
                        fontSize: 15.sp,
                        color: ColorApp.colorSecondary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (description.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 0.5.h, 4.w, 0),
                    child: Text(
                      description,
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        fontSize: 13.sp,
                        color: ColorApp.black.withOpacity(0.75),
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          // ── Image if exists (tappable → post detail) ──
          if (image != null && image.isNotEmpty) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => _goToPostDetail(),
              child: _buildPostImage(image),
            ),
          ],

          SizedBox(height: 1.h),

          // ── Bottom action bar ──
          Obx(() {
            final postId = _postId;
            final liked = controller.isLiked[postId] ?? false;
            final likeCount = controller.likeCounts[postId] ?? 0;
            final commentCount = controller.commentCounts[postId] ?? 0;
            final isExpanded = controller.expandedComments[postId] ?? false;

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.w),
                  child: Row(
                    children: [
                      // Like button with animation
                      _LikeButton(
                        isLiked: liked,
                        count: likeCount,
                        onTap: () => controller.toggleLike(index),
                      ),
                      SizedBox(width: 5.w),
                      // Comment toggle button
                      GestureDetector(
                        onTap: () => controller.toggleComments(postId),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isExpanded
                                ? ColorApp.colorPrimary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isExpanded ? IconlyBold.chat : IconlyLight.chat,
                                color: isExpanded
                                    ? ColorApp.colorPrimary
                                    : ColorApp.grey,
                                size: 20.sp,
                              ),
                              SizedBox(width: 1.5.w),
                              Text(
                                commentCount > 0 ? '$commentCount' : 'Komentar',
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  color: isExpanded
                                      ? ColorApp.colorPrimary
                                      : ColorApp.grey,
                                  fontSize: 12.sp,
                                  fontWeight: isExpanded
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Room tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.4.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorApp.colorPrimary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tag_rounded,
                              size: 13.sp,
                              color: ColorApp.colorPrimary.withOpacity(0.7),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              controller.room.codeIlmu,
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.colorPrimary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Comments Section (toggle) ──
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? _CommentSection(postId: postId, controller: controller)
                      : const SizedBox.shrink(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _goToProfile(dynamic idUser) {
    if (idUser == null) return;
    final uid = idUser is int ? idUser : int.tryParse(idUser.toString()) ?? 0;
    if (uid > 0) {
      Get.to(() => UserProfilePage(userId: uid));
    }
  }

  void _goToPostDetail() {
    Get.to(
      () => const PostDetailPage(),
      arguments: post,
      transition: Transition.cupertino,
    );
  }

  Widget _buildPostImage(String imageName) {
    final imageUrl =
        '${AppConstants.BASE_URL}${AppConstants.API_POSTING_SHOW_IMAGE}/$imageName';
    return FutureBuilder<Map<String, String>>(
      future: PostService().getImageHeaders(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container(
            width: double.infinity,
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorApp.colorPrimary,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              headers: snap.data!,
              width: double.infinity,
              height: 22.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 22.h,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: ColorApp.colorPrimary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: ColorApp.grey,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Like Button with scale animation
// ─────────────────────────────────────────────────────────────────────────────
class _LikeButton extends StatefulWidget {
  final bool isLiked;
  final int count;
  final VoidCallback onTap;

  const _LikeButton({
    required this.isLiked,
    required this.count,
    required this.onTap,
  });

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked != oldWidget.isLiked) {
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  widget.isLiked ? IconlyBold.heart : IconlyLight.heart,
                  color: widget.isLiked
                      ? const Color(0xFFE53E3E)
                      : ColorApp.grey,
                  size: 18.sp,
                ),
              );
            },
          ),
          SizedBox(width: 1.5.w),
          Text(
            '${widget.count}',
            style: TextStyleApp.bodyTextSmall.copyWith(
              color: widget.isLiked ? const Color(0xFFE53E3E) : ColorApp.grey,
              fontSize: 9.sp,
              fontWeight: widget.isLiked ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comment Section (shown when expanded)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentSection extends StatefulWidget {
  final int postId;
  final CafeRoomDetailController controller;

  const _CommentSection({required this.postId, required this.controller});

  @override
  State<_CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  final TextEditingController _textController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_textController.text.trim().isEmpty) return;
    setState(() => _isSubmitting = true);
    final success = await widget.controller.submitComment(
      widget.postId,
      _textController.text,
    );
    if (success) {
      _textController.clear();
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Divider
          Container(height: 1, color: ColorApp.grey.withOpacity(0.1)),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Obx(() {
              final isLoading =
                  widget.controller.isLoadingComments[widget.postId] ?? false;
              final comments =
                  widget.controller.postComments[widget.postId] ?? [];

              if (isLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorApp.colorPrimary,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  if (comments.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Text(
                        'Belum ada komentar. Jadilah yang pertama!',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          color: ColorApp.grey,
                          fontSize: 9.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    // Show all comments
                    Column(
                      children: [
                        ...comments.map(
                          (comment) => _InlineCommentTile(comment: comment),
                        ),
                      ],
                    ),
                  SizedBox(height: 1.h),
                  // Inline comment input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ColorApp.grey.withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _textController,
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tulis komentar...',
                              hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.grey,
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 1.h,
                              ),
                            ),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: _isSubmitting ? null : _submit,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppGradient.menuGradient,
                            shape: BoxShape.circle,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 13.sp,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline Comment Tile (compact, inside post card)
// ─────────────────────────────────────────────────────────────────────────────
class _InlineCommentTile extends StatelessWidget {
  final Comment comment;
  const _InlineCommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final name = comment.nickname ?? comment.fullname ?? 'Pengguna';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini avatar → tappable to profile
          GestureDetector(
            onTap: () {
              if (comment.idUser > 0) {
                Get.to(() => UserProfilePage(userId: comment.idUser));
              }
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorApp.colorPrimary,
                    ColorApp.colorPrimary.withOpacity(0.6),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyleApp.bodyTextBold.copyWith(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (comment.idUser > 0) {
                        Get.to(() => UserProfilePage(userId: comment.idUser));
                      }
                    },
                    child: Text(
                      name,
                      style: TextStyleApp.bodyTextBold.copyWith(
                        fontSize: 13.sp,
                        color: ColorApp.colorSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    comment.description ?? '',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 14.sp,
                      color: ColorApp.black.withOpacity(0.75),
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
