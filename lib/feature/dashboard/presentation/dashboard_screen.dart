import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/feature/authentication/logic/authentication_controller.dart';
import 'package:aitek/feature/dashboard/controller/dashboard_controller.dart';
import 'package:aitek/feature/dashboard/model/navigation_model.dart';
import 'package:aitek/feature/dashboard/widget/custom_navbar_widget.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    Get.find<DashboardController>().setTabIndex(0);
    if (Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfileInfo();
      Get.find<ProfileController>().getLastFourNumberPhone();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GetBuilder<DashboardController>(builder: (menuController) {
      return GetBuilder<AuthenticationController>(builder: (authController) {
        return GetBuilder<ProfileController>(builder: (profileController) {

          List<NavigationModel> item = [];
            item = menuController.item;

          return Scaffold(resizeToAvoidBottomInset: false,
              body: PageStorage(bucket: bucket, child: item[menuController.currentTab].screen),
              bottomNavigationBar:  const CustomNavbarWidget());
        });
      },
      );},
    );

    if (GetPlatform.isWeb) {
      return content;
    }

    return PopScope(canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

      },
      child: content,
    );
  }
}

