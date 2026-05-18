import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_title.dart';
import 'package:mighty_school/helper/responsive_helper.dart';
import 'package:mighty_school/util/dimensions.dart';

class DialogPattern extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const DialogPattern({
    super.key,
    required this.title,
    this.subTitle,
    required this.child,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: SizedBox(
        width: width ?? (ResponsiveHelper.isDesktop(context) ? 500 : Get.width),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: CustomTitle(title: title),
              ),
              if (subTitle != null && subTitle!.isNotEmpty) ...[
                Text(
                  subTitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
