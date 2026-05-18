import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResponsiveMasonryGrid extends StatelessWidget {
  final List<Widget> children;
  final double? width;


  const ResponsiveMasonryGrid({super.key, required this.children, this.width});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: width?? 300),
    );
  }
}
