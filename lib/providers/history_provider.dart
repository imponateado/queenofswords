import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;

import '../models/reading.dart';
import '../services/reading_history_service.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider({ReadingHistoryService? service})
    : _service = service ?? ReadingHistoryService();

  final ReadingHistoryService _service;

  List<Reading> _readings = [];
  bool _isLoading = false;
  Locale _lastLocale = const Locale('en');

  List<Reading> get readings => _readings;
  bool get isLoading => _isLoading;

  Future<void> load(Locale locale) async {
    _lastLocale = locale;
    _isLoading = true;
    notifyListeners();
    _readings = await _service.loadAll(locale);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> delete(String readingId) async {
    await _service.delete(readingId);
    await load(_lastLocale);
  }

  Future<void> clear() async {
    await _service.clear();
    await load(_lastLocale);
  }
}
