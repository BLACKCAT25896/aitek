import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/controller/theme_controller.dart';
import 'package:mighty_school/util/dimensions.dart';

const sfProLight = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w300,
);

const textRegular = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w400,
);

const textMedium = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
);

const textSemiBold = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600,
);

const textBold = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w700,
);

const textHeavy = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w900,
);
class ThemeShadow {
  static List <BoxShadow> getShadow() {
    List<BoxShadow> boxShadow =  [BoxShadow(color: Get.find<ThemeController>().darkTheme? Colors.black26:
    Theme.of(Get.context!).hintColor.withValues(alpha: .25), blurRadius: 1,spreadRadius: 1,offset: const Offset(0,0))];
    return boxShadow;
  }
  static BoxDecoration? getDecoration({Color? color, Color? shadowColor} ) {
    return BoxDecoration(
        color: color?? Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        boxShadow:  [BoxShadow(color: shadowColor?? Theme.of(Get.context!).primaryColorDark, spreadRadius: 1, blurRadius: 0, offset: const Offset(0, 3))]
    );
  }

  static BoxDecoration? getLandingPageDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF081D5F),
          Color(0xFF6D0B9C),
          Color(0xFF2B43A4),
        ],
        begin: Alignment.centerLeft,
        end:  Alignment.centerRight,
      ),
    );
  }


  static EdgeInsetsGeometry getPadding() {
    return EdgeInsets.symmetric(vertical: Get.height/3.5);
  }
}