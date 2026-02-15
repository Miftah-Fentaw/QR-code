// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CodeTypeAdapter extends TypeAdapter<CodeType> {
  @override
  final int typeId = 0;

  @override
  CodeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CodeType.qr;
      case 1:
        return CodeType.barcode;
      default:
        return CodeType.qr;
    }
  }

  @override
  void write(BinaryWriter writer, CodeType obj) {
    switch (obj) {
      case CodeType.qr:
        writer.writeByte(0);
        break;
      case CodeType.barcode:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
