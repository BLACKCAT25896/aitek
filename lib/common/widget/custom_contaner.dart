import 'package:flutter/material.dart';
import 'package:mighty_school/util/styles.dart';

class CustomContainer extends StatelessWidget {
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? width;
  final Color? color;
  final double? height;
  final Widget? child;
  final bool showShadow;
  final Border? border;
  final Color? borderColor;
  final Function()? onTap;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? borderWidth;

  const CustomContainer({super.key, this.borderRadius, this.color, this.child,
    this.horizontalPadding, this.showShadow = true, this.width,
    this.verticalPadding, this.border, this.onTap, this.height,
    this.borderColor, this.borderWidth, this.marginHorizontal, this.marginVertical, });

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, splashColor: Colors.transparent, highlightColor: Colors.transparent,
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius??10),
          color: color?? Theme.of(context).cardColor,
          border: border,
          boxShadow: showShadow? ThemeShadow.getShadow() : null),
        padding: EdgeInsets.symmetric(horizontal : horizontalPadding??10, vertical: verticalPadding??10),
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal ?? 0, vertical: marginVertical ?? 0),
        child: child,

      ),
    );
  }
}
