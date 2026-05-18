import 'package:flutter/material.dart';
import 'package:mighty_school/common/widget/shimmer_box.dart';

class CustomShimmerText extends StatelessWidget {
  const CustomShimmerText({super.key, required this.width, required this.height});
final double width; final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CustomShimmerBox(width: width, height: height),
    );
  }
}
