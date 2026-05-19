

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/common/custom_navbar/circle_nav_bar.dart';
import 'package:aitek/feature/dashboard/controller/dashboard_controller.dart';
import 'package:aitek/feature/dashboard/model/navigation_model.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';
import 'package:aitek/util/dimensions.dart';
import 'package:aitek/util/styles.dart';

class CustomNavbarWidget extends StatelessWidget {
  const CustomNavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (menuController) {
        return GetBuilder<ProfileController>(builder: (profileController) {

            List<NavigationModel> item = [];
              item = menuController.item;

            return CircleNavBar(activeIndex: menuController.currentTab,
              onTap: (index) {
                menuController.setTabIndex(index);
              },
              height: 75,
              circleWidth: 60,
              color: Theme.of(context).cardColor,
              circleColor: Theme.of(context).primaryColor,

              shadowColor: Colors.black26,
              circleShadowColor: Colors.black38,
              elevation: 10,
              activeIcons: [
                for (var i in item)
                  Image.asset(i.activeIcon, height: 20, color: Colors.white),
              ],


              inactiveIcons: [
                for (var i in item)
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(i.inactiveIcon, height: 28, color: Theme.of(context).hintColor,),
                      const SizedBox(height: 4),
                      Text(i.name, style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                    ]),
              ],

              activeLevelsStyle: textMedium.copyWith(color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeSmall),
              inactiveLevelsStyle: textRegular.copyWith(color: Colors.grey, fontSize: Dimensions.fontSizeSmall),
            );
          }
        );
      }
    );
  }
}
