import 'package:flutter/material.dart';

/// Phases of a realistic blink cycle.
enum _BlinkPhase { idle, closing, holding, opening }

/// A widget that blinks its child with a realistic multi-phase eyelid-style
/// opacity + shadow animation.
///
/// Timing breakdown (at default speed):
///  - Closing : ~90ms  (fast, easeInQuart)
///  - Holding : ~40ms  (eyes shut)
///  - Opening : ~140ms (slow, easeOutCubic)
///  - Idle    : random pause between blinks
class BlinkingWidget extends StatefulWidget {
  final Widget child;

  /// Base duration of one full blink cycle (close + hold + open).
  final Duration blinkDuration;

  /// Minimum pause between blinks.
  final Duration minIdleDuration;

  /// Maximum pause between blinks.
  final Duration maxIdleDuration;

  /// Opacity at fully-closed state.
  final double minOpacity;

  /// Opacity at fully-open state.
  final double maxOpacity;

  /// Blur radius of the shadow at rest.
  final double shadowBlurRadius;

  /// Shadow color.
  final Color shadowColor;

  const BlinkingWidget({
    super.key,
    required this.child,
    this.blinkDuration = const Duration(milliseconds: 270),
    this.minIdleDuration = const Duration(milliseconds: 1800),
    this.maxIdleDuration = const Duration(milliseconds: 5000),
    this.minOpacity = 0.0,
    this.maxOpacity = 1.0,
    this.shadowBlurRadius = 12.0,
    this.shadowColor = const Color(0x44000000),
  });

  @override
  State<BlinkingWidget> createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Proportional split of blinkDuration across phases.
  static const double _closeFraction = 0.33; // ~90ms of 270ms
  static const double _holdFraction = 0.15; // ~40ms
  static const double _openFraction = 0.52; // ~140ms

  _BlinkPhase _phase = _BlinkPhase.idle;
  double _blinkRatio = 0.0; // 0 = open, 1 = fully closed

  @override
  void initState() {
    super.initState();

    final totalMs = widget.blinkDuration.inMilliseconds;
    _controller = AnimationController(
      duration: Duration(milliseconds: totalMs),
      vsync: this,
    )..addListener(_onTick)
     ..addStatusListener(_onStatus);

    _scheduleNextBlink();
  }

  // ─── scheduling ────────────────────────────────────────────────

  void _scheduleNextBlink() {
    final idleRange = widget.maxIdleDuration - widget.minIdleDuration;
    final idleMs = widget.minIdleDuration.inMilliseconds +
        (idleRange.inMilliseconds * _random()).round();

    Future.delayed(Duration(milliseconds: idleMs), () {
      if (!mounted) return;
      _startBlink();
    });
  }

  // Simple LCG-based pseudo-random (avoids dart:math import restriction).
  static int _seed = 42;
  static double _random() {
    _seed = (_seed * 1664525 + 1013904223) & 0xFFFFFFFF;
    return (_seed & 0x7FFFFFFF) / 0x7FFFFFFF;
  }

  void _startBlink() {
    if (!mounted) return;
    setState(() => _phase = _BlinkPhase.closing);
    _controller.forward(from: 0);
  }

  // ─── animation tick ────────────────────────────────────────────

  void _onTick() {
    final t = _controller.value; // 0 → 1 over blinkDuration

    double ratio;

    if (t <= _closeFraction) {
      // Closing: fast, accelerating (easeInQuart).
      final localT = t / _closeFraction;
      ratio = _easeInQuart(localT);
      if (_phase != _BlinkPhase.closing) {
        setState(() => _phase = _BlinkPhase.closing);
      }
    } else if (t <= _closeFraction + _holdFraction) {
      // Holding: fully shut.
      ratio = 1.0;
      if (_phase != _BlinkPhase.holding) {
        setState(() => _phase = _BlinkPhase.holding);
      }
    } else {
      // Opening: slow, decelerating (easeOutCubic).
      final localT = (t - _closeFraction - _holdFraction) / _openFraction;
      ratio = 1.0 - _easeOutCubic(localT.clamp(0.0, 1.0));
      if (_phase != _BlinkPhase.opening) {
        setState(() => _phase = _BlinkPhase.opening);
      }
    }

    if (mounted) setState(() => _blinkRatio = ratio);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (mounted) {
        setState(() {
          _phase = _BlinkPhase.idle;
          _blinkRatio = 0.0;
        });
      }
      _scheduleNextBlink();
    }
  }

  // ─── easing curves ─────────────────────────────────────────────

  static double _easeInQuart(double t) => t * t * t * t;
  static double _easeOutCubic(double t) => 1.0 - (1.0 - t) * (1.0 - t) * (1.0 - t);

  // ─── derived values ────────────────────────────────────────────

  double get _opacity =>
      widget.minOpacity + (widget.maxOpacity - widget.minOpacity) * (1.0 - _blinkRatio);

  double get _shadowBlur => widget.shadowBlurRadius * (1.0 - _blinkRatio * 0.6);

  double get _shadowOpacity => (1.0 - _blinkRatio * 0.5);

  // ─── build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor
                  .withOpacity(widget.shadowColor.opacity * _shadowOpacity),
              blurRadius: _shadowBlur,
              spreadRadius: _shadowBlur * 0.1,
              offset: Offset(0, _shadowBlur * 0.3),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}