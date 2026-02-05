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
    return resumeBox.values.toList();
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
