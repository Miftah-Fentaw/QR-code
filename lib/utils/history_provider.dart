import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrcode/models/code_data_model.dart';
import 'package:qrcode/utils/history_model.dart';

class HistoryProvider extends ChangeNotifier {
  final Box<ScanHistoryItem> _historyBox = Hive.box<ScanHistoryItem>('history');

  List<ScanHistoryItem> get history =>
      _historyBox.values.toList().reversed.toList();

  void addHistory(String data, CodeType codeType) {
    _historyBox.add(
      ScanHistoryItem(
        data: data,
        timestamp: DateTime.now(),
        codeType: codeType,
      ),
    );
    notifyListeners();
  }

  void deleteHistoryItem(int index) {

    final reversedList = history;
    if (index >= 0 && index < reversedList.length) {
      final item = reversedList[index];
      // Find the key for chosen item in the box
      final key = _historyBox.keys.firstWhere(
        (k) => _historyBox.get(k) == item,
        orElse: () => null,
      );
      if (key != null) {
        _historyBox.delete(key);
        notifyListeners();
      }
    }
  }

  void clearHistory() {
    _historyBox.clear();
    notifyListeners();
  }
}
