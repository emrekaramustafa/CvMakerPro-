// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_letter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoverLetterModelAdapter extends TypeAdapter<CoverLetterModel> {
  @override
  final int typeId = 8;

  @override
  CoverLetterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoverLetterModel(
      id: fields[0] as String? ?? '',
      resumeId: fields[1] as String? ?? '',
      jobTitle: fields[2] as String? ?? '',
      companyName: fields[3] as String? ?? '',
      jobDescription: fields[4] as String? ?? '',
      content: fields[5] as String? ?? '',
      createdAt: fields[6] as DateTime? ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, CoverLetterModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resumeId)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.companyName)
      ..writeByte(4)
      ..write(obj.jobDescription)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoverLetterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
