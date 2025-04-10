import 'package:flutter/material.dart';

class DigitalText extends StatelessWidget {
  final String text;
  final double fontSize;

  const DigitalText(this.text, {super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Courier', // 이후 디지털 폰트로 교체 추천
        fontSize: fontSize,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }
}
