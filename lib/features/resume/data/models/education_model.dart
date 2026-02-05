import 'package:hive/hive.dart';

part 'education_model.g.dart';

@HiveType(typeId: 2)
class EducationModel {
  @HiveField(0)
  final String institutionName;

  @HiveField(1)
  final String degree;

  @HiveField(2)
  final String fieldOfStudy;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime? endDate;

  @HiveField(5)
  final bool isCurrent;

  EducationModel({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
  });
}
