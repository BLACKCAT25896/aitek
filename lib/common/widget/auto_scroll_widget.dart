import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AutoScrollListView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemExtent;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final Duration scrollDuration;
  final Duration pauseDuration;
  final ScrollController? controller; // ✅ external controller

  const AutoScrollListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.itemExtent,
    this.padding,
    this.controller,
    this.physics = const ClampingScrollPhysics(),
    this.scrollDuration = const Duration(milliseconds: 1500),
    this.pauseDuration = const Duration(seconds: 3),
  });

  @override
  State<AutoScrollListView> createState() => _AutoScrollListViewState();
}

class _AutoScrollListViewState extends State<AutoScrollListView> {
  late final ScrollController _controller;
  late final bool _isExternalController;

  bool _userInteracting = false;
  bool _autoRunning = false;

  Timer? _resumeTimer;

  @override
  void initState() {
    super.initState();

    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  // ===== AUTO SCROLL =====

  Future<void> _startAutoScroll() async {
    if (_autoRunning) return;
    _autoRunning = true;

    while (mounted) {
      if (!_controller.hasClients || _userInteracting) {
        await Future.delayed(widget.pauseDuration);
        continue;
      }

      final maxScroll = _controller.position.maxScrollExtent;
      final nextOffset = _controller.offset + widget.itemExtent;

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

  // ===== INTERACTION CONTROL =====

  void _pauseUserInteraction() {
    _userInteracting = true;
    _resumeTimer?.cancel();
  }

  void _resumeUserInteraction() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(
      const Duration(seconds: 2),
          () => _userInteracting = false,
    );
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();

    if (!_isExternalController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _pauseUserInteraction(), // ✅ hover pause
      onExit: (_) => _resumeUserInteraction(), // ✅ hover resume
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction != ScrollDirection.idle) {
            _pauseUserInteraction(); // ✅ manual scroll pause
          } else {
            _resumeUserInteraction(); // ✅ resume after idle
          }
          return false;
        },
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: widget.physics,
          padding: widget.padding,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          itemExtent: widget.itemExtent,
        ),
      ),
    );
  }
}
