part of 'history_model.dart';

class ScanHistoryItemAdapter extends TypeAdapter<ScanHistoryItem> {
  @override
  final int typeId = 1;

  @override
  ScanHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanHistoryItem(
      data: fields[0] as String?,
      timestamp: fields[1] as DateTime,
      codeType: fields[2] as CodeType,
    );
  }

  @override
  void write(BinaryWriter writer, ScanHistoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.codeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
