import 'dart:async';
import 'package:dot_time/feature/home/presentation/animated_dot_grid.dart';
import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:dot_time/feature/home/presentation/progress_to_date_display.dart';
import 'package:dot_time/feature/home/presentation/real_time_clock.dart';
import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.microtask(() {
    //   context.read<HomeState>().updatePercent();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // 실시간 시간
              RealTimeClock(),
              const SizedBox(height: 32),
              // 퍼센트 도트 격자
              AnimatedDotGrid(),

              const Spacer(),
              ProgressToTargetText(),

              const Spacer(),
              // 문구
              Text(
                'Regret for wasted time is\nmore wasted time.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
