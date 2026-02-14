import 'package:flutter/material.dart';
import 'package:qrcode/models/code_data_model.dart';
import 'package:qrcode/utils/history_model.dart';

class HistoryProvider extends ChangeNotifier {
  final List<ScanHistoryItem> _history = [];

  List<ScanHistoryItem> get history => _history.reversed.toList();

  void addHistory(String data, CodeType codeType) {
    _history.add(
      ScanHistoryItem(
        data: data,
        timestamp: DateTime.now(),
        codeType: codeType,
      ),
    );
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
