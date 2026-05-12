import 'package:cafein/controllers/power_share/post_detail_controller.dart';
import 'package:cafein/models/comment.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostDetailController());

    final post = controller.post;
    final user = post['user'] as Map<String, dynamic>?;
    final displayName =
        user?['username']?.toString() ??
        post['username']?.toString() ??
        user?['fullname']?.toString() ??
        post['fullname']?.toString() ??
        'Pengguna';
    final company =
        user?['company']?.toString() ?? post['company']?.toString() ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P';
    final title = post['title']?.toString() ?? '';
    final description = post['description']?.toString() ?? '';
    final image = post['image']?.toString();
    final createdAt = post['created_at']?.toString();
    final idUser = post['id_user'];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          // ── Header ──
          _buildHeader(
            controller,
            displayName,
            initial,
            company,
            createdAt,
            idUser,
          ),
          // ── Content ──
          Expanded(
            child: Obx(() {
              return ListView(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                children: [
                  // ── Post Content Card ──
                  _buildPostContent(controller, title, description, image),
                  SizedBox(height: 1.5.h),
                  // ── Action Bar ──
                  _buildActionBar(controller),
                  SizedBox(height: 2.h),
                  // ── Comments Section ──
                  _buildCommentsHeader(controller),
                  SizedBox(height: 1.h),
                  if (controller.isLoadingComments.value)
                    _buildCommentShimmer()
                  else if (controller.comments.isEmpty)
                    _buildNoComments()
                  else
                    ...controller.comments.map(
                      (comment) => _CommentTile(
                        comment: comment,
                        controller: controller,
                        depth: 0,
                      ),
                    ),
                  SizedBox(height: 10.h),
                ],
              );
            }),
          ),
          // ── Comment Input ──
          _buildCommentInput(controller),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(
    PostDetailController controller,
    String displayName,
    String initial,
    String company,
    String? createdAt,
    dynamic idUser,
  ) {
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
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // User info — tappable to profile
              GestureDetector(
                onTap: () {
                  final uid = _safeInt(idUser);
                  if (uid > 0) {
                    Get.to(() => UserProfilePage(userId: uid));
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        if (createdAt != null)
                          Text(
                            controller.timeAgo(createdAt),
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Post Content ──
  Widget _buildPostContent(
    PostDetailController controller,
    String title,
    String description,
    String? image,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyleApp.bodyTextBold.copyWith(
                fontSize: 16.sp,
                color: ColorApp.colorSecondary,
                height: 1.4,
              ),
            ),
          if (title.isNotEmpty && description.isNotEmpty) SizedBox(height: 1.h),
          if (description.isNotEmpty)
            Text(
              description,
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 13.sp,
                color: ColorApp.black.withOpacity(0.8),
                height: 1.6,
              ),
            ),
          if (image != null && image.isNotEmpty) ...[
            SizedBox(height: 1.5.h),
            _buildPostImage(image),
          ],
        ],
      ),
    );
  }

  // ── Action Bar ──
  Widget _buildActionBar(PostDetailController controller) {
    return Obx(() {
      final liked = controller.isLiked.value;
      final count = controller.likeCount.value;
      final commentCount = controller.commentCount.value;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Like button
            _ActionButton(
              icon: liked ? IconlyBold.heart : IconlyLight.heart,
              label: '$count',
              color: liked ? const Color(0xFFE53E3E) : ColorApp.grey,
              onTap: controller.toggleLike,
            ),
            SizedBox(width: 6.w),
            // Comment count
            _ActionButton(
              icon: IconlyLight.chat,
              label: '$commentCount Komentar',
              color: ColorApp.colorPrimary,
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }

  // ── Comments Header ──
  Widget _buildCommentsHeader(PostDetailController controller) {
    return Obx(
      () => Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: ColorApp.colorPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'Komentar (${controller.commentCount.value})',
            style: TextStyleApp.bodyTextBold.copyWith(
              fontSize: 14.sp,
              color: ColorApp.colorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoComments() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              IconlyLight.chat,
              size: 36,
              color: ColorApp.grey.withOpacity(0.4),
            ),
            SizedBox(height: 1.h),
            Text(
              'Belum ada komentar',
              style: TextStyleApp.bodyTextSmall.copyWith(
                color: ColorApp.grey,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Jadilah yang pertama berkomentar!',
              style: TextStyleApp.bodyTextSmall.copyWith(
                color: ColorApp.grey.withOpacity(0.6),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentShimmer() {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ColorApp.grey.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: ColorApp.grey.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorApp.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Comment Input ──
  Widget _buildCommentInput(PostDetailController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Obx(() {
              final replyingTo = controller.replyingTo.value;
              if (replyingTo == null) return const SizedBox.shrink();
              final replyName =
                  replyingTo.nickname ??
                  replyingTo.fullname ??
                  replyingTo.username ??
                  'Pengguna';
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                color: ColorApp.colorPrimary.withOpacity(0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Membalas @$replyName',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          color: ColorApp.colorPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.cancelReply,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: ColorApp.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: controller.commentController,
                        focusNode: controller.commentFocusNode,
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
                          contentPadding: EdgeInsets.symmetric(vertical: 1.2.h),
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isSubmitting.value
                          ? null
                          : controller.submitComment,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppGradient.menuGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorApp.colorPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            height: 22.h,
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
        return GestureDetector(
          onTap: () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                    InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4,
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                          child: Image.network(
                            imageUrl,
                            headers: snap.data!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              headers: snap.data!,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.cover,
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

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 1.5.w),
          Text(
            label,
            style: TextStyleApp.bodyTextSmall.copyWith(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comment Tile — Two styles: Single & Multi (threaded)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final Comment comment;
  final PostDetailController controller;
  final int depth;

  const _CommentTile({
    required this.comment,
    required this.controller,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    final hasReplies = comment.repliedData.isNotEmpty;
    final isReply = depth > 0;

    // ── Reply (nested) style ──
    if (isReply) {
      return _buildReplyTile(context);
    }

    // ── Top-level: Single vs Multi ──
    if (hasReplies) {
      return _buildMultiComment(context);
    } else {
      return _buildSingleComment(context);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SINGLE COMMENT — Clean standalone card
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSingleComment(BuildContext context) {
    final initial = _getInitial();
    final name = _getName();

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(initial, 36),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + time row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _goToProfile(),
                        child: Text(
                          name,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 14.sp,
                            color: ColorApp.colorSecondary,
                          ),
                        ),
                      ),
                    ),
                    if (comment.createdAt != null)
                      Text(
                        controller.timeAgoFromDateTime(comment.createdAt),
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          color: ColorApp.grey,
                          fontSize: 11.sp,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                // Comment text
                Text(
                  comment.description ?? '',
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    fontSize: 14.sp,
                    color: ColorApp.black.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 0.6.h),
                // Reply button
                GestureDetector(
                  onTap: () => controller.setReplyTo(comment),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 13.sp,
                        color: ColorApp.grey,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Balas',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          color: ColorApp.grey,
                          fontWeight: FontWeight.w600,
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
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MULTI COMMENT — Parent card + threaded replies below
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMultiComment(BuildContext context) {
    final initial = _getInitial();
    final name = _getName();

    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          // ── Parent comment ──
          Padding(
            padding: EdgeInsets.all(3.5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(initial, 36),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _goToProfile(),
                              child: Text(
                                name,
                                style: TextStyleApp.bodyTextBold.copyWith(
                                  fontSize: 14.sp,
                                  color: ColorApp.colorSecondary,
                                ),
                              ),
                            ),
                          ),
                          if (comment.createdAt != null)
                            Text(
                              controller.timeAgoFromDateTime(comment.createdAt),
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.grey,
                                fontSize: 11.sp,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.4.h),
                      Text(
                        comment.description ?? '',
                        style: TextStyleApp.bodyTextSmall.copyWith(
                          fontSize: 14.sp,
                          color: ColorApp.black.withOpacity(0.85),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 0.6.h),
                      GestureDetector(
                        onTap: () => controller.setReplyTo(comment),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.reply_rounded,
                              size: 13.sp,
                              color: ColorApp.grey,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Balas',
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                fontSize: 12.sp,
                                color: ColorApp.grey,
                                fontWeight: FontWeight.w600,
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
          ),
          // ── Divider ──
          Divider(height: 1, color: ColorApp.grey.withOpacity(0.12)),
          // ── Replies section ──
          Container(
            padding: EdgeInsets.fromLTRB(3.5.w, 1.h, 3.5.w, 1.5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Replies count label
                Padding(
                  padding: EdgeInsets.only(bottom: 0.8.h),
                  child: Text(
                    '${comment.repliedData.length} balasan',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 12.sp,
                      color: ColorApp.colorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...comment.repliedData.map(
                  (reply) => _CommentTile(
                    comment: reply,
                    controller: controller,
                    depth: depth + 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPLY TILE — Nested reply inside a multi comment
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildReplyTile(BuildContext context) {
    final initial = _getInitial();
    final name = _getName();

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical thread line
              Container(
                width: 2,
                margin: EdgeInsets.only(left: 4.w, right: 2.5.w),
                decoration: BoxDecoration(
                  color: ColorApp.colorPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              // Reply content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAvatar(initial, 28),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + reply indicator + time
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _goToProfile(),
                                    child: Text(
                                      name,
                                      style: TextStyleApp.bodyTextBold.copyWith(
                                        fontSize: 13.sp,
                                        color: ColorApp.colorSecondary,
                                      ),
                                    ),
                                  ),
                                  if (comment.toAnswerPosting != null) ...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 9.sp,
                                        color: ColorApp.grey.withOpacity(0.6),
                                      ),
                                    ),
                                    Text(
                                      '${comment.toAnswerPosting}',
                                      style: TextStyleApp.bodyTextSmall.copyWith(
                                        fontSize: 10.sp,
                                        color: ColorApp.colorPrimary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                  const Spacer(),
                                  if (comment.createdAt != null)
                                    Text(
                                      controller.timeAgoFromDateTime(comment.createdAt),
                                      style: TextStyleApp.bodyTextSmall.copyWith(
                                        color: ColorApp.grey,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 0.3.h),
                              // Reply text
                              Text(
                                comment.description ?? '',
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  fontSize: 14.sp,
                                  color: ColorApp.black.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              // Reply button
                              GestureDetector(
                                onTap: () => controller.setReplyTo(comment),
                                child: Text(
                                  'Balas',
                                  style: TextStyleApp.bodyTextSmall.copyWith(
                                    fontSize: 12.sp,
                                    color: ColorApp.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.8.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Sub-replies (rendered outside the content row to keep them flat)
        if (comment.repliedData.isNotEmpty)
          Column(
            children: comment.repliedData.map(
              (reply) => _CommentTile(
                comment: reply,
                controller: controller,
                depth: 1, // Keep depth 1 to stay flat
              ),
            ).toList(),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════════════════════
  String _getInitial() {
    return (comment.nickname ?? comment.fullname ?? 'P')
        .characters
        .first
        .toUpperCase();
  }

  String _getName() {
    return comment.username ?? comment.fullname ?? comment.nickname ?? 'Pengguna';
  }

  void _goToProfile() {
    if (comment.idUser > 0) {
      Get.to(() => UserProfilePage(userId: comment.idUser));
    }
  }

  Widget _buildAvatar(String initial, double size) {
    return GestureDetector(
      onTap: () => _goToProfile(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorApp.colorPrimary.withOpacity(0.8),
              ColorApp.colorPrimary.withOpacity(0.5),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyleApp.bodyTextBold.copyWith(
              color: Colors.white,
              fontSize: (size * 0.35).sp,
            ),
          ),
        ),
      ),
    );
  }
}
