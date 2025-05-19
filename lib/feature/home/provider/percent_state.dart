import 'dart:async';
import 'package:dot_time/core/constants/animation_state.dart';
import 'package:dot_time/feature/home/provider/quote_state.dart';
import 'package:flutter/material.dart';

class PercentState extends ChangeNotifier {
  static const Duration _updateInterval = Duration(seconds: 1);

  late double _percent; // 퍼센트
  late Timer _percentUpdateTimer; // 퍼센트 주기적으로 업데이트 Timer
  late String _percentAnimationKey; // 퍼센트 관련 애니메이션 Key

  DateTime _goalDateTime; // 목표 날짜
  DateTime _progressStartDateTime; // 시작 날짜
  AnimationState _animationState = AnimationState.idle; // 애니메이션 상태

  double get percent => _percent;
  DateTime get goalDateTime => _goalDateTime;
  DateTime get progressStartDateTime => _progressStartDateTime;

  // QuoteState get quoteState => _quoteState;

  String get percentAnimationKey => _percentAnimationKey;
  AnimationState get animationState => _animationState;

  PercentState({
    // required QuoteState quoteState,
    required DateTime progressStartDateTime,
    required DateTime goalDateTime,
  })  : //_quoteState = quoteState,
        _progressStartDateTime = progressStartDateTime,
        _goalDateTime = goalDateTime {
    _init();
  }

  void _init() {
    _percent = calculatePercent();
    startPercentUpdateTimer();
    _percentAnimationKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void setAnimationState(AnimationState state) {
    _animationState = state;
  }

  void dispose() {
    stopPercentUpdateTimer();
    super.dispose();
  }

  // Percent 업데이트
  // 소수점 첫째 자리까지 비교 후 새로 계산된 Percent와 기존 Percent가 다른 경우 업데이트
  void updatePercent() {
    final double newPercent = calculatePercent();
    if (_percent.toStringAsFixed(1) != newPercent.toStringAsFixed(1)) {
      _percent = newPercent;
      notifyListeners();
    }
  }

  // Percent 관여되는 애니메이션 Key 업데이트
  void restartAnimation() {
    if (_isRestartable()) {
      _percentAnimationKey = DateTime.now().millisecondsSinceEpoch.toString();
      notifyListeners();
    }
  }

  void set(DateTime progressStartDateTime, DateTime goalDateTime) {
    _progressStartDateTime = progressStartDateTime;
    _goalDateTime = goalDateTime;
    notifyListeners();

    var percent = calculatePercent();
    if (percent != _percent) {
      restartAnimation();
    }
  }
}

// PercentState 로직 구현
extension PercentStateLogicExtension on PercentState {
  // Update Timer 시작
  void startPercentUpdateTimer() {
    _percentUpdateTimer = Timer.periodic(PercentState._updateInterval, (_) {
      updatePercent();
    });
  }

  // Update Timer 정지
  void stopPercentUpdateTimer() {
    _percentUpdateTimer.cancel();
  }

  // Percent 계산
  // (목표 날짜 - 현재 날짜) / (목표 날짜 - 시작 날짜) * 100
  double calculatePercent() {
    final now = DateTime.now();
    final toatl =
        _goalDateTime.difference(_progressStartDateTime).inMilliseconds;
    final passed = now.difference(_progressStartDateTime).inMilliseconds;

    if (toatl <= 0) return 100.0;

    return (passed / toatl * 100).clamp(0.0, 100.0);
  }

  bool _isRestartable() {
    return animationState != AnimationState.refreshing;
  }
}
