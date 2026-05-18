
import 'package:flutter/material.dart';

class BalanceTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  const BalanceTile({super.key, required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07), width: 0.8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 10, fontWeight: FontWeight.w500,
                  letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(color: accent,
                  fontSize: 14, fontWeight: FontWeight.w700,
                  letterSpacing: 0.2)),
        ],
        ),
      ),
    );
  }
}