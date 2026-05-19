
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/feature/profile/domain/model/profile_model.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';
import 'package:aitek/feature/profile/presentation/widgets/balance_tile_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/leveragechip_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/profile_divider_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/state_tile_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/status_badge_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/verification_badge.dart';

class ProfileBuildCardWidget extends StatelessWidget {
  final ProfileModel? p;
  final String accountType;
  final Color accentColor;
  const ProfileBuildCardWidget({super.key, this.p, required this.accountType, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF1A1D2E), Color(0xFF252840)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24, offset: const Offset(0, 8)),
          ]),
      child: Stack(children: [
        Positioned(top: -30, right: -30,
            child: Container(width: 120, height: 120,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.07)))),

        Positioned(bottom: -20, left: -20,
            child: Container(width: 80, height: 80,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.05)))),

        Padding(padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 52, height: 52,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [accentColor, accentColor.withValues(alpha: 0.5)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight)),

                  child: Center(child: Text((p?.name?.isNotEmpty == true)
                      ? p!.name![0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 22, fontWeight: FontWeight.w700)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p?.name ?? '—',
                    style: const TextStyle(color: Colors.white,
                        fontSize: 17, fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis),

                GetBuilder<ProfileController>(
                  builder: (controller) {
                    return Text(controller.lastFourNumber ?? '—',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 17, fontWeight: FontWeight.w700),
                        maxLines: 1, overflow: TextOverflow.ellipsis);
                  }
                ),
                const SizedBox(height: 4),

                Row(children: [

                  StatusBadge(label: accountType, color: accentColor),
                  if (p?.isSwapFree == true) ...[
                    const SizedBox(width: 6),
                    const StatusBadge(label: 'Swap-Free', color: Color(0xFFFFB830)),
                  ],
                ],
                ),
              ],
              ),
              ),
              LeverageChip(leverage: p?.leverage ?? 0, color: accentColor),
            ],
            ),
            const SizedBox(height: 20),
            ProfileDivider(color: accentColor),
            const SizedBox(height: 18),
            Row(children: [
              BalanceTile(
                  label: 'Balance',
                  value: '\$${(p?.balance ?? 0.0).toStringAsFixed(2)}',
                  accent: accentColor),
              const SizedBox(width: 12),
              BalanceTile(
                  label: 'Equity',
                  value: '\$${(p?.equity ?? 0.0).toStringAsFixed(2)}',
                  accent: accentColor),
              const SizedBox(width: 12),
              BalanceTile(
                  label: 'Free Margin',
                  value: '\$${(p?.freeMargin ?? 0.0).toStringAsFixed(2)}',
                  accent: accentColor),
            ]),
            const SizedBox(height: 18),
            ProfileDivider(color: accentColor),
            const SizedBox(height: 18),
            Row(children: [

              StatTile(
                  icon: Icons.show_chart_rounded,
                  label: 'Open Trades',
                  value: '${p?.currentTradesCount ?? 0}',
                  color: accentColor),
              const SizedBox(width: 10),
              StatTile(
                  icon: Icons.history_rounded,
                  label: 'Total Trades',
                  value: '${p?.totalTradesCount ?? 0}',
                  color: accentColor),
              const SizedBox(width: 10),
              StatTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Total Volume',
                  value: (p?.totalTradesVolume ?? 0.0).toStringAsFixed(2),
                  color: accentColor),
            ]),
            const SizedBox(height: 18),
            ProfileDivider(color: accentColor),
            const SizedBox(height: 14),
            Row(children: [
              Icon(Icons.location_on_rounded, size: 15, color: accentColor),
              const SizedBox(width: 6),
              Text([p?.city, p?.country].where((s) => s?.isNotEmpty == true).join(', '),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 13)),
              const Spacer(),
              VerificationBadge(level: p?.verificationLevel ?? 0),
            ]),
          ],
          ),
        ),
      ],
      ),
    );
  }
}
