import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoMarqueeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double height;
  final double blankSpace;
  final double velocity;
  final Duration pauseAfterRound;
  final TextAlign textAlign;
  final int maxLines;

  const AutoMarqueeText({
    super.key,
    required this.text,
    required this.style,
    required this.height,
    this.blankSpace = 30.0,
    this.velocity = 30.0,
    this.pauseAfterRound = const Duration(seconds: 2),
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth == double.infinity ? 1000 : constraints.maxWidth);

        final bool isOverflowing = textPainter.didExceedMaxLines || 
                                  (constraints.maxWidth != double.infinity && textPainter.width > constraints.maxWidth);

        if (!isOverflowing) {
          return Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
          );
        }

        return SizedBox(
          height: height,
          child: Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: blankSpace,
            velocity: velocity,
            pauseAfterRound: pauseAfterRound,
            startPadding: 0.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        );
      },
    );
  }
}
