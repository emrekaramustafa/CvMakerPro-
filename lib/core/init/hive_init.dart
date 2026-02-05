import 'package:hive_flutter/hive_flutter.dart';
import '../../features/resume/data/models/personal_info_model.dart';
import '../../features/resume/data/models/experience_model.dart';
import '../../features/resume/data/models/education_model.dart';
import '../../features/resume/data/models/resume_model.dart';
import '../../features/resume/data/models/language_entry.dart';
import '../../features/resume/data/models/certificate_model.dart';
import '../../features/resume/data/models/reference_model.dart';
import '../../features/resume/data/models/activity_model.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(PersonalInfoModelAdapter());
    Hive.registerAdapter(ExperienceModelAdapter());
    Hive.registerAdapter(EducationModelAdapter());
    Hive.registerAdapter(ResumeModelAdapter());
    Hive.registerAdapter(LanguageEntryAdapter());
    Hive.registerAdapter(CertificateModelAdapter());
    Hive.registerAdapter(ReferenceModelAdapter());
    Hive.registerAdapter(ActivityModelAdapter());
    
    // Open Boxes
    try {
      await Hive.openBox<ResumeModel>('resumes');
    } catch (e) {
      // If schema migration fails, delete the box and start fresh
      print('Hive schema error: $e');
      try {
        await Hive.deleteBoxFromDisk('resumes');
      } catch (e) {
        print('Error deleting box: $e');
      }
      await Hive.openBox<ResumeModel>('resumes');
    }
  }
}
