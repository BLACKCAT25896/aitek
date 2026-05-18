import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const StatTile({super.key, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(value, style: const TextStyle(
              color: Colors.white, fontSize: 14,
              fontWeight: FontWeight.w700)),

          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10, fontWeight: FontWeight.w400),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
        ),
      ],
      ),
    );
  }
}