import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeState extends ChangeNotifier {
  double _percent = 0.0;
  Timer? _timer;

  DateTime _targetDateTime = DateTime(DateTime.now().year, 04, 25, 11, 59, 59);
  DateTime _startDateTime = DateTime(DateTime.now().year, 04, 25, 10, 0, 0);

  get percent => _percent;
  get targetDateTime => _targetDateTime;
  get startDateTime => _startDateTime;
  get targetDateTimeString => DateFormat('yyyy-MM-dd').format(_targetDateTime);

  HomeState() {
    startAutoUpdate();
  }

  void startAutoUpdate() {
    _timer?.cancel(); // 중복 방지
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updatePercent();
    });
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void setPercent(double percent) {
    _percent = percent;
    notifyListeners();
  }

  void setTargetDateTime(DateTime targetDateTime) {
    _targetDateTime = targetDateTime;
    notifyListeners();
  }

  void setStartDateTime(DateTime startDateTime) {
    _startDateTime = startDateTime;
    notifyListeners();
  }

  double calculatePercent() {
    final now = DateTime.now();
    final totalDuration =
        _targetDateTime.difference(_startDateTime).inMilliseconds;
    final remainingDuration = _targetDateTime.difference(now).inMilliseconds;

    if (totalDuration <= 0) {
      _percent = 100.0;
      return _percent;
    }

    final progress = (1 - remainingDuration / totalDuration) * 100;
    _percent = progress.clamp(0.0, 100.0); // 항상 0 ~ 100 사이 유지

    return _percent;
  }

  void updatePercent() {
    var prePercent = _percent.toStringAsFixed(1);
    var curPercent = calculatePercent().toStringAsFixed(1);

    if (curPercent != prePercent) {
      setPercent(_percent);
    }
  }
}
