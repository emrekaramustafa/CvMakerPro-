import 'package:hive/hive.dart';

part 'cover_letter_model.g.dart';

@HiveType(typeId: 8)
class CoverLetterModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String resumeId;

  @HiveField(2)
  final String jobTitle;

  @HiveField(3)
  final String companyName;

  @HiveField(4)
  final String jobDescription;

  @HiveField(5)
  final String content;

  @HiveField(6)
  final DateTime createdAt;

  CoverLetterModel({
    required this.id,
    required this.resumeId,
    required this.jobTitle,
    required this.companyName,
    required this.jobDescription,
    required this.content,
    required this.createdAt,
  });
}
