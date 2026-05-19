

import 'package:flutter/material.dart';
import 'package:aitek/feature/home/presentation/widgets/level_row_widget.dart';
import 'package:aitek/feature/profile/domain/model/trading_signal_item.dart';

class PriceLadder extends StatelessWidget {
  final TradingSignalItem signal;
  final Color accent;
  const PriceLadder({super.key, required this.signal, required this.accent});

  @override
  Widget build(BuildContext context) {
    final s = signal;
    final levels = s.isBuy
        ? [
      LevelRow(label: 'Take Profit', price: s.tp??0,    color: const Color(0xFF00C896), icon: Icons.flag_rounded),
      LevelRow(label: 'Entry',       price: s.price??0, color: accent,                  icon: Icons.radio_button_checked_rounded),
      LevelRow(label: 'Stop Loss',   price: s.sl??0,    color: const Color(0xFFFF4E6A), icon: Icons.close_rounded),
    ]
        : [
      LevelRow(label: 'Stop Loss',   price: s.sl??0,    color: const Color(0xFFFF4E6A), icon: Icons.close_rounded),
      LevelRow(label: 'Entry',       price: s.price??0, color: accent,                  icon: Icons.radio_button_checked_rounded),
      LevelRow(label: 'Take Profit', price: s.tp??0,    color: const Color(0xFF00C896), icon: Icons.flag_rounded),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 0.8),
      ),
      child: Column(
        children: List.generate(levels.length, (i) {
          final row = levels[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i < levels.length - 1 ? 8 : 0),
            child: Row(
              children: [
                Icon(row.icon, size: 14, color: row.color),
                const SizedBox(width: 8),
                Text(
                  row.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  row.price.toStringAsFixed(5),
                  style: TextStyle(
                    color: row.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}