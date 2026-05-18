
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/feature/dashboard/model/navigation_model.dart';
import 'package:mighty_school/feature/home/presentation/screens/home_screen.dart';
import 'package:mighty_school/feature/profile/presentation/screens/profile_screen.dart';
import 'package:mighty_school/helper/responsive_helper.dart';
import 'package:mighty_school/util/images.dart';

class DashboardController extends GetxController implements GetxService {
  int _currentTab = 0;

  int get currentTab => _currentTab;

  void resetNavBar() {
    _currentTab = 0;
  }

  void setTabIndex(int index) {
    _currentTab = index;
    if (!ResponsiveHelper.isDesktop(Get.context!)) {
      update();
    }
  }


  final ScrollController scrollController = ScrollController();
  final List<NavigationModel> item = [
    NavigationModel(name: 'dashboard'.tr, activeIcon: Images.homeActive,
        inactiveIcon: Images.home, screen: const HomeScreen()),
    NavigationModel(name: 'profile'.tr, activeIcon: Images.menuIcon, inactiveIcon: Images.menuIcon, screen: const ProfileScreen()),

  ];


}