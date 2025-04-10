import 'dart:async';
import 'package:dot_time/feature/home/presentation/animated_dot_grid.dart';
import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:dot_time/feature/home/presentation/goal_info.dart';
import 'package:dot_time/feature/home/presentation/real_time_clock.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String _target = '25.12.31';
  final double _percent = 78.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // 실시간 시간
              RealTimeClock(),
              const SizedBox(height: 32),
              // 퍼센트 도트 격자
              AnimatedDotGrid(percent: _percent),

              const Spacer(),
              GoalInfo(
                target: _target,
                percent: _percent,
                duration: Duration(milliseconds: 400 * _percent.ceil()),
              ),
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
