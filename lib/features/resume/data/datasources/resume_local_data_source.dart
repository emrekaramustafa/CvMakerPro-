import 'package:hive_flutter/hive_flutter.dart';
import '../models/resume_model.dart';

abstract class ResumeLocalDataSource {
  Future<List<ResumeModel>> getAllResumes();
  Future<void> saveResume(ResumeModel resume);
  Future<void> deleteResume(String id);
  Future<ResumeModel?> getResume(String id);
}

class ResumeLocalDataSourceImpl implements ResumeLocalDataSource {
  final Box<ResumeModel> resumeBox;

  ResumeLocalDataSourceImpl({required this.resumeBox});

  @override
  Future<List<ResumeModel>> getAllResumes() async {
    try {
      return resumeBox.values.toList();
    } catch (e) {
      print("CRITICAL: Corrupted Resume Data detected: $e");
      // Fallback: Try to recover valid resumes and delete corrupted ones
      final safeList = <ResumeModel>[];
      final keysToDelete = <dynamic>[];

      for (var key in resumeBox.keys) {
        try {
          final resume = resumeBox.get(key);
          if (resume != null) {
            safeList.add(resume);
          } else {
             // Null value in box (unexpected)
             keysToDelete.add(key);
          }
        } catch (e) {
           print("Deleting corrupted resume at key $key: $e");
           keysToDelete.add(key);
        }
      }

      // Cleanup corrupted entries
      if (keysToDelete.isNotEmpty) {
        await resumeBox.deleteAll(keysToDelete);
        print("Deleted ${keysToDelete.length} corrupted entries.");
      }

      return safeList;
    }
  }

  @override
  Future<void> saveResume(ResumeModel resume) async {
    await resumeBox.put(resume.id, resume);
  }

  @override
  Future<void> deleteResume(String id) async {
    await resumeBox.delete(id);
  }

  @override
  Future<ResumeModel?> getResume(String id) async {
    return resumeBox.get(id);
  }
}
