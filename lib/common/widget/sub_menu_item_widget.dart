import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/util/dimensions.dart';


class SubMenuItemWidget extends StatelessWidget {
  final String? icon;
  final String title;
  const SubMenuItemWidget({super.key, this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomContainer(borderRadius: Dimensions.paddingSizeExtraSmall,
          child: Row(children: [
            if(icon != null)
            SizedBox(width: 25, child: Image.asset(icon!)),
            if(icon != null)
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(child: Text(title.tr)),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Theme.of(context).hintColor)
          ],
          ),
        ),

      ],
      ),
    );
  }
}
