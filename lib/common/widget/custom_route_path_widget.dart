import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/common/widget/custom_image.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/images.dart';
import 'package:mighty_school/util/styles.dart';

class CustomRoutePathWidget extends StatelessWidget {
  final double? fontSize;
  final Widget? subWidget;
  final String? title;
  final Function()? titleOnTap;
  const CustomRoutePathWidget({super.key,  this.fontSize, this.subWidget, this.title, this.titleOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Row(children: [
        Row(children: [
          Row(children: [
            const CustomImage(localAsset: true, image: Images.homeRouteIcon, width: 20),
            Icon(Icons.keyboard_arrow_right, color: Theme.of(context).hintColor, size: 16,),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            InkWell(onTap: titleOnTap,
                child: Text(title??'', style: textRegular.copyWith(color: Theme.of(context).hintColor))),

          ]),
          if(subWidget!=null)
            Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: subWidget!,
            )
        ]),

        const Spacer(),
        CustomContainer(onTap: ()=> Get.back(),
            borderRadius: 3,showShadow: false,verticalPadding: 5, horizontalPadding: 5,
            child: Row(spacing: Dimensions.paddingSizeSmall, children: [
              Icon(Icons.arrow_circle_left_outlined, size: 20, color: Theme.of(context).hintColor,),
              Text('back'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
            ]))
      ],
      ),
    );
  }
}
class PathItemWidget extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color? color;
  const PathItemWidget({super.key, this.title, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.keyboard_arrow_right, color: Theme.of(context).hintColor, size: 16,),
      InkWell(onTap: onTap, splashColor: Colors.transparent, highlightColor: Colors.transparent, focusColor: Colors.transparent,
          child: Text(title??'', style: textRegular.copyWith(color: color?? Theme.of(context).hintColor))),
      const SizedBox(width: Dimensions.paddingSizeSmall),

    ]);
  }
}
