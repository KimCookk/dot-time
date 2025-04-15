import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeState extends ChangeNotifier {
  double _percent = 0.0;
  DateTime _targetDateTime = DateTime(DateTime.now().year, 12, 31, 23, 59, 59);
  DateTime _startDateTime = DateTime(DateTime.now().year, 1, 1, 0, 0, 1);

  get percent => _percent;
  get targetDateTime => _targetDateTime;
  get startDateTime => _startDateTime;
  get targetDateTimeString => DateFormat('yyyy-MM-dd').format(_targetDateTime);

  HomeState() {
    updatePercent();
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

  void updatePercent() {
    final now = DateTime.now();
    final totalDuration =
        _targetDateTime.difference(_startDateTime).inMilliseconds;
    final remainingDuration = _targetDateTime.difference(now).inMilliseconds;

    if (totalDuration <= 0) {
      _percent = 100.0;
      return;
    }

    final progress = (1 - remainingDuration / totalDuration) * 100;
    _percent = progress.clamp(0.0, 100.0); // 항상 0 ~ 100 사이 유지
    setPercent(_percent);
  }
}
