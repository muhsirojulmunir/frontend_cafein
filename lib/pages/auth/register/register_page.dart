import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:cafein/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppGradient.primaryWhiteGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 3.h),
                    Image.asset(
                      appImages.imgLogoCafeinLogin.path,
                      height: 20.h,
                      filterQuality: FilterQuality.high,
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 3.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorApp.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [ElevationApp.elevation4pxBottom],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Daftar Sekarang',
                            style: TextStyleApp.bodyTextBold.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Buat Akun Anda',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              color: ColorApp.black.withAlpha(150),
                            ),
                          ),
                          SizedBox(height: 3.h),

                          // Full Name
                          TextFormFieldWidget(
                            titleForm: 'Nama Lengkap',
                            hintText: 'Masukkan nama lengkap',
                            isPassword: false,
                            textEditingController:
                                controller.fullnameController,
                          ),
                          SizedBox(height: 2.h),

                          // Username
                          TextFormFieldWidget(
                            titleForm: 'Username',
                            hintText: 'Masukkan username',
                            isPassword: false,
                            textEditingController:
                                controller.usernameController,
                          ),
                          SizedBox(height: 2.h),

                          // Email
                          TextFormFieldWidget(
                            titleForm: 'Email',
                            hintText: 'Masukkan alamat email',
                            isPassword: false,
                            textEditingController: controller.emailController,
                          ),
                          SizedBox(height: 2.h),

                          // Phone
                          TextFormFieldWidget(
                            titleForm: 'Telepon',
                            hintText: 'Masukkan nomor telepon',
                            isPassword: false,
                            textEditingController: controller.phoneController,
                          ),
                          SizedBox(height: 2.h),

                          // Gender Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Kelamin',
                                style: TextStyleApp.bodyTextBold.copyWith(
                                  fontSize: 17.sp,
                                  color: ColorApp.black.withAlpha(190),
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              Obx(() => Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => controller.selectedGender.value = 'L',
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                            decoration: BoxDecoration(
                                              color: controller.selectedGender.value == 'L'
                                                  ? ColorApp.colorPrimary.withAlpha(30)
                                                  : ColorApp.white,
                                              border: Border.all(
                                                color: controller.selectedGender.value == 'L'
                                                    ? ColorApp.colorPrimary
                                                    : ColorApp.black.withAlpha(50),
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Laki-laki',
                                                style: TextStyleApp.bodyTextSmall.copyWith(
                                                  color: controller.selectedGender.value == 'L'
                                                      ? ColorApp.colorPrimary
                                                      : ColorApp.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => controller.selectedGender.value = 'P',
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                            decoration: BoxDecoration(
                                              color: controller.selectedGender.value == 'P'
                                                  ? ColorApp.colorPrimary.withAlpha(30)
                                                  : ColorApp.white,
                                              border: Border.all(
                                                color: controller.selectedGender.value == 'P'
                                                    ? ColorApp.colorPrimary
                                                    : ColorApp.black.withAlpha(50),
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Perempuan',
                                                style: TextStyleApp.bodyTextSmall.copyWith(
                                                  color: controller.selectedGender.value == 'P'
                                                      ? ColorApp.colorPrimary
                                                      : ColorApp.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Password
                          TextFormFieldWidget(
                            titleForm: 'Password',
                            hintText: 'Min. 6 karakter',
                            isPassword: true,
                            textEditingController:
                                controller.passwordController,
                          ),

                          SizedBox(height: 1.h),
                          Obx(() {
                            if (controller.errorMessage.isNotEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          SizedBox(height: 2.h),
                          Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonAuthWidget(
                                    enable: true,
                                    onTap: () {
                                      controller.register(
                                        username:
                                            controller.usernameController.text,
                                        email: controller.emailController.text,
                                        password:
                                            controller.passwordController.text,
                                        fullname:
                                            controller.fullnameController.text,
                                        phone:
                                            controller.phoneController.text,
                                      );
                                    },
                                    titleButton: 'Daftar',
                                  ),
                          ),
                          SizedBox(height: 3.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sudah punya akun? ",
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  color: ColorApp.black.withAlpha(150),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(PageName.login);
                                },
                                child: Text(
                                  'Masuk',
                                  style: TextStyleApp.bodyTextSmallBold
                                      .copyWith(color: ColorApp.colorPrimary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
