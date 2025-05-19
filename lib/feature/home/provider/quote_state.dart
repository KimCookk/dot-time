import 'package:dot_time/core/service/random_pick_service.dart';
import 'package:flutter/material.dart';

class QuoteState extends ChangeNotifier {
  RandomPickService<String> _quotePicker;

  late String _quote;

  String get quote => _quote;

  QuoteState({
    required RandomPickService<String> quotePicker,
  }) : _quotePicker = quotePicker {
    updateQuote();
  }
}

extension QuoteStateLogicExtension on QuoteState {
  void updateQuote() {
    _quote = _quotePicker.getRandomItem();
  }
}
