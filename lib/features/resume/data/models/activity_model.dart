import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 7)
class ActivityModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String category; // 'Volunteering', 'Hobby', etc.

  ActivityModel({
    required this.title,
    required this.description,
    required this.category,
  });
}
