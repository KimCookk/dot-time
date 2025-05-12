// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:dot_time/core/constants/animation_state.dart';
import 'package:dot_time/core/extensions/date_time_extensions.dart';
import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:dot_time/feature/home/provider/percent_state.dart';
import 'package:flutter/widgets.dart';
import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:provider/provider.dart';

class ProgressToTargetText extends StatelessWidget {
  const ProgressToTargetText({super.key});

  @override
  Widget build(BuildContext context) {
    final percentState = context.watch<PercentState>();

    final percentTextAnimationState = percentState.percentTextAnimationKey;
    final percent = percentState.percent;
    final goalDateTime = percentState.goalDateTime;

    final begin = 0.0;
    final end = percent;

    print(
        'ProgressToTargetText build \n percentTextAnimationState : $percentTextAnimationState \n percent : $percent \n goalDateTime : $goalDateTime');
    const dotFillInterval = Duration(milliseconds: 80);
    final int targetDots = percent.ceil();
    final Duration syncedDuration = Duration(
      milliseconds: targetDots * dotFillInterval.inMilliseconds,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DigitalText(
          goalDateTime.format('yyyy-MM-dd'),
          fontSize: 25,
        ),
        const SizedBox(width: 15),
        Builder(builder: (context) {
          return TweenAnimationBuilder<double>(
            key: ValueKey(percentTextAnimationState),
            tween: Tween(begin: begin, end: end),
            duration: syncedDuration, // 여기 핵심!
            curve: Curves.easeOut,
            builder: (context, value, child) {
              if (value == begin) {
                context.read<PercentState>().setAnimationState(
                      AnimationState.refreshing,
                    );
              }
              final displayValue = value.toStringAsFixed(1).padLeft(4, '0');
              return DigitalText('$displayValue% Complete', fontSize: 25);
            },
            onEnd: () {
              context.read<PercentState>().setAnimationState(
                    AnimationState.success,
                  );
            },
          );
        }),
      ],
    );
  }
}
