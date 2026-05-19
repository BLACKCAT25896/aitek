

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aitek/feature/home/presentation/widgets/cmd_badge.dart';
import 'package:aitek/feature/home/presentation/widgets/expand_details_widget.dart';
import 'package:aitek/feature/home/presentation/widgets/period_chip_widget.dart';
import 'package:aitek/feature/profile/domain/model/trading_signal_item.dart';

class SignalCard extends StatefulWidget {
  final TradingSignalItem signal;
  final int index;
  const SignalCard({super.key, required this.signal, required this.index});

  @override
  State<SignalCard> createState() => SignalCardState();
}

class SignalCardState extends State<SignalCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _expanded = false;

  static const _buyColor  = Color(0xFF00C896);
  static const _sellColor = Color(0xFFFF4E6A);
  static const _cardBg    = Color(0xFF1A1D2E);
  static const _cardBg2   = Color(0xFF20243A);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    final delay = Duration(milliseconds: 60 * widget.index.clamp(0, 5));
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _accent => widget.signal.isBuy ? _buyColor : _sellColor;

  @override
  Widget build(BuildContext context) {
    final s = widget.signal;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _expanded = !_expanded);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [_cardBg, _cardBg2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _expanded
                    ? _accent.withValues(alpha: 0.5)
                    : _accent.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _expanded
                      ? _accent.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.25),
                  blurRadius: _expanded ? 20 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Row(
                    children: [
                      // Direction bar
                      Container(
                        width: 4,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _accent,
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Pair + comment
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  s.pair??'-',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PeriodChip(period: s.period.toString(), color: _accent),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              s.comment??'',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 11.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // CMD badge + price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CmdBadge(label: s.cmd.toString(), color: _accent),
                          const SizedBox(height: 4),
                          Text(
                            (s.price??0).toStringAsFixed(5),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 280),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white.withValues(alpha: 0.35),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),


                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 260),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: ExpandedDetail(signal: s, accent: _accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}