import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cafein/controllers/form/text_form_field_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DropdownFieldWidget extends StatelessWidget {
  const DropdownFieldWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.titleForm,
    this.initialItem,
    this.isEmployee,
    this.onTap,
    this.enable,
    required this.hintText,
  });

  final List<String> items;
  final dynamic Function(String?) onChanged;
  final String titleForm;
  final String hintText;
  final String? initialItem;
  final bool? isEmployee;
  final void Function()? onTap;
  final bool? enable;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextFormFieldController(), tag: titleForm);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleForm,
            style: TextStyleApp.bodyTextBold.copyWith(
              fontSize: 17.sp,
              color: controller.getTextFieldColor(
                defaultColor: ColorApp.black.withAlpha(190),
                focusedColor: ColorApp.colorPrimary,
                errorColor: ColorApp.red,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorApp.white,
              boxShadow: [ElevationApp.elevation4pxBottom],
            ),
            child: CustomDropdown<String>(
              hintText: hintText,
              items: items,
              initialItem: initialItem,
              enabled: enable ?? true,
              onChanged: onChanged,
              visibility: (isVisible) {
                controller.handleFocus(isVisible);
              },
              disabledDecoration: CustomDropdownDisabledDecoration(
                hintStyle: TextStyleApp.bodyTextSmall.copyWith(fontSize: 15.sp),
                headerStyle: TextStyleApp.bodyTextSmall.copyWith(
                  fontSize: 15.sp,
                ),
                fillColor: ColorApp.grey.withAlpha(100),
                border: Border.all(color: ColorApp.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              decoration: CustomDropdownDecoration(
                closedSuffixIcon: isEmployee == true
                    ? GestureDetector(
                        onTap: onTap,
                        child: Icon(Icons.delete, color: ColorApp.red),
                      )
                    : null,
                expandedFillColor: ColorApp.white,
                expandedBorder: Border.all(color: ColorApp.grey),
                expandedBorderRadius: BorderRadius.circular(12),
                closedFillColor: ColorApp.white,
                closedBorder: Border.all(color: ColorApp.grey),
                hintStyle: TextStyleApp.bodyTextSmall.copyWith(fontSize: 15.sp),
                headerStyle: TextStyleApp.bodyTextSmall.copyWith(
                  fontSize: 15.sp,
                ),
                listItemStyle: TextStyleApp.bodyTextSmall.copyWith(
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
