import 'package:cafein/controllers/power_share/nav_tab_controller.dart';
import 'package:cafein/controllers/power_share/notification_controller.dart';
import 'package:cafein/pages/power_share/cafe_room/cafe_room_page.dart';
import 'package:cafein/pages/power_share/follow/follow_page.dart';
import 'package:cafein/pages/power_share/share/share_page.dart';
import 'package:cafein/pages/power_share/profile/user_profile_page.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';

class NavTabPage extends StatelessWidget {
  const NavTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<NavTabController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading.value,
          child: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            child: Obx(
              () => Scaffold(
                backgroundColor: const Color(0xFFF4F6F9),
                extendBody: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: AppGradient.menuGradient,
                    ),
                  ),

                  // ── Ask + button — pojok kiri ──────────────────────────
                  leading: GestureDetector(
                    onTap: () => Get.toNamed(PageName.ask),
                    child: Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  leadingWidth: 22.w,

                  // ── Title: Berbagi — tengah ───────────────────────
                  title: Text(
                    'Berbagi',
                    style: TextStyleApp.titleText.copyWith(
                      fontSize: 17.sp,
                      color: Colors.white,
                    ),
                  ),

                  actions: [
                    GestureDetector(
                      onTap: () => Get.toNamed(PageName.notification),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          if (Get.isRegistered<NotificationController>())
                            Obx(() {
                              final notifCtrl =
                                  Get.find<NotificationController>();
                              if (notifCtrl.unreadCount > 0) {
                                return Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    GestureDetector(
                      onTap: () => Get.toNamed(PageName.search),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                  ],
                ),

                body: IndexedStack(
                  index: controller.tabIndex.value,
                  children: [
                    const SharePage(),
                    const FollowPage(),
                    const CafeRoomPage(),
                    // Only build UserProfilePage once the userId is known
                    Obx(() {
                      final uid = controller.currentUserId.value;
                      if (uid == 0) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return UserProfilePage(userId: uid);
                    }),
                  ],
                ),

                // ── Custom Bottom Navigation Bar ─────────────────────────
                bottomNavigationBar: _CustomNavBar(
                  currentIndex: controller.tabIndex.value,
                  onTap: controller.changeTabIndex,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Navbar Widget
// ─────────────────────────────────────────────────────────────────────────────
class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  static const _navItems = [
    _NavItem(
      icon: IconlyLight.home,
      activeIcon: IconlyBold.home,
      label: 'Beranda',
    ),
    _NavItem(
      icon: IconlyLight.paper,
      activeIcon: IconlyBold.paper,
      label: 'Mengikuti',
    ),
    _NavItem(
      // coffee/mug icon dari Material Icons
      icon: Icons.coffee_outlined,
      activeIcon: Icons.coffee,
      label: 'Cafe Room',
    ),
    _NavItem(
      icon: IconlyLight.profile,
      activeIcon: IconlyBold.profile,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: _navItems.asMap().entries.map((entry) {
          final tabIndex = entry.key;
          final item = entry.value;
          return Expanded(
            child: _NavBarItem(
              item: item,
              isActive: currentIndex == tabIndex,
              onTap: () => onTap(tabIndex),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single Nav Item
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = ColorApp.colorPrimary;
    const inactiveColor = Color(0xFF9AA0AD);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? activeColor : inactiveColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 5),
            // Label — ukuran lebih besar
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyleApp.bodyTextSmall.copyWith(
                fontSize: 11.5.sp, // Sedikit diperbesar
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive
                    ? FontWeight.w800
                    : FontWeight.w600, // Dipertebal
              ),
              child: Text(item.label),
            ),
            const SizedBox(height: 4),
            // Active dot indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isActive ? 6 : 0,
              height: isActive ? 6 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
