import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuoteDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuoteDisplayState();
}

class _QuoteDisplayState extends State<QuoteDisplay> {
  @override
  Widget build(BuildContext context) {
    final double percent = context.watch<HomeState>().percent;
    final String quote = context.watch<HomeState>().quote;
    final opacity = (percent / 100).clamp(0.0, 1.0);
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 25.0, right: 25.0),
      child: AnimatedOpacity(
        key: ValueKey(quote),
        opacity: opacity,
        duration: Duration(milliseconds: 80 * percent.toInt()),
        child: Container(
          height: 50,
          child: Text(
            '$quote',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
