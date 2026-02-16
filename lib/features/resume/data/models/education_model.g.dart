// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EducationModelAdapter extends TypeAdapter<EducationModel> {
  @override
  final int typeId = 2;

  @override
  EducationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EducationModel(
      institutionName: fields[0] as String? ?? '',
      degree: fields[1] as String? ?? '',
      fieldOfStudy: fields[2] as String? ?? '',
      startDate: fields[3] as DateTime? ?? DateTime.now(),
      endDate: fields[4] as DateTime?,
      isCurrent: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, EducationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.institutionName)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.fieldOfStudy)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isCurrent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
