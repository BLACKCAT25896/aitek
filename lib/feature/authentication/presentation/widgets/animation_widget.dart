
import 'package:flutter/material.dart';

class AnimatedParticleGrid extends StatefulWidget {
  const AnimatedParticleGrid({super.key});

  @override
  State<AnimatedParticleGrid> createState() => _AnimatedParticleGridState();
}

class _AnimatedParticleGridState extends State<AnimatedParticleGrid>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticleGridPainter(progress: _controller.value),
        );
      },
    );
  }
}

class ParticleGridPainter extends CustomPainter {

  final double progress;

  ParticleGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {

    const spacing = 18.0;
    final paint = Paint();

    final waveX = size.width * progress;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {

        final dx = (x - waveX).abs();

        double glow = (1 - (dx / 140)).clamp(0, 1); // wider & softer wave

        paint.color = Color.lerp(
          Colors.white.withValues(alpha: .05),   // very soft base dots
          Colors.white.withValues(alpha: .35),   // soft light wave
          glow,
        )!;

        canvas.drawCircle(
          Offset(x, y),
          0.8 + glow * 0.8,  // subtle size change
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticleGridPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}