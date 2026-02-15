import 'package:hive/hive.dart';
import 'package:qrcode/models/code_data_model.dart';

part 'history_model.g.dart';

@HiveType(typeId: 1)
class ScanHistoryItem {
  @HiveField(0)
  final String? data;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final CodeType codeType;

  ScanHistoryItem({
    required this.data,
    required this.timestamp,
    required this.codeType,
  });
}
