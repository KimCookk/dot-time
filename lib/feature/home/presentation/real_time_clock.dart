import 'dart:async';

import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({super.key});

  @override
  State<RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  String _day = '';
  String _time = '';

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((_) {
      final now = DateTime.now();
      final milliseconds = now.millisecond;

      // 시각적으로 더 빠르게 보이게 연출: 밀리초 단위를 x2
      final fakeMs = ((milliseconds * 1.8) % 1000).round(); // 감성 연출
      _updateFormattedTime(now, fakeMs);
    })
      ..start();
  }

  void _updateTime() {
    final now = DateTime.now();
    final dayFormat = DateFormat("yy.MM.dd");
    final timeFormat = DateFormat("HH:mm:ss");

    final milli = now.millisecond.toString().padLeft(3, '0');
    setState(() {
      _day = dayFormat.format(now);
      _time = "${timeFormat.format(now)}.$milli";
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DigitalText(_day, fontSize: 48),
        const SizedBox(height: 16),
        DigitalText(_time, fontSize: 40),
      ],
    );
  }

  void _updateFormattedTime(DateTime now, int adjustedMs) {
    final dayFormat = DateFormat("yy.MM.dd");
    final timeFormat = DateFormat("HH:mm:ss");

    setState(() {
      _day = dayFormat.format(now);
      _time =
          "${timeFormat.format(now)}.${adjustedMs.toString().padLeft(3, '0')}";
    });
  }
}
