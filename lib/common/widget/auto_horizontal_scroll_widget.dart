import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AutoHorizontalScroll extends StatefulWidget {
  final Widget child;
  final double itemWidth;
  final Duration scrollDuration;
  final Duration pauseDuration;

  const AutoHorizontalScroll({
    super.key,
    required this.child,
    required this.itemWidth,
    this.scrollDuration = const Duration(milliseconds: 1500),
    this.pauseDuration = const Duration(seconds: 3),
  });

  @override
  State<AutoHorizontalScroll> createState() => _AutoHorizontalScrollState();
}

class _AutoHorizontalScrollState extends State<AutoHorizontalScroll> {
  final ScrollController _controller = ScrollController();
  bool _isUserInteracting = false;
  bool _autoRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  Future<void> _startAutoScroll() async {
    if (_autoRunning) return;
    _autoRunning = true;

    while (mounted) {
      if (!_controller.hasClients || _isUserInteracting) {
        await Future.delayed(widget.pauseDuration);
        continue;
      }

      final maxScroll = _controller.position.maxScrollExtent / 2;
      final nextOffset = _controller.offset + widget.itemWidth;

      if (nextOffset >= maxScroll) {
        _controller.jumpTo(0);
        await Future.delayed(widget.pauseDuration);
        continue;
      }

      await _controller.animateTo(
        nextOffset,
        duration: widget.scrollDuration,
        curve: Curves.easeInOutCubic,
      );

      await Future.delayed(widget.pauseDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isUserInteracting = true,
      onExit: (_) => _isUserInteracting = false,
      child: NotificationListener<UserScrollNotification>(
        onNotification: (n) {
          _isUserInteracting = n.direction != ScrollDirection.idle;
          return false;
        },
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
