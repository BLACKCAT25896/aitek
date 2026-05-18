import 'package:flutter/material.dart';

class ProfileDivider extends StatelessWidget {
  final Color color;
  const ProfileDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.transparent,
          color.withValues(alpha: 0.3),
          Colors.transparent,
        ]),
      ),
    );
  }
}