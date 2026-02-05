// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LanguageEntryAdapter extends TypeAdapter<LanguageEntry> {
  @override
  final int typeId = 4;

  @override
  LanguageEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LanguageEntry(
      languageName: fields[0] as String,
      level: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LanguageEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.languageName)
      ..writeByte(1)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
