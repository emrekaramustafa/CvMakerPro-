import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/resume/data/models/personal_info_model.dart';
import '../../features/resume/data/models/experience_model.dart';
import '../../features/resume/data/models/education_model.dart';
import '../../features/resume/data/models/resume_model.dart';
import '../../features/resume/data/models/language_entry.dart';
import '../../features/resume/data/models/certificate_model.dart';
import '../../features/resume/data/models/reference_model.dart';
import '../../features/resume/data/models/activity_model.dart';
import '../../features/resume/data/models/cover_letter_model.dart';

class HiveInit {
  static Future<void> init() async {
    try {
      await _initHive();
    } catch (e) {
      debugPrint('CRITICAL Hive Init FAILED: $e');
      // Nuclear option: close everything, delete all Hive data, re-init
      try {
        await Hive.close();
      } catch (_) {}
      
      try {
        await _deleteAllHiveData();
      } catch (_) {}
      
      // Re-init from scratch
      await _initHive();
    }
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    
    // Register Adapters
    _registerAdapters();
    
    // Clean up any stale lock files before opening boxes
    await _cleanupLockFiles();
    
    // Open Boxes with individual error handling
    await _openBoxSafely<ResumeModel>('resumes');
    await _openBoxSafely<CoverLetterModel>('cover_letters');
    await _openBoxSafely<dynamic>('settings');
  }

  /// Opens a Hive box safely. If it fails, deletes the box and retries.
  static Future<void> _openBoxSafely<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<T>(boxName);
      }
    } catch (e) {
      debugPrint('Error opening box "$boxName": $e');
      try {
        await Hive.deleteBoxFromDisk(boxName);
        debugPrint('Deleted corrupted box "$boxName"');
      } catch (deleteError) {
        debugPrint('Error deleting box "$boxName": $deleteError');
        // Try manual file deletion
        await _manualDeleteBox(boxName);
      }
      // Retry open
      try {
        await Hive.openBox<T>(boxName);
      } catch (retryError) {
        debugPrint('FATAL: Cannot open box "$boxName" even after delete: $retryError');
        // Last resort: just continue, the app will work without this box
      }
    }
  }

  /// Manually delete box files from disk when Hive's own delete fails
  static Future<void> _manualDeleteBox(String boxName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory(appDir.path);
      
      final boxFile = File('${hiveDir.path}/$boxName.hive');
      final lockFile = File('${hiveDir.path}/$boxName.lock');
      
      if (await boxFile.exists()) {
        await boxFile.delete();
        debugPrint('Manually deleted $boxName.hive');
      }
      if (await lockFile.exists()) {
        await lockFile.delete();
        debugPrint('Manually deleted $boxName.lock');
      }
    } catch (e) {
      debugPrint('Manual box deletion failed: $e');
    }
  }

  /// Clean up stale .lock files that may prevent boxes from opening
  static Future<void> _cleanupLockFiles() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory(appDir.path);
      
      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.lock')) {
          try {
            await entity.delete();
            debugPrint('Cleaned up lock file: ${entity.path}');
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('Lock file cleanup error: $e');
    }
  }

  /// Nuclear option: delete ALL Hive data from disk
  static Future<void> _deleteAllHiveData() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory(appDir.path);
      
      await for (final entity in dir.list()) {
        if (entity is File && 
            (entity.path.endsWith('.hive') || entity.path.endsWith('.lock'))) {
          try {
            await entity.delete();
            debugPrint('Deleted: ${entity.path}');
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('Failed to delete all Hive data: $e');
    }
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PersonalInfoModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ExperienceModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(EducationModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ResumeModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(LanguageEntryAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(CertificateModelAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(ReferenceModelAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(ActivityModelAdapter());
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(CoverLetterModelAdapter());
  }
}

