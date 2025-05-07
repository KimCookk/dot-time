import 'package:flutter/material.dart';

class SettingState extends ChangeNotifier {
  DateTime _targetDateTime;
  int _alarmIntervalPercent;

  SettingState({
    required DateTime targetDateTime,
    required int alarmIntervalPercent,
  })  : _alarmIntervalPercent = alarmIntervalPercent,
        _targetDateTime = targetDateTime;

  get targetDateTime => _targetDateTime;
  get alarmIntervalPercent => _alarmIntervalPercent;

  Map<String, dynamic> save() {
    return {
      'targetDateTime': _targetDateTime,
      "alarmIntervalPercent": _alarmIntervalPercent,
    };
  }

  void setTargetDate(DateTime targetDate) {
    _targetDateTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      _targetDateTime.hour,
      _targetDateTime.minute,
      _targetDateTime.second,
    );

    notifyListeners();
  }

  void setTargetTime(DateTime targetTime) {
    _targetDateTime = DateTime(
      _targetDateTime.year,
      _targetDateTime.month,
      _targetDateTime.day,
      targetTime.hour,
      targetTime.minute,
      targetTime.second,
    );
    notifyListeners();
  }

  void setAlarmIntervalPercent(int alarmIntervalPercent) {
    _alarmIntervalPercent = alarmIntervalPercent;
    notifyListeners();
  }
}
