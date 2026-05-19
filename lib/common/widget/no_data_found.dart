import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/common/widget/custom_image.dart';
import 'package:aitek/util/dimensions.dart';
import 'package:aitek/util/images.dart';
import 'package:aitek/util/styles.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
      const CustomImage(image: Images.noData, width: 50,  localAsset: true,),
        Text("no_data_found".tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),)
    ],);
  }
}
