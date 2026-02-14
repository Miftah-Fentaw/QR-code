import 'package:qrcode/models/code_data_model.dart';

class ScanHistoryItem {
  final String? data;
  final DateTime timestamp;
  final CodeType codeType;

  ScanHistoryItem({
    required this.data,
    required this.timestamp,
    required this.codeType,
  });
}
