import 'package:hive/hive.dart';

part 'certificate_model.g.dart';

@HiveType(typeId: 5)
class CertificateModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String issuer;

  @HiveField(2)
  final DateTime? date;

  CertificateModel({
    required this.title,
    required this.issuer,
    this.date,
  });
}
