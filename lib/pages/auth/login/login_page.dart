import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/pages/auth/widgets/button_auth_widget.dart';
import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:cafein/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
                      height: 30.h,
                      filterQuality: FilterQuality.high,
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorApp.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Masuk Sekarang',
                            style: TextStyleApp.bodyTextBold.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Masukkan Username/Email dan Password untuk Login',
                            style: TextStyleApp.bodyTextSmall.copyWith(
                              color: ColorApp.black.withAlpha(150),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormFieldWidget(
                            titleForm: 'Username / Email',
                            hintText: 'Masukkan username atau email',
                            isPassword: false,
                            textEditingController:
                                controller.usernameController,
                          ),
                          SizedBox(height: 2.h),
                          TextFormFieldWidget(
                            titleForm: 'Password',
                            hintText: 'Masukkan password',
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
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Checkbox(
                                      checkColor: ColorApp.white,
                                      activeColor: ColorApp.colorPrimary,
                                      value: controller.rememberMe.value,
                                      onChanged: (value) {
                                        controller.rememberMe.value =
                                            value ?? false;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Ingat Saya',
                                    style: TextStyleApp.bodyTextSmall,
                                  ),
                                ],
                              ),
                               GestureDetector(
                                onTap: () => Get.toNamed(PageName.forgotPasswordEmail),
                                child: Text(
                                  'Lupa Password?',
                                  style: TextStyleApp.bodyTextSmallBold.copyWith(
                                    color: ColorApp.colorPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonAuthWidget(
                                    enable: true,
                                    onTap: () {
                                      controller.login(
                                        username:
                                            controller.usernameController.text,
                                        password:
                                            controller.passwordController.text,
                                      );
                                    },
                                    titleButton: 'Masuk',
                                  ),
                          ),
                          SizedBox(height: 3.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum punya akun? ",
                                style: TextStyleApp.bodyTextSmall.copyWith(
                                  color: ColorApp.black.withAlpha(150),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(PageName.register);
                                },
                                child: Text(
                                  'Daftar',
                                  style: TextStyleApp.bodyTextSmallBold
                                      .copyWith(color: ColorApp.colorPrimary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.5.h),
                        ],
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
}
