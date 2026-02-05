// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificateModelAdapter extends TypeAdapter<CertificateModel> {
  @override
  final int typeId = 5;

  @override
  CertificateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CertificateModel(
      title: fields[0] as String,
      issuer: fields[1] as String,
      date: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CertificateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.issuer)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
