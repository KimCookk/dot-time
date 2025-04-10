// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

import 'package:dot_time/feature/home/presentation/digital_text.dart';

class GoalInfo extends StatefulWidget {
  final String target;
  final double percent;
  final Duration duration;

  const GoalInfo({
    super.key,
    required this.target,
    required this.percent,
    required this.duration,
  });

  @override
  State<StatefulWidget> createState() => _GoalInfoState();
}

class _GoalInfoState extends State<GoalInfo> {
  late String _target;
  late double _percent;
  late Duration _duration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _target = widget.target;
    _percent = widget.percent;
    _duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DigitalText(
          "$_target to",
          fontSize: 25,
        ),
        const SizedBox(width: 30),
        TweenAnimationBuilder<double>(
          key: ValueKey(_percent), // 값이 바뀌면 애니메이션 재실행
          tween: Tween(begin: 0.0, end: _percent),
          duration: _duration,
          curve: Curves.easeOut,
          builder: (context, value, child) {
            final displayValue = value.toStringAsFixed(1).padLeft(4, '0');
            return DigitalText('$displayValue%', fontSize: 25);
          },
        ),
      ],
    );
  }
}
