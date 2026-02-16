import 'package:hive/hive.dart';
import 'personal_info_model.dart';
import 'experience_model.dart';
import 'education_model.dart';
import 'language_entry.dart';
import 'certificate_model.dart';
import 'reference_model.dart';
import 'activity_model.dart';

part 'resume_model.g.dart';

@HiveType(typeId: 3)
class ResumeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String targetLanguage; // 'en', 'tr', 'de', etc.

  @HiveField(2)
  final PersonalInfoModel personalInfo;

  @HiveField(3)
  final List<ExperienceModel> experience;

  @HiveField(4)
  final List<EducationModel> education;

  @HiveField(5)
  final List<String> skills;

  @HiveField(6)
  final String? professionalSummary; // AI Generated summary

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;
  
  @HiveField(9)
  final String templateId; // 'modern' or 'classic'

  @HiveField(10)
  final bool? isPremium;

  @HiveField(11)
  final List<LanguageEntry> languages;

  @HiveField(12)
  final List<CertificateModel> certificates;

  @HiveField(13)
  final List<ReferenceModel> references;

  @HiveField(14)
  final List<ActivityModel> activities;

  @HiveField(15)
  final String? coverLetter;

  ResumeModel({
    required this.id,
    required this.targetLanguage,
    required this.personalInfo,
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.languages = const [],
    this.certificates = const [],
    this.references = const [],
    this.activities = const [],
    this.professionalSummary,
    this.coverLetter,
    required this.createdAt,
    required this.updatedAt,
    this.templateId = 'modern',
    this.isPremium = false,
  });
}
