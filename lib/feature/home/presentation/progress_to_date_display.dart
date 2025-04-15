// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:flutter/widgets.dart';
import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:provider/provider.dart';

class ProgressToTargetText extends StatelessWidget {
  const ProgressToTargetText({super.key});

  @override
  Widget build(BuildContext context) {
    final percent = context.watch<HomeState>().percent;
    final String target = context.watch<HomeState>().targetDateTimeString;

    const dotFillInterval = Duration(milliseconds: 80);
    final int targetDots = percent.ceil();
    final Duration syncedDuration = Duration(
      milliseconds: targetDots * dotFillInterval.inMilliseconds,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DigitalText(
          target,
          fontSize: 25,
        ),
        const SizedBox(width: 15),
        TweenAnimationBuilder<double>(
          key: ValueKey(percent),
          tween: Tween(begin: 0.0, end: percent),
          duration: syncedDuration, // 여기 핵심!
          curve: Curves.easeOut,
          builder: (context, value, child) {
            final displayValue = value.toStringAsFixed(1).padLeft(4, '0');
            return DigitalText('$displayValue% Complete', fontSize: 25);
          },
        ),
      ],
    );
  }
}
