import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class AddNewButtonWidget extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  const AddNewButtonWidget({super.key, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(onTap: onTap,
    color: Theme.of(context).secondaryHeaderColor, verticalPadding: 8, borderRadius: 3,
    child: Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
    const Icon(Icons.add, color: Colors.white, size: Dimensions.iconSizeSmall),
    Text(title??"enroll_in_a_new_course".tr, style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
    ]));
  }
}
