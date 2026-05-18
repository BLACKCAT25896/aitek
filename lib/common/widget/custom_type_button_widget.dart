import 'package:flutter/material.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomTypeButtonWidget extends StatelessWidget {
  final String? title;
  final bool selected;
  final Function()? onTap;
  const CustomTypeButtonWidget({super.key, this.title,  this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(onTap:onTap,
        showShadow: false, borderColor: Theme.of(context).hintColor.withValues(alpha: 0.25),
        borderRadius: 5,verticalPadding: 0, color: selected? Theme.of(context).colorScheme.primary: Theme.of(context).cardColor,
        child: Center(child: Text(title??'', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
            color: selected? Colors.white: null))));
  }
}
