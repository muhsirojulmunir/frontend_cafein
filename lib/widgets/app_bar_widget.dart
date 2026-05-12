import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.onPressed,
    this.actions,
    this.center,
  });

  final String title;
  final bool leadingIcon;
  final bool? center;
  final void Function()? onPressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyleApp.titleText.copyWith(
          fontSize: 19.sp,
          color: ColorApp.colorPrimary,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: center == false
          ? null
          : Visibility(
              visible: leadingIcon,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorApp.black,
                  size: 18.sp,
                ),
                onPressed:
                    onPressed ??
                    () {
                      Get.back();
                    },
              ),
            ),
      actions: actions,
      centerTitle: center ?? true,
      backgroundColor: ColorApp.white,
      surfaceTintColor: ColorApp.white,
    );
  }

  // Menentukan ukuran preferensi AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
