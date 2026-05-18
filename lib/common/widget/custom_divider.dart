import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double? verticalPadding;
  final double? horizontalPadding;
  const CustomDivider({super.key, this.height = 1, this.color = Colors.grey, this.verticalPadding, this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(height: .25, width: MediaQuery.of(context).size.width,color: color);
  }
}