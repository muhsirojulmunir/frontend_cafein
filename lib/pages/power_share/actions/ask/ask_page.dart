import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cafein/controllers/power_share/ask_controller.dart';
import 'package:cafein/pages/power_share/actions/ask/widgets/aturan_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/widgets/app_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AskPage extends StatelessWidget {
  const AskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AskController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorApp.white,
          appBar: AppBarWidget(title: 'Buat Posting', leadingIcon: true),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AturanWidget(controller: controller),
                    SizedBox(height: 3.h),

                    // Title
                    Text('Judul (opsional)', style: TextStyleApp.bodyTextBold),
                    SizedBox(height: 1.h),
                    TextField(
                      controller: controller.titleController,
                      style: TextStyleApp.bodyTextSmall,
                      decoration: InputDecoration(
                        hintText: 'Judul posting...',
                        hintStyle: TextStyleApp.bodyTextSmall
                            .copyWith(color: ColorApp.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ColorApp.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ColorApp.colorPrimary),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Description
                    Text('Deskripsi *', style: TextStyleApp.bodyTextBold),
                    SizedBox(height: 1.h),
                    TextField(
                      controller: controller.descriptionController,
                      maxLines: 5,
                      style: TextStyleApp.bodyTextSmall,
                      decoration: InputDecoration(
                        hintText: 'Apa yang sedang kamu pikirkan?',
                        hintStyle: TextStyleApp.bodyTextSmall
                            .copyWith(color: ColorApp.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ColorApp.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ColorApp.colorPrimary),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Ruang dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ruang', style: TextStyleApp.bodyTextBold),
                        SizedBox(height: 1.h),
                        CustomDropdown<String>(
                          hintText: 'Pilih Ruang',
                          initialItem: controller.selectedRuang?.name,
                          items: controller.ruangNames,
                          onChanged: (value) {
                            controller.updateRuang(value);
                          },
                          decoration: CustomDropdownDecoration(
                            closedBorder: Border.all(color: ColorApp.grey),
                            closedFillColor: ColorApp.white,
                            headerStyle: TextStyleApp.bodyTextSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Image upload
                    Text('Gambar (opsional)', style: TextStyleApp.bodyTextBold),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: controller.selectedImage == null
                                  ? ColorApp.grey
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.selectedImage == null
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(IconlyLight.image,
                                        color: ColorApp.colorPrimary, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Upload Gambar (PNG, JPG, Max 2MB)',
                                      style: TextStyleApp.bodyTextSmall
                                          .copyWith(color: ColorApp.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: kIsWeb
                                          ? Image.memory(
                                              controller.selectedImage!.bytes!,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(controller.selectedImage!.path!),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: controller.removeImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Doc upload
                    Text('Dokumen (opsional)', style: TextStyleApp.bodyTextBold),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: controller.pickFile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorApp.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.selectedFile == null
                            ? Column(
                                children: [
                                  Icon(IconlyLight.upload,
                                      color: ColorApp.colorPrimary, size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Upload Dokumen (PDF, DOC, Max 10MB)',
                                    style: TextStyleApp.bodyTextSmall
                                        .copyWith(color: ColorApp.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(IconlyLight.document,
                                      color: ColorApp.colorPrimary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      controller.selectedFile!.name,
                                      style: TextStyleApp.bodyTextSmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.close, color: Colors.red),
                                    onPressed: controller.removeFile,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Submit button
                    Obx(() => InkWell(
                          onTap: controller.isSubmitting.value
                              ? null
                              : controller.submitPost,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: controller.isSubmitting.value
                                  ? ColorApp.grey
                                  : ColorApp.colorPrimary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [ElevationApp.elevation4pxBottom],
                            ),
                            padding: EdgeInsets.all(14.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (controller.isSubmitting.value)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                else ...[
                                  Text(
                                    'Kirim Posting',
                                    style: TextStyleApp.bodyTextBold.copyWith(
                                      fontSize: 14.sp,
                                      color: ColorApp.white,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(Icons.send_rounded,
                                      color: ColorApp.white, size: 20),
                                ],
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
