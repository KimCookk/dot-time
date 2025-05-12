import 'dart:async';
import 'package:dot_time/core/constants/animation_state.dart';
import 'package:flutter/material.dart';

class PercentState extends ChangeNotifier {
  static const Duration _updateInterval = Duration(seconds: 1);

  late double _percent;
  late Timer _percentUpdateTimer;
  late String _percentTextAnimationKey;

  DateTime _goalDateTime;
  DateTime _progressStartDateTime;
  AnimationState _animationState = AnimationState.idle;

  double get percent => _percent;
  DateTime get goalDateTime => _goalDateTime;
  DateTime get progressStartDateTime => _progressStartDateTime;

  String get percentTextAnimationKey => _percentTextAnimationKey;
  AnimationState get animationState => _animationState;

  PercentState({
    required DateTime progressStartDateTime,
    required DateTime goalDateTime,
  })  : _progressStartDateTime = progressStartDateTime,
        _goalDateTime = goalDateTime {
    _init();
    _percentTextAnimationKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _init() {
    _percent = calculatePercent();
    startPercentUpdateTimer();
  }

  void setAnimationState(AnimationState state) {
    _animationState = state;
  }

  void dispose() {
    stopPercentUpdateTimer();
    super.dispose();
  }
}

extension PercentStateLogicExtension on PercentState {
  void startPercentUpdateTimer() {
    _percentUpdateTimer = Timer.periodic(PercentState._updateInterval, (_) {
      updatePercent();
    });
  }

  void stopPercentUpdateTimer() {
    _percentUpdateTimer.cancel();
  }

  double calculatePercent() {
    final now = DateTime.now();
    final toatl =
        _goalDateTime.difference(_progressStartDateTime).inMilliseconds;
    final passed = now.difference(_progressStartDateTime).inMilliseconds;

    if (toatl <= 0) return 100.0;

    return (passed / toatl * 100).clamp(0.0, 100.0);
  }

  void updatePercent() {
    final double newPercent = calculatePercent();
    if (_percent.toStringAsFixed(1) != newPercent.toStringAsFixed(1)) {
      _percent = newPercent;
      notifyListeners();
    }
  }

  void restartAnimation() {
    if (_isRestartable()) {
      _percentTextAnimationKey =
          DateTime.now().millisecondsSinceEpoch.toString();
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

  bool _isRestartable() {
    return animationState != AnimationState.refreshing;
  }
}
