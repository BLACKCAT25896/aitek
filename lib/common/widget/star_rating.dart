import 'package:flutter/material.dart';
import 'package:mighty_school/util/dimensions.dart';

/// A customizable star rating widget for testimonials and reviews
class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfRating;
  final MainAxisAlignment alignment;
  final EdgeInsets? padding;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16.0,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = true,
    this.alignment = MainAxisAlignment.start,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final activeStarColor = activeColor ?? const Color(0xFFFFB800);
    final inactiveStarColor = inactiveColor ?? Colors.grey.shade300;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxRating, (index) {
          return _buildStar(
            index: index,
            rating: rating,
            activeColor: activeStarColor,
            inactiveColor: inactiveStarColor,
            size: size,
            allowHalfRating: allowHalfRating,
          );
        }),
      ),
    );
  }

  Widget _buildStar({
    required int index,
    required double rating,
    required Color activeColor,
    required Color inactiveColor,
    required double size,
    required bool allowHalfRating,
  }) {
    IconData iconData;
    Color color;

    if (index < rating.floor()) {
      // Full star
      iconData = Icons.star;
      color = activeColor;
    } else if (allowHalfRating && index < rating && rating - index >= 0.5) {
      // Half star
      iconData = Icons.star_half;
      color = activeColor;
    } else {
      // Empty star
      iconData = Icons.star_border;
      color = inactiveColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}

/// A compact star rating widget specifically designed for testimonial cards
class TestimonialStarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showRatingText;
  final TextStyle? textStyle;

  const TestimonialStarRating({
    super.key,
    required this.rating,
    this.size = 14.0,
    this.showRatingText = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StarRating(
          rating: rating,
          size: size,
          activeColor: const Color(0xFFFFB800),
          inactiveColor: Colors.grey.shade300,
          allowHalfRating: true,
        ),
        if (showRatingText) ...[
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            rating.toStringAsFixed(1),
            style: textStyle ??
                TextStyle(
                  fontSize: size - 2,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ],
    );
  }
}

/// An animated star rating widget with smooth transitions
class AnimatedStarRating extends StatefulWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedStarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16.0,
    this.activeColor,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.maxRating,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.animationCurve),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < widget.maxRating; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeStarColor = widget.activeColor ?? const Color(0xFFFFB800);
    final inactiveStarColor = widget.inactiveColor ?? Colors.grey.shade300;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final animationValue = _animations[index].value;
            final shouldShowStar = index < widget.rating;
            
            return Transform.scale(
              scale: animationValue,
              child: Opacity(
                opacity: animationValue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Icon(
                    shouldShowStar ? Icons.star : Icons.star_border,
                    size: widget.size,
                    color: shouldShowStar ? activeStarColor : inactiveStarColor,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
