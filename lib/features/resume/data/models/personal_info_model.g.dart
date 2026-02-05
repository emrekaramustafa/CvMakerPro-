// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalInfoModelAdapter extends TypeAdapter<PersonalInfoModel> {
  @override
  final int typeId = 0;

  @override
  PersonalInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalInfoModel(
      fullName: fields[0] as String,
      birthDate: fields[8] as DateTime?,
      email: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String?,
      linkedinUrl: fields[4] as String?,
      websiteUrl: fields[5] as String?,
      targetJobTitle: fields[6] as String,
      profileImagePath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalInfoModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(8)
      ..write(obj.birthDate)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.linkedinUrl)
      ..writeByte(5)
      ..write(obj.websiteUrl)
      ..writeByte(6)
      ..write(obj.targetJobTitle)
      ..writeByte(7)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
