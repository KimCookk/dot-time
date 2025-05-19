import 'dart:async';
import 'package:dot_time/core/constants/quotes.dart';
import 'package:dot_time/core/service/random_pick_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeState extends ChangeNotifier {
  double _percent = 0.0;
  int _filledDot = 0;
  int _alarmIntervalPercent = 5;
  Timer? _updatePercentTimer;

  late String _quote;
  double _quoteOpacity = 0.0;
  late RandomPickService<String> _quotePicker;

  static const Duration dotFillInterval = Duration(milliseconds: 80);

  DateTime _targetDateTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0, 1);
  //DateTime _startDateTime = DateTime(DateTime.now().year, 01, 01, 0, 0, 1);
  DateTime _startDateTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 1);

  bool _isInitDrawDotGrid = false;

  double get percent => _percent;
  int get filledDot => _filledDot;
  DateTime get targetDateTime => _targetDateTime;
  DateTime get startDateTime => _startDateTime;
  int get alarmIntervalPercent => _alarmIntervalPercent;
  String get targetDateTimeString =>
      DateFormat('yyyy-MM-dd').format(_targetDateTime);
  bool get isInitDrawDotGrid => _isInitDrawDotGrid;
  String get quote => _quote;
  double get quoteOpacity => _quoteOpacity;

  HomeState() {
    initial();
    startAutoUpdate();
  }
  // Event

  // initial
  // RandomPickService / 퍼센트 / 명언 / draw 여부 초기화
  void initial() {
    _quotePicker = RandomPickService<String>(quotes);
    updatePercent();
    _quote = _quotePicker.getRandomItem();
    _isInitDrawDotGrid = true;
    notifyListeners();
  }

  // save setting : 설정 페이지 save 버튼 클릭시
  // 설정 값 () 업데이트 / 퍼센트 업데이트 / 퍼센트 업데이트 여부에 따른 draw
  // percent auto timer stop 및 start 필요
  void saveSetting(DateTime targetDateTime, int alarmIntervalPercent) {
    stopAutoUpdate();
    _targetDateTime = targetDateTime;
    _alarmIntervalPercent = alarmIntervalPercent;
    if (updatePercent()) {
      _quoteOpacity = 0.0;
      notifyListeners();
      _quoteOpacity = (_percent / 100).clamp(0.0, 1.0);
      _quote = _quotePicker.getRandomItem();
      _isInitDrawDotGrid = true;
      notifyListeners();
    }
    startAutoUpdate();
  }

  // refresh : refresh 버튼 클릭시
  // refresh 버튼 클릭시 / 퍼센트 / 명언 / draw 초기화
  // percent auto timer stop 및 start 필요.
  void refresh() async {
    stopAutoUpdate();
    updatePercent();
    _quoteOpacity = 0.0;
    _quote = _quotePicker.getRandomItem();
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 500));
    _quoteOpacity = (_percent / 100).clamp(0.0, 1.0);
    _isInitDrawDotGrid = true;
    notifyListeners();
    startAutoUpdate();
  }

  void startAutoUpdate() {
    stopAutoUpdate(); // 중복 방지
    _updatePercentTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      updatePercent();
    });
  }

  void stopAutoUpdate() {
    _updatePercentTimer?.cancel();
  }

  void pickQuotes() {
    _quoteOpacity = 0.0;
    _quote = _quotePicker.getRandomItem();
    notifyListeners();
    _quoteOpacity = (_percent / 100).clamp(0.0, 1.0);
    notifyListeners();
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

  void set(DateTime targetDateTime, int alarmIntervalPercent) {
    stopAutoUpdate();
    _targetDateTime = targetDateTime;
    if (updatePercent()) {
      _isInitDrawDotGrid = true;
    }
    notifyListeners();
    startAutoUpdate();
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

    return progress.clamp(0.0, 100.0);
  }

  bool updatePercent() {
    var prePercent = _percent.toStringAsFixed(1);
    var curPercent = calculatePercent().toStringAsFixed(1);

    if (curPercent != prePercent) {
      //_isInitDrawDotGrid = true;
      _percent = double.parse(curPercent);
      return true;
    }

    return false;
  }
}
