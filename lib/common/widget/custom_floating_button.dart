import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/helper/responsive_helper.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomFloatingButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  const CustomFloatingButton({super.key,  this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)? const SizedBox() : FloatingActionButton.extended(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      onPressed: onTap,
      label: Row(children: [
        const Icon(Icons.add),
        Text(title?.tr?? "add".tr, style: textRegular.copyWith(),)
      ],),);
  }
}
