import 'dart:async';
import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedDotGrid extends StatefulWidget {
  const AnimatedDotGrid({super.key});

  @override
  State<AnimatedDotGrid> createState() => _AnimatedDotGridState();
}

class _AnimatedDotGridState extends State<AnimatedDotGrid> {
  int filledDotCount = 0;
  Timer? _timer;

  static const Duration dotFadeDuration = Duration(milliseconds: 300);
  static const Duration dotFillInterval = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    var state = context.read<HomeState>();
    double percent = state.percent;
    int targetDots = percent.floor();

    _timer = Timer.periodic(dotFillInterval, (timer) {
      if (filledDotCount < targetDots) {
        setState(() {
          filledDotCount++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<HomeState>();
    double percent = state.percent;
    bool isDrawDotGrid = state.isInitDrawDotGrid;
    int targetDots = percent.floor();

    if (isDrawDotGrid) {
      _timer = Timer.periodic(dotFillInterval, (timer) {
        state.setIsInitDrawDotGrid(false);
        if (filledDotCount < targetDots) {
          setState(() {
            filledDotCount++;
          });
        } else {
          timer.cancel();
        }
      });
    }

    return SizedBox(
      width: 240,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(100, (index) {
          if (!isDrawDotGrid) {
            final int number = index + 1;
            if (number <= filledDotCount) {
              final bool isPartialDot =
                  (number == targetDots && percent != targetDots);
              final double endOpacity =
                  isPartialDot ? (percent - percent.floor()) : 1.0;

              return TweenAnimationBuilder<double>(
                key: ValueKey(index),
                tween: Tween(begin: 0.0, end: endOpacity),
                duration: dotFadeDuration,
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  final alpha = (255 - value * 255).round();
                  return _BuildDot(color: Colors.grey.withAlpha(alpha));
                },
              );
            } else {
              return _BuildDot(color: Colors.grey);
            }
          } else {
            filledDotCount = 0;
            return _BuildDot(color: Colors.grey);
          }
        }),
      ),
    );
  }

  Widget _BuildDot({required Color color}) {
    return Stack(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black,
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
