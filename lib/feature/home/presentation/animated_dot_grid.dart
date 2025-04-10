import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedDotGrid extends StatefulWidget {
  final double percent; // 예: 75.8

  const AnimatedDotGrid({required this.percent, super.key});

  @override
  State<AnimatedDotGrid> createState() => _AnimatedDotGridState();
}

class _AnimatedDotGridState extends State<AnimatedDotGrid> {
  int currentFilled = 0;
  late int targetDots;
  Timer? _timer;

  // 애니메이션 관련 상수 (튜닝 편하게)
  static const Duration dotFadeDuration = Duration(milliseconds: 300);
  static const Duration dotFillInterval = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    targetDots = widget.percent.ceil();
    _startFilling();
  }

  @override
  void didUpdateWidget(covariant AnimatedDotGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percent != oldWidget.percent) {
      _resetAndStart();
    }
  }

  void _resetAndStart() {
    _timer?.cancel();
    setState(() {
      currentFilled = 0;
      targetDots = widget.percent.ceil();
    });
    _startFilling();
  }

  void _startFilling() {
    _timer = Timer.periodic(dotFillInterval, (timer) {
      if (currentFilled < targetDots) {
        setState(() {
          currentFilled++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double partial = widget.percent % 1;

    return SizedBox(
      width: 240,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(100, (index) {
          final int number = index + 1;
          final double percent = widget.percent;

          if (number <= currentFilled) {
            final bool isPartialDot =
                (number == targetDots && percent != targetDots);
            final double endOpacity =
                isPartialDot ? (percent - percent.floor()) : 1.0;

            return TweenAnimationBuilder<double>(
              key: ValueKey(index), // 애니메이션 안정성 확보
              tween: Tween(begin: 0.0, end: endOpacity),
              duration: dotFadeDuration,
              curve: Curves.easeOut,
              builder: (context, value, child) {
                final alpha = (value * 255).round();
                return _dotBox(color: Colors.green.withAlpha(alpha));
              },
            );
          } else {
            return _dotBox(color: Colors.grey[800]!); // 어두운 회색으로 약간 감성
          }
        }),
      ),
    );
  }

  Widget _dotBox({required Color color}) {
    return Stack(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
