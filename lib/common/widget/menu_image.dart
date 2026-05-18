import 'package:flutter/material.dart';

class MenuImage extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  const MenuImage({super.key, this.icon, this.iconData});

  @override
  Widget build(BuildContext context) {
    return iconData != null? Icon(iconData, color: Colors.white):
    icon != null?
    SizedBox(height: 20, child: Image.asset(icon!, color: Colors.white)): const SizedBox();
  }
}

class SubMenuImage extends StatelessWidget {
  final String? icon;
  const SubMenuImage({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(20,0,0,0),
        child: Container(width: 5,height: 2,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white)));
  }
}
