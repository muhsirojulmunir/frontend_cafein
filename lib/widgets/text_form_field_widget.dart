import 'package:cafein/controllers/form/text_form_field_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.titleForm,
    this.textEditingController,
    required this.isPassword,
    this.readOnly,
    this.initialValue,
    this.maxLines,
    this.isTanggal,
    this.onTapTanggal,
    this.hintText,
  });

  final String titleForm;
  final TextEditingController? textEditingController;
  final bool isPassword;
  final bool? readOnly;
  final String? initialValue;
  final String? hintText;
  final int? maxLines;
  final bool? isTanggal;
  final void Function()? onTapTanggal;

  @override
  Widget build(BuildContext context) {
    TextFormFieldController controller = Get.put(
      TextFormFieldController(),
      tag: titleForm,
    );

    return Obx(() {
      final errorText = controller.errorText.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
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

          /// Text Field
          Focus(
            onFocusChange: (focus) {
              if (readOnly != true) {
                controller.handleFocus(focus);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorApp.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [ElevationApp.elevation4pxBottom],
              ),
              child: TextFormField(
                maxLines: maxLines ?? 1,
                controller: textEditingController,
                initialValue: initialValue,
                style: TextStyleApp.bodyTextSmall.copyWith(fontSize: 15.sp),
                inputFormatters: titleForm == 'Quantity' || titleForm == 'Total'
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                keyboardType: titleForm == 'Email'
                    ? TextInputType.emailAddress
                    : titleForm == 'Quantity'
                    ? TextInputType.number
                    : TextInputType.text,
                onChanged: (value) {
                  if (titleForm != 'Note') {
                    controller.validator(value);
                  }
                },
                readOnly: readOnly ?? false,
                obscureText: isPassword ? controller.obsecureText.value : false,
                decoration: InputDecoration(
                  fillColor: ColorApp.grey.withAlpha(900),
                  filled: readOnly == true && isTanggal != true,
                  contentPadding: const EdgeInsets.all(16),
                  hintText: hintText ?? titleForm,
                  hintStyle: TextStyleApp.bodyTextSmall.copyWith(
                    fontSize: 15.sp,
                    color: ColorApp.black.withAlpha(120),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: errorText != null ? ColorApp.red : ColorApp.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: errorText != null
                          ? ColorApp.red
                          : (readOnly == true
                                ? ColorApp.grey
                                : ColorApp.colorPrimary),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: errorText != null ? ColorApp.red : ColorApp.grey,
                    ),
                  ),
                  suffixIcon: isPassword
                      ? IconButton(
                          onPressed: () {
                            controller.obsecureText.value =
                                !controller.obsecureText.value;
                          },
                          icon: Icon(
                            controller.obsecureText.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )
                      : isTanggal == true
                      ? IconButton(
                          onPressed: onTapTanggal,
                          icon: const Icon(Icons.calendar_month),
                        )
                      : null,
                ),
              ),
            ),
          ),

          if (errorText != null) ...[
            SizedBox(height: 0.8.h),
            Text(
              errorText,
              style: TextStyleApp.bodyTextSmall.copyWith(
                color: ColorApp.red,
                fontSize: 13.sp,
              ),
            ),
          ],
        ],
      );
    });
  }
}
