import 'package:flutter/material.dart';

class LeverageChip extends StatelessWidget {
  final int leverage;
  final Color color;
  const LeverageChip({required this.leverage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8)),
      child: Column(children: [

        Text('1:$leverage', style: TextStyle(
            color: color, fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3)),

        Text('Leverage',
            style: TextStyle(
                color: color.withValues(alpha: 0.6), fontSize: 9,
                fontWeight: FontWeight.w500, letterSpacing: 0.5)),
      ],
      ),
    );
  }
}