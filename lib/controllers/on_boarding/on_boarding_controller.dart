import 'package:cafein/controllers/initial/initial_controller.dart';
import 'package:cafein/services/local/first_install.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final InitialController initialController = Get.find();
  PageController pageController = PageController();

  RxInt currentPage = 0.obs;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void getStarted() async {
    FirstInstall.setFirstInstall(firstInstall: false);
    initialController.setup();
  }
}
