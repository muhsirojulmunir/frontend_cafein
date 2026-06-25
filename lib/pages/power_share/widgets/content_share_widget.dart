import 'package:cafein/controllers/power_share/share_controller.dart';
import 'package:cafein/controllers/power_share/follow_controller.dart';
import 'package:cafein/models/comment.dart';
import 'package:cafein/models/post.dart';
import 'package:cafein/models/cafe_room.dart';
import 'package:cafein/services/comment_service.dart';
import 'package:cafein/services/post_service.dart';
import 'package:cafein/pages/power_share/widgets/instagram_caption_widget.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cafein/routes/page_names.dart';

/// Shared feed list widget for Beranda and Mengikuti tabs.
/// [isHome] = true  → reads from ShareController
/// [isHome] = false → reads from FollowController
class ContentShareWidget extends StatelessWidget {
  const ContentShareWidget({super.key, required this.isHome});
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    if (isHome) {
      return _buildWithShareController();
    } else {
      return _buildWithFollowController();
    }
  }

  // ── Beranda ──
  Widget _buildWithShareController() {
    final controller = Get.find<ShareController>();
    return Obx(() {
      final postList = controller.posts;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postList.length + (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= postList.length) {
            return _buildLoadingMoreIndicator();
          }
          return _PostCard(post: postList[index], index: index, isHome: true);
        },
      );
    });
  }

  // ── Mengikuti ──
  Widget _buildWithFollowController() {
    final controller = Get.find<FollowController>();
    return Obx(() {
      final postList = controller.posts;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postList.length + (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= postList.length) {
            return _buildLoadingMoreIndicator();
          }
          return _PostCard(post: postList[index], index: index, isHome: false);
        },
      );
    });
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: ColorApp.colorPrimary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Post Card Widget
// ─────────────────────────────────────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.index,
    required this.isHome,
  });

  final Post post;
  final int index;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: ColorApp.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar, name, company, follow ──
          _buildHeader(context),
          // ── Image (if exists) ──
          if (post.image != null && post.image!.isNotEmpty) _buildImage(),
          SizedBox(height: 1.h),
          // ── Caption (Title & Description) ──
          if (post.title != null || post.description.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: InstagramCaption(
                username:
                    post.accountName ??
                    post.username ??
                    post.nickname ??
                    post.fullname ??
                    'User',
                caption:
                    '${post.title != null ? '${post.title}\n' : ''}${post.description}',
                maxLines: 5, // Increased for better readability
              ),
            ),
          SizedBox(height: 1.5.h),
          // ── Action bar: Like, Comment, Share (Sekarang di bawah postingan) ──
          _buildActionBar(context),
          // ── Like counts ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '${post.upvote} suka',
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorApp.black,
                fontSize: 10.sp,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          // ── Timestamp ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              _timeAgo(post.createdAt),
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 12.sp, // Meningkat agar jelas
                color: ColorApp.grey.withOpacity(0.9), // Lebih gelap
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final displayName =
        post.accountName ??
        post.username ??
        post.nickname ??
        post.fullname ??
        'User';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => Get.to(() => UserProfilePage(userId: post.idUser)),
            child: CircleAvatar(
              radius: 24, // Increased from 20
              backgroundColor: ColorApp.colorPrimary.withOpacity(0.15),
              child: Text(
                initial,
                style: TextStyleApp.bodyTextBold.copyWith(
                  color: ColorApp.colorPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Name + company + Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () =>
                            Get.to(() => UserProfilePage(userId: post.idUser)),
                        child: Text(
                          displayName,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 15.sp, // Ukuran lebih besar dan gagah
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Tombol Ikuti
                    GestureDetector(
                      onTap: () {
                        if (isHome) {
                          Get.find<ShareController>().toggleFollow(index);
                        } else {
                          Get.find<FollowController>().toggleFollow(index);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: post.followStatus == 1
                              ? Colors.transparent
                              : ColorApp.colorPrimary,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: post.followStatus == 1
                                ? ColorApp.grey.withOpacity(0.4)
                                : ColorApp.colorPrimary,
                          ),
                        ),
                        child: Text(
                          post.followStatus == 1 ? 'Mengikuti' : 'Ikuti',
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            color: post.followStatus == 1
                                ? ColorApp.grey
                                : ColorApp.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                // ── Badges Section ──
                if (post.badges != null && post.badges!.isNotEmpty)
                  _buildBadgesRow(post.badges!),

                if ((post.pinnedText != null && post.pinnedText!.isNotEmpty) ||
                    (post.company != null && post.company!.isNotEmpty))
                  Text(
                    post.pinnedText ?? post.company!,
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.grey, // Warna solid agar terbaca
                      fontSize: 13.sp, // Meningkat agar jelas
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                // ── Cafe Room Tag ──
                if (post.knowFieldName != null &&
                    post.knowFieldName!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: GestureDetector(
                      onTap: () {
                        if (post.knowFieldCode != null &&
                            post.idKnowField != null) {
                          final room = CafeRoom(
                            id: int.tryParse(post.idKnowField!) ?? 0,
                            codeIlmu: post.knowFieldCode!,
                            name: post.knowFieldName!,
                          );
                          Get.toNamed(PageName.cafeRoomDetail, arguments: room);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorApp.colorPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorApp.colorPrimary.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.meeting_room_rounded,
                              size: 13.sp, // Ukuran ikon diperbesar
                              color: ColorApp.colorPrimary,
                            ),
                            SizedBox(width: 1.5.w),
                            Text(
                              post.knowFieldName!,
                              style: TextStyleApp.bodyTextSmall.copyWith(
                                color: ColorApp.colorPrimary,
                                fontSize: 11.sp, // Ukuran teks diperbesar
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // More options (Delete)
          _buildMoreOptions(context),
        ],
      ),
    );
  }

  Widget _buildBadgesRow(List badges) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Wrap(
        spacing: 2.w,
        runSpacing: 0.6.h,
        children: badges.map((badge) {
          return GestureDetector(
            onTap: () => _showBadgeDetail(badge),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium, // Ikon Medali Ahli
                    size: 13.sp,
                    color: Colors.green.shade700,
                  ),
                  SizedBox(width: 1.5.w),
                  Text(
                    badge['name']?.toString() ?? '',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
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

  void _showBadgeDetail(Map<String, dynamic> badge) {
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
              Icons.workspace_premium, // Ikon besar di modal
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

  Widget _buildMoreOptions(BuildContext context) {
    return FutureBuilder<String?>(
      future: Token.getUserId(),
      builder: (context, snapshot) {
        final currentUserId = snapshot.data;
        if (currentUserId == null || currentUserId != post.idUser.toString()) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmation(context);
            }
          },
          icon: Icon(Icons.more_vert, color: ColorApp.grey, size: 20.sp),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              height: 40,
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  SizedBox(width: 2.w),
                  Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Hapus Postingan', style: TextStyleApp.bodyTextBold),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: ColorApp.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (isHome) {
                Get.find<ShareController>().deletePost(post.id);
              } else {
                Get.find<FollowController>().deletePost(post.id);
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Post Image ──
  Widget _buildImage() {
    final imageUrl =
        '${AppConstants.BASE_URL}${AppConstants.API_POSTING_SHOW_IMAGE}/${post.image}';

    return FutureBuilder<Map<String, String>>(
      future: PostService().getImageHeaders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            height: 30.h,
            color: Colors.grey.shade100,
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
                      child: Container(color: Colors.black.withOpacity(0.9)),
                    ),
                    InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4,
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 10.w,
                          ),
                          child: Image.network(
                            imageUrl,
                            headers: snapshot.data!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 4 / 3, // Instagram-like aspect ratio
            child: Image.network(
              imageUrl,
              headers: snapshot.data!,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
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
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Icon(
                      Icons.verified, // Diubah dari piala ke lencana verifikasi
                      color: const Color(0xFFD4AF37),
                      size: 13.sp,
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

  // ── Action Bar ──
  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attachment (PDF/Doc) if exists
          if (post.doc != null && post.doc!.isNotEmpty) ...[
            _buildDocumentAttachment(context),
            SizedBox(height: 1.h),
          ],
          Row(
            children: [
              // Like (Heart)
              _LikeButton(
                isActive: post.voteStatus == 1,
                onTap: () {
                  if (isHome) {
                    Get.find<ShareController>().vote(index, 1);
                  } else {
                    Get.find<FollowController>().vote(index, 1);
                  }
                },
              ),
              SizedBox(width: 5.w),
              // Comment
              GestureDetector(
                onTap: () => _showCommentSheet(context),
                child: Icon(IconlyLight.chat, color: ColorApp.black, size: 24),
              ),
              SizedBox(width: 5.w),
              // Share
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'Share',
                    'Berhasil membagikan postingan!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: ColorApp.colorPrimary.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                },
                child: Icon(IconlyLight.send, color: ColorApp.black, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentAttachment(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final token = await Token.getToken();
        final url =
            '${AppConstants.BASE_URL}${AppConstants.API_POSTING_DOWNLOAD_DOC}/${post.id}?token=$token';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: ColorApp.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorApp.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.doc ?? 'Document Attachment',
                    style: TextStyleApp.bodyTextBold.copyWith(fontSize: 10.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Tap untuk mengunduh',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      fontSize: 8.sp,
                      color: ColorApp.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download_rounded, color: ColorApp.grey, size: 18.sp),
          ],
        ),
      ),
    );
  }

  void _showCommentSheet(BuildContext context) {
    Get.bottomSheet(
      _CommentSheet(postId: post.id),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()} tahun lalu';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()} bulan lalu';
    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()} minggu lalu';
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Like Button Widget (Animated)
// ─────────────────────────────────────────────────────────────────────────────
class _LikeButton extends StatefulWidget {
  const _LikeButton({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isActive) {
          _controller.forward(from: 0.0);
        }
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              widget.isActive ? IconlyBold.heart : IconlyLight.heart,
              color: widget.isActive ? Colors.red : ColorApp.black,
              size: 26,
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comment Bottom Sheet (API-connected)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentSheet extends StatefulWidget {
  final int postId;
  const _CommentSheet({required this.postId});

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final CommentService _commentService = CommentService();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _error;
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _commentService.fetchComments(widget.postId);
      // The API returns the original post as the first item, with actual
      // comments nested inside its repliedData. Extract only the real
      // comments so the post description is not duplicated.
      List<Comment> actualComments;
      if (result.isNotEmpty && result.first.repliedData.isNotEmpty) {
        actualComments = result.first.repliedData;
      } else if (result.isNotEmpty && result.first.repliedData.isEmpty) {
        actualComments = [];
      } else {
        actualComments = result;
      }
      setState(() {
        _comments = actualComments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _sendComment() async {
    if (_textController.text.trim().isEmpty || _isSending) return;
    setState(() => _isSending = true);
    try {
      final targetId = _replyingTo?.id ?? widget.postId;
      await _commentService.addComment(
        postId: targetId,
        description: _textController.text.trim(),
      );
      _textController.clear();
      setState(() => _replyingTo = null);
      await _loadComments();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim komentar',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _setReplyTo(Comment comment) {
    setState(() => _replyingTo = comment);
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(maxHeight: 85.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Komentar',
              style: TextStyleApp.bodyTextBold.copyWith(fontSize: 14.sp),
            ),
          ),
          const Divider(height: 1),
          // Comments list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            color: ColorApp.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: _loadComments,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _comments.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada komentar',
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        color: ColorApp.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _comments.length,
                    itemBuilder: (context, i) {
                      return _buildCommentItem(_comments[i]);
                    },
                  ),
          ),
          // Reply indicator
          if (_replyingTo != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: ColorApp.colorPrimary.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Membalas @${_replyingTo!.accountName ?? _replyingTo!.username ?? _replyingTo!.fullname ?? _replyingTo!.nickname ?? 'Pengguna'}',
                      style: TextStyleApp.bodyTextSmall.copyWith(
                        fontSize: 12.sp,
                        color: ColorApp.colorPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.sp,
                      color: ColorApp.grey,
                    ),
                  ),
                ],
              ),
            ),
          // Input field
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: _replyingTo != null
                          ? 'Tulis balasan...'
                          : 'Tambahkan komentar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                        color: ColorApp.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 14.sp),
                  ),
                ),
                const SizedBox(width: 8),
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: _sendComment,
                        child: Text(
                          'Kirim',
                          style: TextStyleApp.bodyTextBold.copyWith(
                            color: ColorApp.colorPrimary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, {int depth = 0}) {
    final hasReplies = comment.repliedData.isNotEmpty;
    final isReply = depth > 0;

    if (isReply) {
      return _buildReplyItem(comment, depth);
    }
    if (hasReplies) {
      return _buildMultiCommentItem(comment, depth);
    }
    return _buildSingleCommentItem(comment);
  }

  // ── Single Comment — clean standalone card ──
  Widget _buildSingleCommentItem(Comment comment) {
    final name =
        comment.accountName ??
        comment.username ??
        comment.fullname ??
        comment.nickname ??
        'User';
    final initial = (comment.nickname ?? comment.fullname ?? name)[0]
        .toUpperCase();

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
          _buildCommentAvatar(initial, 36),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyleApp.bodyTextBold.copyWith(
                    fontSize: 14.sp,
                    color: ColorApp.colorSecondary,
                  ),
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
                  onTap: () => _setReplyTo(comment),
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

  // ── Multi Comment — parent card + threaded replies ──
  Widget _buildMultiCommentItem(Comment comment, int depth) {
    final name =
        comment.accountName ??
        comment.username ??
        comment.fullname ??
        comment.nickname ??
        'User';
    final initial = (comment.nickname ?? comment.fullname ?? name)[0]
        .toUpperCase();

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
          // Parent comment
          Padding(
            padding: EdgeInsets.all(3.5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentAvatar(initial, 36),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyleApp.bodyTextBold.copyWith(
                          fontSize: 14.sp,
                          color: ColorApp.colorSecondary,
                        ),
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
                        onTap: () => _setReplyTo(comment),
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
          Divider(height: 1, color: ColorApp.grey.withOpacity(0.12)),
          // Replies section
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
                  (reply) => _buildCommentItem(reply, depth: depth + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reply Tile — nested reply with thread line ──
  Widget _buildReplyItem(Comment comment, int depth) {
    final name =
        comment.accountName ??
        comment.username ??
        comment.fullname ??
        comment.nickname ??
        'User';
    final initial = (comment.nickname ?? comment.fullname ?? name)[0]
        .toUpperCase();

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommentAvatar(initial, 28),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + reply indicator
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyleApp.bodyTextBold.copyWith(
                                      fontSize: 13.sp,
                                      color: ColorApp.colorSecondary,
                                    ),
                                  ),
                                  if (comment.toAnswerPosting != null) ...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.w,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 9.sp,
                                        color: ColorApp.grey.withOpacity(0.6),
                                      ),
                                    ),
                                    Text(
                                      '${comment.toAnswerPosting}',
                                      style: TextStyleApp.bodyTextSmall
                                          .copyWith(
                                            fontSize: 10.sp,
                                            color: ColorApp.colorPrimary
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                comment.description ?? '',
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  fontSize: 14.sp,
                                  color: ColorApp.black.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              GestureDetector(
                                onTap: () => _setReplyTo(comment),
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
        // Sub-replies (rendered flat under the first reply)
        if (comment.repliedData.isNotEmpty)
          Column(
            children: comment.repliedData
                .map(
                  (reply) => _buildCommentItem(
                    reply,
                    depth: 1,
                  ), // Keep depth 1 to stay flat
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCommentAvatar(String initial, double size) {
    return Container(
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
    );
  }
}
