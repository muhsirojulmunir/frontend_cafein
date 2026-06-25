import 'package:cafein/controllers/power_share/notification_controller.dart';
import 'package:cafein/models/notification.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(7.h),
        child: AppBarWidget(
          title: 'Notifikasi',
          leadingIcon: true,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          color: ColorApp.colorPrimary,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade100,
              indent: 18.w,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return _NotificationTile(item: item, controller: controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: ColorApp.colorPrimary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 40.sp,
              color: ColorApp.colorPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Belum ada notifikasi',
            style: TextStyleApp.bodyTextBold.copyWith(
              color: ColorApp.black,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Aktivitas terbaru Anda akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyleApp.bodyTextSmall.copyWith(
              color: ColorApp.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final NotificationController controller;

  const _NotificationTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onNotificationTap(item),
      child: Container(
        color: item.isRead ? Colors.transparent : ColorApp.colorPrimary.withOpacity(0.04),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Indicator (Dot)
            if (!item.isRead)
              Container(
                margin: EdgeInsets.only(top: 1.h, right: 2.w),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
              )
            else
              SizedBox(width: 4.w),
              
            // Avatar Placeholder or Icon based on title
            _buildLeading(),
            SizedBox(width: 3.5.w),
            
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyleApp.bodyTextBold.copyWith(
                      color: ColorApp.black,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    item.body,
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.black.withOpacity(0.7),
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    _formatTime(item.createdAt),
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: ColorApp.grey,
                      fontSize: 10.sp,
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

  Widget _buildLeading() {
    IconData iconData = Icons.notifications_active_outlined;
    Color iconColor = ColorApp.colorPrimary;

    switch (item.resolvedType) {
      case 'like':
        iconData = Icons.favorite_rounded;
        iconColor = Colors.red.shade400;
        break;
      case 'comment':
        iconData = Icons.comment_rounded;
        iconColor = ColorApp.colorPrimary;
        break;
      case 'share':
        iconData = Icons.share_rounded;
        iconColor = Colors.green.shade400;
        break;
      case 'follow':
        iconData = Icons.person_add_rounded;
        iconColor = Colors.blue.shade400;
        break;
    }

    return Container(
      width: 13.w,
      height: 13.w,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 18.sp),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 30) return DateFormat('dd MMM yyyy').format(date);
    if (diff.inDays >= 1) return '${diff.inDays} hari lalu';
    if (diff.inHours >= 1) return '${diff.inHours} jam lalu';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} mnt lalu';
    return 'Baru saja';
  }
}

