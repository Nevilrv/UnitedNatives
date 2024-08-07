import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerController2 extends GetxController {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  int selectedIndex = 0;
  PageController pageController;

  selectPage(int index) {
    if (pageController.hasClients) pageController.jumpToPage(index);
    selectedIndex = index;
    update();
  }

  initPageView() {
    pageController = PageController(
      initialPage: selectedIndex,
    );
    pageController.addListener(() {
      selectedIndex = pageController.page.toInt();
    });
  }

  disposePageController() {
    pageController.dispose();
  }

  closeDrawer() {
    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isDrawerOpen = false;
    update();
  }

  openDrawer(size) {
    xOffset = size.width - (size.width > 550 ? size.width / 2 : size.width / 3);
    yOffset = size.height * 0.1;
    scaleFactor = 0.8;
    isDrawerOpen = true;
    update();
  }
}
