import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? leftPadding;
  final Widget? widget;
  final Widget? subWidget;
  final bool webTitle;
  const CustomTitle({super.key, required this.title,  this.isRequired = false, this.fontSize, this.widget, this.fontWeight, this.leftPadding, this.webTitle = false, this.subWidget});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Row(children: [
        Padding(padding:  EdgeInsets.only(left: leftPadding??0),
            child: webTitle?
            Padding(padding:  EdgeInsets.only(left: leftPadding?? Dimensions.paddingSizeDefault),
                child: Text(title.tr, style: textMedium.copyWith(fontSize:  Dimensions.fontSizeExtraLarge))):
            Text(title.tr, style: textRegular.copyWith(fontSize: fontSize?? Dimensions.fontSizeDefault, fontWeight: fontWeight))
        ),
        if(isRequired)
          Text('*',style: textSemiBold.copyWith( fontSize: Dimensions.fontSizeDefault, color: Colors.red)),
        if(subWidget!=null)
          Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: subWidget!,
          )
      ]),

      const Spacer(),
      widget??const SizedBox()
    ],
    );
  }
}
class CustomSubTitle extends StatelessWidget {
  final String title;
  const CustomSubTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),);
  }
}