import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/resume_repository.dart';
import '../../data/models/resume_model.dart';
import '../../data/models/personal_info_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/models/education_model.dart';
import '../../data/models/language_entry.dart';
import '../../data/models/certificate_model.dart';
import '../../data/models/reference_model.dart';
import '../../data/models/activity_model.dart';
import '../../data/services/openai_service.dart';

class ResumeProvider extends ChangeNotifier {
  final ResumeRepository repository;
  final OpenAIService openAIService;
  ResumeModel? _currentResume;
  bool _isLoading = false;

  ResumeProvider({
    required this.repository,
    required this.openAIService,
  });

  ResumeModel? get currentResume => _currentResume;
  bool get isLoading => _isLoading;
  List<LanguageEntry> get languages => _currentResume?.languages ?? [];

  // Completion Checkers
  bool get isPersonalInfoComplete {
    if (_currentResume == null) return false;
    final info = _currentResume!.personalInfo;
    return info.fullName.isNotEmpty && 
           info.targetJobTitle.isNotEmpty && 
           info.email.isNotEmpty && 
           info.phone.isNotEmpty;
  }

  bool get isEducationComplete => _currentResume?.education.isNotEmpty ?? false;
  
  bool get isExperienceComplete => _currentResume?.experience.isNotEmpty ?? false;
  
  bool get isLanguagesComplete => _currentResume?.languages.isNotEmpty ?? false;
  
  bool get isSkillsComplete => _currentResume?.skills.isNotEmpty ?? false;

  bool get isCertificatesComplete => _currentResume?.certificates.isNotEmpty ?? false;
  bool get isReferencesComplete => _currentResume?.references.isNotEmpty ?? false;
  bool get isActivitiesComplete => _currentResume?.activities.isNotEmpty ?? false;

  int get cvStrength {
    if (_currentResume == null) return 0;
    
    int score = 0;
    
    // 1. Personal Info (20 pts)
    final info = _currentResume!.personalInfo;
    if (info.fullName.isNotEmpty) score += 5;
    if (info.email.isNotEmpty) score += 5;
    if (info.phone.isNotEmpty) score += 5;
    if (info.targetJobTitle.isNotEmpty) score += 5;

    // 2. Experience (25 pts)
    if (_currentResume!.experience.isNotEmpty) score += 25;

    // 3. Education (15 pts)
    if (_currentResume!.education.isNotEmpty) score += 15;

    // 4. Skills (15 pts) - 3 pts per skill, max 15
    final skillCount = _currentResume!.skills.length;
    final skillScore = (skillCount * 3).clamp(0, 15);
    score += skillScore;

    // 5. Languages (10 pts)
    if (_currentResume!.languages.isNotEmpty) score += 10;

    // 6. Certificates (5 pts)
    if (_currentResume!.certificates.isNotEmpty) score += 5;

    // 7. References (5 pts)
    if (_currentResume!.references.isNotEmpty) score += 5;

    // 8. Activities (5 pts)
    if (_currentResume!.activities.isNotEmpty) score += 5;

    return score;
  }

  List<Map<String, dynamic>> get scoreBreakdown {
    if (_currentResume == null) return [];
    
    final List<Map<String, dynamic>> items = [];
    final info = _currentResume!.personalInfo;

    // 1. Personal Info
    int bioScore = 0;
    List<String> bioMissing = [];
    if (info.fullName.isNotEmpty) bioScore += 5; else bioMissing.add('Name');
    if (info.email.isNotEmpty) bioScore += 5; else bioMissing.add('Email');
    if (info.phone.isNotEmpty) bioScore += 5; else bioMissing.add('Phone');
    if (info.targetJobTitle.isNotEmpty) bioScore += 5; else bioMissing.add('Title');
    
    items.add({
      'title': 'Personal Info',
      'current': bioScore,
      'max': 20,
      'hint': bioMissing.isEmpty ? 'Completed' : 'Missing: ${bioMissing.join(", ")}'
    });

    // 2. Experience
    final hasExp = _currentResume!.experience.isNotEmpty;
    items.add({
      'title': 'Experience',
      'current': hasExp ? 25 : 0,
      'max': 25,
      'hint': hasExp ? 'Completed' : 'Add at least one experience'
    });

    // 3. Education
    final hasEdu = _currentResume!.education.isNotEmpty;
    items.add({
      'title': 'Education',
      'current': hasEdu ? 15 : 0,
      'max': 15,
      'hint': hasEdu ? 'Completed' : 'Add at least one education'
    });

    // 4. Skills
    final skillCount = _currentResume!.skills.length;
    final skillScore = (skillCount * 3).clamp(0, 15);
    final missingSkills = (5 - skillCount).clamp(0, 5);
    items.add({
      'title': 'Skills',
      'current': skillScore,
      'max': 15,
      'hint': missingSkills == 0 ? 'Completed' : 'Add $missingSkills more skills'
    });

    // 5. Languages
    final hasLang = _currentResume!.languages.isNotEmpty;
    items.add({
      'title': 'Languages',
      'current': hasLang ? 10 : 0,
      'max': 10,
      'hint': hasLang ? 'Completed' : 'Add at least one language'
    });

    // 6. Certificates
    final hasCert = _currentResume!.certificates.isNotEmpty;
    items.add({
      'title': 'Certificates',
      'current': hasCert ? 5 : 0,
      'max': 5,
      'hint': hasCert ? 'Completed' : 'Add at least one certificate'
    });

    // 7. References
    final hasRef = _currentResume!.references.isNotEmpty;
    items.add({
      'title': 'References',
      'current': hasRef ? 5 : 0,
      'max': 5,
      'hint': hasRef ? 'Completed' : 'Add at least one reference'
    });

    // 8. Activities
    final hasAct = _currentResume!.activities.isNotEmpty;
    items.add({
      'title': 'Activities',
      'current': hasAct ? 5 : 0,
      'max': 5,
      'hint': hasAct ? 'Completed' : 'Add at least one activity'
    });

    return items;
  }

  Future<void> optimizeResume() async {
    if (_currentResume == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final optimizedData = await openAIService.optimizeResume(
        resume: _currentResume!,
        targetJobTitle: _currentResume!.personalInfo.targetJobTitle,
        targetLanguage: _currentResume!.targetLanguage,
      );

      // Detailed parsing logic:
      final newSummary = optimizedData['summary'] as String?;
      final newSkills = (optimizedData['skills'] as List?)?.map((e) => e.toString()).toList();
      
      // Update
      _currentResume = ResumeModel(
        id: _currentResume!.id,
        targetLanguage: _currentResume!.targetLanguage,
        personalInfo: _currentResume!.personalInfo,
        experience: _currentResume!.experience,
        education: _currentResume!.education,
        skills: newSkills ?? _currentResume!.skills,
        professionalSummary: newSummary,
        createdAt: _currentResume!.createdAt,
        updatedAt: DateTime.now(),
        templateId: _currentResume!.templateId,
        isPremium: _currentResume!.isPremium,
      );
      
      // Also update experience bullets if possible
      if (optimizedData['experience'] != null) {
        final expList = optimizedData['experience'] as List;
        final currentExps = _currentResume!.experience;
        final newExps = <ExperienceModel>[];
        
        for (var i = 0; i < currentExps.length; i++) {
          final curr = currentExps[i];
          if (i < expList.length) {
            final optExp = expList[i];
            newExps.add(ExperienceModel(
              companyName: curr.companyName,
              jobTitle: curr.jobTitle,
              startDate: curr.startDate,
              endDate: curr.endDate,
              isCurrent: curr.isCurrent,
              description: curr.description,
              bulletPoints: (optExp['bullet_points'] as List?)?.map((e) => e.toString()).toList() ?? curr.bulletPoints,
            ));
          } else {
            newExps.add(curr);
          }
        }
        _updateResume(experience: newExps);
      }
      
    } catch (e) {
      debugPrint("Optimization Failed: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void initNewResume(String languageCode) {
    _currentResume = ResumeModel(
      id: const Uuid().v4(),
      targetLanguage: languageCode,
      personalInfo: PersonalInfoModel(
        fullName: '',
        email: '',
        phone: '',
        targetJobTitle: '',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void updatePersonalInfo(PersonalInfoModel info) {
    if (_currentResume == null) return;
    
    _currentResume = ResumeModel(
      id: _currentResume!.id,
      targetLanguage: _currentResume!.targetLanguage,
      personalInfo: info,
      experience: _currentResume!.experience,
      education: _currentResume!.education,
      skills: _currentResume!.skills,
      languages: _currentResume!.languages,
      certificates: _currentResume!.certificates,
      references: _currentResume!.references,
      activities: _currentResume!.activities,
      professionalSummary: _currentResume!.professionalSummary,
      createdAt: _currentResume!.createdAt,
      updatedAt: DateTime.now(),
      templateId: _currentResume!.templateId,
      isPremium: _currentResume!.isPremium,
    );
    notifyListeners();
  }

  Future<void> saveResume() async {
    if (_currentResume == null) return;
    _isLoading = true;
    notifyListeners();
    
    await repository.saveResume(_currentResume!);
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Experience
  void addExperience(ExperienceModel experience) {
    if (_currentResume == null) return;
    final updatedList = List<ExperienceModel>.from(_currentResume!.experience)..add(experience);
    _updateResume(experience: updatedList);
  }

  void updateExperience(int index, ExperienceModel experience) {
    if (_currentResume == null) return;
    final updatedList = List<ExperienceModel>.from(_currentResume!.experience);
    updatedList[index] = experience;
    _updateResume(experience: updatedList);
  }

  void deleteExperience(int index) {
    if (_currentResume == null) return;
    final updatedList = List<ExperienceModel>.from(_currentResume!.experience)..removeAt(index);
    _updateResume(experience: updatedList);
  }

  // Education
  void addEducation(EducationModel education) {
    if (_currentResume == null) return;
    final updatedList = List<EducationModel>.from(_currentResume!.education)..add(education);
    _updateResume(education: updatedList);
  }

  void updateEducation(int index, EducationModel education) {
    if (_currentResume == null) return;
    final updatedList = List<EducationModel>.from(_currentResume!.education);
    updatedList[index] = education;
    _updateResume(education: updatedList);
  }

  void deleteEducation(int index) {
    if (_currentResume == null) return;
    final updatedList = List<EducationModel>.from(_currentResume!.education)..removeAt(index);
    _updateResume(education: updatedList);
  }

  // Skills
  void updateSkills(List<String> skills) {
    _updateResume(skills: skills);
  }

  // Languages
  void addLanguage(LanguageEntry language) {
    if (_currentResume == null) return;
    final updatedList = List<LanguageEntry>.from(_currentResume!.languages)..add(language);
    _updateResume(languages: updatedList);
  }

  void updateLanguage(int index, LanguageEntry language) {
    if (_currentResume == null) return;
    final updatedList = List<LanguageEntry>.from(_currentResume!.languages);
    updatedList[index] = language;
    _updateResume(languages: updatedList);
  }

  void deleteLanguage(int index) {
    if (_currentResume == null) return;
    final updatedList = List<LanguageEntry>.from(_currentResume!.languages)..removeAt(index);
    _updateResume(languages: updatedList);
  }

  // Certificates
  void addCertificate(CertificateModel certificate) {
    if (_currentResume == null) return;
    final updatedList = List<CertificateModel>.from(_currentResume!.certificates)..add(certificate);
    _updateResume(certificates: updatedList);
  }

  void updateCertificate(int index, CertificateModel certificate) {
    if (_currentResume == null) return;
    final updatedList = List<CertificateModel>.from(_currentResume!.certificates);
    updatedList[index] = certificate;
    _updateResume(certificates: updatedList);
  }

  void deleteCertificate(int index) {
    if (_currentResume == null) return;
    final updatedList = List<CertificateModel>.from(_currentResume!.certificates)..removeAt(index);
    _updateResume(certificates: updatedList);
  }

  // References
  void addReference(ReferenceModel reference) {
    if (_currentResume == null) return;
    final updatedList = List<ReferenceModel>.from(_currentResume!.references)..add(reference);
    _updateResume(references: updatedList);
  }

  void updateReference(int index, ReferenceModel reference) {
    if (_currentResume == null) return;
    final updatedList = List<ReferenceModel>.from(_currentResume!.references);
    updatedList[index] = reference;
    _updateResume(references: updatedList);
  }

  void deleteReference(int index) {
    if (_currentResume == null) return;
    final updatedList = List<ReferenceModel>.from(_currentResume!.references)..removeAt(index);
    _updateResume(references: updatedList);
  }

  // Activities (Social & Hobbies)
  void addActivity(ActivityModel activity) {
    if (_currentResume == null) return;
    final updatedList = List<ActivityModel>.from(_currentResume!.activities)..add(activity);
    _updateResume(activities: updatedList);
  }

  void updateActivity(int index, ActivityModel activity) {
    if (_currentResume == null) return;
    final updatedList = List<ActivityModel>.from(_currentResume!.activities);
    updatedList[index] = activity;
    _updateResume(activities: updatedList);
  }

  void deleteActivity(int index) {
    if (_currentResume == null) return;
    final updatedList = List<ActivityModel>.from(_currentResume!.activities)..removeAt(index);
    _updateResume(activities: updatedList);
  }

  void _updateResume({
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    List<String>? skills,
    List<LanguageEntry>? languages,
    List<CertificateModel>? certificates,
    List<ReferenceModel>? references,
    List<ActivityModel>? activities,
  }) {
    if (_currentResume == null) return;
    _currentResume = ResumeModel(
      id: _currentResume!.id,
      targetLanguage: _currentResume!.targetLanguage,
      personalInfo: _currentResume!.personalInfo,
      experience: experience ?? _currentResume!.experience,
      education: education ?? _currentResume!.education,
      skills: skills ?? _currentResume!.skills,
      languages: languages ?? _currentResume!.languages,
      certificates: certificates ?? _currentResume!.certificates,
      references: references ?? _currentResume!.references,
      activities: activities ?? _currentResume!.activities,
      professionalSummary: _currentResume!.professionalSummary,
      createdAt: _currentResume!.createdAt,
      updatedAt: DateTime.now(),
      templateId: _currentResume!.templateId,
      isPremium: _currentResume!.isPremium,
    );
    notifyListeners();
  }

  // Premium
  void upgradeToPremium() {
    if (_currentResume == null) return;
    _currentResume = ResumeModel(
      id: _currentResume!.id,
      targetLanguage: _currentResume!.targetLanguage,
      personalInfo: _currentResume!.personalInfo,
      experience: _currentResume!.experience,
      education: _currentResume!.education,
      skills: _currentResume!.skills,
      languages: _currentResume!.languages,
      certificates: _currentResume!.certificates,
      references: _currentResume!.references,
      activities: _currentResume!.activities,
      professionalSummary: _currentResume!.professionalSummary,
      createdAt: _currentResume!.createdAt,
      updatedAt: DateTime.now(),
      templateId: _currentResume!.templateId,
      isPremium: true,
    );
    notifyListeners();
  }

  // Template
  void switchTemplate(String templateId) {
    if (_currentResume == null) return;
    _currentResume = ResumeModel(
      id: _currentResume!.id,
      targetLanguage: _currentResume!.targetLanguage,
      personalInfo: _currentResume!.personalInfo,
      experience: _currentResume!.experience,
      education: _currentResume!.education,
      skills: _currentResume!.skills,
      languages: _currentResume!.languages,
      certificates: _currentResume!.certificates,
      references: _currentResume!.references,
      activities: _currentResume!.activities,
      professionalSummary: _currentResume!.professionalSummary,
      createdAt: _currentResume!.createdAt,
      updatedAt: DateTime.now(),
      templateId: templateId,
      isPremium: _currentResume!.isPremium,
    );
    notifyListeners();
  }
}
