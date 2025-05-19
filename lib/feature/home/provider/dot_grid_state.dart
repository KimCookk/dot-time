import 'package:flutter/material.dart';

class DotGridState extends ChangeNotifier {
  bool _isInitialDrawDotGrid = true;

  bool get isInitialDrawDotGrid => _isInitialDrawDotGrid;

  void setIsInitialDrawDotGrid(
    bool isInitialDrawDotGrid,
    bool isNotifyListeners,
  ) {
    _isInitialDrawDotGrid = isInitialDrawDotGrid;
    if (isNotifyListeners) {
      notifyListeners();
    }
  }
}
