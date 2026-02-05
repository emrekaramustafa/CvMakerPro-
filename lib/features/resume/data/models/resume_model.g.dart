// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeModelAdapter extends TypeAdapter<ResumeModel> {
  @override
  final int typeId = 3;

  @override
  ResumeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResumeModel(
      id: fields[0] as String,
      targetLanguage: fields[1] as String,
      personalInfo: fields[2] as PersonalInfoModel,
      experience: (fields[3] as List).cast<ExperienceModel>(),
      education: (fields[4] as List).cast<EducationModel>(),
      skills: (fields[5] as List).cast<String>(),
      languages: (fields[11] as List).cast<LanguageEntry>(),
      certificates: (fields[12] as List).cast<CertificateModel>(),
      references: (fields[13] as List).cast<ReferenceModel>(),
      activities: (fields[14] as List).cast<ActivityModel>(),
      professionalSummary: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      templateId: fields[9] as String,
      isPremium: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ResumeModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.targetLanguage)
      ..writeByte(2)
      ..write(obj.personalInfo)
      ..writeByte(3)
      ..write(obj.experience)
      ..writeByte(4)
      ..write(obj.education)
      ..writeByte(5)
      ..write(obj.skills)
      ..writeByte(6)
      ..write(obj.professionalSummary)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.templateId)
      ..writeByte(10)
      ..write(obj.isPremium)
      ..writeByte(11)
      ..write(obj.languages)
      ..writeByte(12)
      ..write(obj.certificates)
      ..writeByte(13)
      ..write(obj.references)
      ..writeByte(14)
      ..write(obj.activities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
