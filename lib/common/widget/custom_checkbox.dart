import 'package:flutter/material.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function()? onChange;
  final String? title;
  const CustomCheckbox({super.key, required this.value, this.onChange, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onChange,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(value? Icons.check_box : Icons.check_box_outline_blank_rounded, size: 18),
          if(title != null)
          Expanded(child: Text(title!, style: textRegular.copyWith()))
          ],
        ),
      ),
    );
  }
}
