import 'package:hive/hive.dart';

part 'experience_model.g.dart';

@HiveType(typeId: 1)
class ExperienceModel {
  @HiveField(0)
  final String companyName;

  @HiveField(1)
  final String jobTitle;

  @HiveField(2)
  final DateTime startDate;

  @HiveField(3)
  final DateTime? endDate;

  @HiveField(4)
  final bool isCurrent;

  @HiveField(5)
  final String description;

  // AI Generated bullet points
  @HiveField(6)
  final List<String> bulletPoints;

  ExperienceModel({
    required this.companyName,
    required this.jobTitle,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description = '',
    this.bulletPoints = const [],
  });
}
