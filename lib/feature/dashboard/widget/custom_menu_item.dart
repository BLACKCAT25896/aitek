
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/common/controller/theme_controller.dart';
import 'package:aitek/util/dimensions.dart';
import 'package:aitek/util/styles.dart';

class CustomMenuItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String activeIcon;
  final String inActiveIcon;
  final VoidCallback onTap;

  const CustomMenuItem({
    super.key, required this.isSelected, required this.name, required this.activeIcon,
    required this.inActiveIcon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Get.find<ThemeController>().darkTheme;
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(width: isSelected ? 90 : 50, child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

          Image.asset(isSelected ? activeIcon : inActiveIcon, color: isSelected?Theme.of(context).primaryColor : darkTheme? Colors.white : Colors.black,
            width: Dimensions.menuIconSize, height: Dimensions.menuIconSize,),

      Text(name.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

        ],
      )),
    );
  }

}