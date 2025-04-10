import 'dart:async';

import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({super.key});

  @override
  State<StatefulWidget> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock> {
  late Timer _timer;
  String _day = '';
  String _time = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      DateTime now = DateTime.now();
      setState(() {
        _updateTime();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void _updateTime() {
    final now = DateTime.now();
    final dayFormat = DateFormat("yy.MM.dd");
    final timeFormat = DateFormat("HH:mm:ss");

    final milli = now.millisecond.toString().padLeft(3, '0'); // 밀리초 3자리
    setState(() {
      _day = dayFormat.format(now);
      _time = "${timeFormat.format(now)}.$milli";
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        // 날짜
        DigitalText(
          _day,
          fontSize: 48,
        ),
        const SizedBox(
          height: 16,
        ),
        // 시간
        DigitalText(
          _time,
          fontSize: 40,
        ),
      ],
    );
  }
}
