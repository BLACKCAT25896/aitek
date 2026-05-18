




import 'package:flutter/material.dart';

class VerificationBadge extends StatelessWidget {
  final int level;
  const VerificationBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final bool verified = level > 0;
    final Color color =
    verified ? const Color(0xFF00C896) : const Color(0xFFFF6B6B);
    final String label = verified ? 'Verified' : 'Unverified';
    final IconData icon =
    verified ? Icons.verified_rounded : Icons.warning_amber_rounded;

    return Row(children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ],
    );
  }
}