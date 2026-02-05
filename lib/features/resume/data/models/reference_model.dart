import 'package:hive/hive.dart';

part 'reference_model.g.dart';

@HiveType(typeId: 6)
class ReferenceModel {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String company;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phone;

  ReferenceModel({
    required this.fullName,
    required this.company,
    this.email,
    this.phone,
  });
}
