import 'package:flutter/material.dart';

/// A premium, smooth blinking widget that pulses its child with a gentle
/// breathing scale + opacity fade effect.
class BlinkingWidget extends StatefulWidget {
  final Widget child;

  /// Duration of one full pulse cycle (fade out + fade in).
  final Duration duration;

  /// Minimum opacity during pulse.
  final double minOpacity;

  /// Maximum opacity during pulse.
  final double maxOpacity;

  /// Minimum scale during pulse.
  final double minScale;

  const BlinkingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.minOpacity = 0.35,
    this.maxOpacity = 1.0,
    this.minScale = 0.94,
  });

  @override
  State<BlinkingWidget> createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}