import 'dart:async';
import 'package:dot_time/feature/home/presentation/animated_dot_grid.dart';
import 'package:dot_time/feature/home/presentation/digital_text.dart';
import 'package:dot_time/feature/home/presentation/progress_to_date_display.dart';
import 'package:dot_time/feature/home/presentation/real_time_clock.dart';
import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:dot_time/feature/setting/presentation/setting_screen.dart';
import 'package:dot_time/feature/setting/provider/setting_state.dart';
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
    var state = context.read<HomeState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                builder: (_) => ChangeNotifierProvider(
                    create: (_) => SettingState(
                        targetDateTime: state.targetDateTime,
                        alarmIntervalPercent: state.alarmIntervalPercent),
                    child: SettingScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              context.read<HomeState>().refresh();
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.ios_share),
          ),
        ],
      ),
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
