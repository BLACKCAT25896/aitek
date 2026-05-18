

import 'package:flutter/material.dart';
import 'package:mighty_school/feature/home/presentation/widgets/metachip_inline.dart';
import 'package:mighty_school/feature/home/presentation/widgets/metachip_widget.dart';
import 'package:mighty_school/feature/home/presentation/widgets/price_ledder.dart';
import 'package:mighty_school/feature/profile/domain/model/trading_signal_item.dart';

class ExpandedDetail extends StatelessWidget {
  final TradingSignalItem signal;
  final Color accent;
  const ExpandedDetail({super.key, required this.signal, required this.accent});

  @override
  Widget build(BuildContext context) {
    final s = signal;
    final time = s.time;
    final timeStr =
        '${time.day.toString().padLeft(2, '0')}/'
        '${time.month.toString().padLeft(2, '0')}/'
        '${time.year}  '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    final slPips = (((s.price??0) - (s.sl??0)).abs() * 10000).toStringAsFixed(1);
    final tpPips = (((s.price??0) - (s.tp??0)).abs() * 10000).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient divider
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  accent.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Price ladder
          PriceLadder(signal: s, accent: accent),
          const SizedBox(height: 14),

          // Row 1: timestamp + system — two equal chips
          Row(
            children: [
              MetaChip(
                icon: Icons.access_time_rounded,
                label: timeStr,
                color: accent,
              ),
              const SizedBox(width: 8),
              MetaChip(
                icon: Icons.account_tree_rounded,
                label: 'System ${s.tradingSystem}',
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: 8),


          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              MetaChipInline(
                icon: Icons.trending_down_rounded,
                label: 'SL  $slPips pips',
                color: const Color(0xFFFF4E6A),
              ),
              MetaChipInline(
                icon: Icons.trending_up_rounded,
                label: 'TP  $tpPips pips',
                color: const Color(0xFF00C896),
              ),
              MetaChipInline(
                icon: Icons.tag_rounded,
                label: '#${s.id}',
                color: Colors.white38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
