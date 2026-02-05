import 'package:hive/hive.dart';

part 'personal_info_model.g.dart';

@HiveType(typeId: 0)
class PersonalInfoModel {
  @HiveField(0)
  final String fullName;

  @HiveField(8)
  final DateTime? birthDate;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String? address;

  @HiveField(4)
  final String? linkedinUrl;

  @HiveField(5)
  final String? websiteUrl;

  // Target job title for the resume
  @HiveField(6)
  final String targetJobTitle;

  // Profile picture path (optional)
  @HiveField(7)
  final String? profileImagePath;

  PersonalInfoModel({
    required this.fullName,
    this.birthDate,
    required this.email,
    required this.phone,
    this.address,
    this.linkedinUrl,
    this.websiteUrl,
    required this.targetJobTitle,
    this.profileImagePath,
  });
}

