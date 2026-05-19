

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/feature/authentication/logic/authentication_controller.dart';
import 'package:aitek/helper/route_helper.dart';

class LogoutButton extends StatefulWidget {
  final Color accentColor;
  const LogoutButton({super.key, required this.accentColor});

  @override
  State<LogoutButton> createState() => LogoutButtonState();
}

class LogoutButtonState extends State<LogoutButton> {
  bool _isHovered = false;
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final confirmed = await showDialog<bool>(context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF1A1D2E), Color(0xFF252840)], begin: Alignment.topLeft,
                  end: Alignment.bottomRight), boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10)),
          ]),

          child: Column(mainAxisSize: MainAxisSize.min,children: [
            Container(width: 56, height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: const Color(0xFFFF4E4E).withValues(alpha: 0.12),
                    border: Border.all(
                        color: const Color(0xFFFF4E4E).withValues(alpha: 0.3),
                        width: 1.5)),
                child: const Icon(Icons.logout_rounded,
                    color: Color(0xFFFF4E4E), size: 26)),
            const SizedBox(height: 16),
            const Text('Sign Out',
                style: TextStyle(color: Colors.white,
                    fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
            const SizedBox(height: 8),
            Text('Are you sure you want to sign out\nof your account?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, height: 1.5)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: GestureDetector(onTap: () => Navigator.of(ctx).pop(false),
                      child: Container(height: 44,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withValues(alpha: 0.06),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1), width: 0.8)),
                          child: Center(child: Text('Cancel',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ))))),
              const SizedBox(width: 12),
              Expanded(child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(true),
                child: Container(height: 44,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF4E4E), Color(0xFFE03030)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFF4E4E).withValues(alpha: 0.35),
                          blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Center(
                    child: Text('Sign Out',
                      style: TextStyle(color: Colors.white, fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              ),
            ],
            ),
          ],
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      Get.find<AuthenticationController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleLogout,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _isHovered
                ? const Color(0xFFFF4E4E).withValues(alpha: 0.18)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFFFF4E4E).withValues(alpha: 0.6)
                  : const Color(0xFFFF4E4E).withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFFFF4E4E)),
                  ),
                )
              else ...[
                const Icon(Icons.logout_rounded,
                    color: Color(0xFFFF4E4E), size: 18),
                const SizedBox(width: 10),
                Text(
                  'logout'.tr,
                  style: const TextStyle(
                    color: Color(0xFFFF4E4E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}