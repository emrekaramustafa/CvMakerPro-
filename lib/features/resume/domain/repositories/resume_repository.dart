import '../../data/models/resume_model.dart';
import '../../data/datasources/resume_local_data_source.dart';

abstract class ResumeRepository {
  Future<List<ResumeModel>> getResumes();
  Future<void> saveResume(ResumeModel resume);
  Future<void> deleteResume(String id);
}

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeLocalDataSource localDataSource;

  ResumeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ResumeModel>> getResumes() async {
    return await localDataSource.getAllResumes();
  }

  @override
  Future<void> saveResume(ResumeModel resume) async {
    await localDataSource.saveResume(resume);
  }

  @override
  Future<void> deleteResume(String id) async {
    await localDataSource.deleteResume(id);
  }
}
