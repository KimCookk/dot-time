import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeState extends ChangeNotifier {
  double _percent = 0.0;
  int _filledDot = 0;
  int alarmIntervalPercent = 5;
  Timer? _updatePercentTimer;

  static const Duration dotFillInterval = Duration(milliseconds: 80);

  DateTime _targetDateTime = DateTime(DateTime.now().year, 12, 31, 11, 59, 59);
  DateTime _startDateTime = DateTime(DateTime.now().year, 01, 01, 0, 0, 1);

  bool _isInitDrawDotGrid = false;

  get percent => _percent;
  get filledDot => _filledDot;
  get targetDateTime => _targetDateTime;
  get startDateTime => _startDateTime;
  get targetDateTimeString => DateFormat('yyyy-MM-dd').format(_targetDateTime);
  get isInitDrawDotGrid => _isInitDrawDotGrid;

  HomeState() {
    startAutoUpdate();
  }

  void startAutoUpdate() {
    _updatePercentTimer?.cancel(); // 중복 방지
    _updatePercentTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      updatePercent();
    });
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

  void setIsInitDrawDotGrid(bool isInitDrawDotGrid) {
    _isInitDrawDotGrid = isInitDrawDotGrid;
  }

  void setFilledDot(int filledDot) {
    _filledDot = filledDot;
    notifyListeners();
  }

  void refresh() {
    _isInitDrawDotGrid = true;
    _percent = _percent;
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
      _isInitDrawDotGrid = true;
      notifyListeners();
    }
  }
}
