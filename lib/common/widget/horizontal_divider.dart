import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.symmetric(horizontal:3.0),
      child: Container(width: 1, height: 40, color: Theme.of(context).hintColor,),);
  }
}
