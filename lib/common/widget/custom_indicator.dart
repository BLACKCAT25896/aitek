import 'package:flutter/material.dart';
import 'package:mighty_school/util/dimensions.dart';

class CustomIndicator extends StatelessWidget {
  final int index;
  final int currentIndex;
  final double indicatorSize;
  const CustomIndicator({super.key, required this.index, required this.currentIndex, this.indicatorSize = 10});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
      width:  (index == currentIndex)? (indicatorSize*3) : indicatorSize, height: indicatorSize,
      decoration: BoxDecoration(
        color:  (index == currentIndex)? Theme.of(context).cardColor : Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}