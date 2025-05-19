import 'package:dot_time/core/constants/animation_state.dart';
import 'package:dot_time/feature/home/presentation/progress_to_date_display.dart';
import 'package:dot_time/feature/home/provider/percent_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressToTargetText(),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<PercentState>()
                    .setAnimationState(AnimationState.refreshing);
                ;
              },
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
