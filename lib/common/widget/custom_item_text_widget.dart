import 'package:flutter/material.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomItemTextWidget extends StatelessWidget {
  final String? text;
  final int? maxLines;
  const CustomItemTextWidget({super.key, this.text, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLines?? 1,
      overflow: TextOverflow.ellipsis,
      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
    );
  }
}
