import 'package:hive/hive.dart';

part 'language_entry.g.dart';

@HiveType(typeId: 4)
class LanguageEntry {
  @HiveField(0)
  final String languageName;

  @HiveField(1)
  final String level; // 'native', 'fluent', 'advanced', 'intermediate', 'basic'

  LanguageEntry({
    required this.languageName,
    required this.level,
  });
}
