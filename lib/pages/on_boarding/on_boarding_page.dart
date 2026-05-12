import 'package:cafein/controllers/on_boarding/on_boarding_controller.dart';
import 'package:cafein/pages/on_boarding/widgets/on_boarding_item.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: GetBuilder<OnBoardingController>(
        builder: (controller) {
          return Stack(
            children: [
              PageView(
                controller: controller.pageController,
                onPageChanged: (value) {
                  controller.onPageChanged(value);
                },
                children: [
                  OnBoardingItem(
                    title: 'Selamat datang di CafeIN',
                    image: 'assets/images/img_ob_hub.png',
                    subtitle:
                        'Pusat informasi terpadu untuk regulasi, pedoman, media, dan pelatihan kerja Anda.',
                  ),
                  OnBoardingItem(
                    title: 'Selalu Update & Terkini',
                    image: 'assets/images/img_ob_info.png',
                    subtitle:
                        'Ikuti perkembangan berita terbaru, artikel, dan akses cepat ke fitur podcast edukatif kami.',
                  ),
                  OnBoardingItem(
                    title: 'Kolaborasi & Berbagi Ide',
                    image: 'assets/images/img_ob_collab.png',
                    subtitle:
                        'Bagikan inspirasimu dan jadilah bagian dari diskusi inovatif dalam fitur Berbagi.',
                  ),
                ],
              ),
              Obx(
                () => Visibility(
                  visible: controller.currentPage.value != 2,
                  child: Positioned(
                    right: 16,
                    top: 45,
                    child: TextButton(
                      onPressed: () {
                        controller.pageController.jumpToPage(2);
                      },
                      child: Text(
                        'Lewati',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorApp.colorPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12.5.h,
                left: 5.w,
                right: 5.w,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: controller.pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      dotColor: ColorApp.grey.withAlpha(120),
                      activeDotColor: ColorApp.colorPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2.h,
                right: 5.w,
                left: 5.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => controller.currentPage.value != 0
                          ? IconButton(
                              onPressed: () {
                                controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: ColorApp.colorPrimary,
                              ),
                            )
                          : IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.transparent,
                              ),
                              highlightColor: Colors.transparent,
                            ),
                    ),
                    Obx(
                      () => controller.currentPage.value != 2
                          ? IconButton(
                              onPressed: () {
                                controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: ColorApp.colorPrimary,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                controller.getStarted();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp.colorPrimary,
                              ),
                              child: Text(
                                'Mulai Sekarang',
                                style: TextStyleApp.bodyTextBold.copyWith(
                                  color: ColorApp.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
