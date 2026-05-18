import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/model/popup_menu_model.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomPopupMenu extends StatelessWidget {
  final List<PopupMenuModel> menuItems;
  final void Function(PopupMenuModel)? onSelected;
  final Widget? child;

  const CustomPopupMenu({
    super.key,
    required this.menuItems,
    this.onSelected,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupMenuModel>(
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(
          Dimensions.radiusDefault)), side: BorderSide(
          color: Theme.of(context).hintColor.withAlpha(25))),
      surfaceTintColor: Theme.of(context).cardColor,
      position: PopupMenuPosition.under,
      elevation: 8,
      shadowColor: Theme.of(context).hintColor.withAlpha(76),
      itemBuilder: (BuildContext context) {
        return menuItems.map((option) {
          return PopupMenuItem<PopupMenuModel>(value: option, height: 35,
            child: Row(children: [
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Icon(option.icon, size: Dimensions.fontSizeLarge),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(option.title.tr, style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall)),
              ]));
        }).toList();
      },
      onSelected: onSelected,
      child: child ??
          Icon(Icons.more_vert_rounded,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withAlpha(153)),
    );
  }
}
