import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

/// Tracks free-trial usage per feature and weekly AI usage for premium users.
/// All data is stored locally with Hive under the 'usage_limits' box.
class UsageLimitService {
  static const String _boxName = 'usage_limits';
  static const String _weeklyAiCountKey = 'weekly_ai_count';
  static const String _weeklyAiResetKey = 'weekly_ai_reset_date';

  // Feature keys ─ used as Hive keys for free-trial counters
  static const String featureAiOptimize  = 'feat_ai_optimize';
  static const String featureAiAnalyze   = 'feat_ai_analyze';
  static const String featureCoverLetter = 'feat_cover_letter';
  static const String featurePdfImport   = 'feat_pdf_import';

  Future<Box> get _box async => Hive.isBoxOpen(_boxName)
      ? Hive.box(_boxName)
      : await Hive.openBox(_boxName);

  // ─────────────────────────────────────────────
  // FREE TRIAL helpers
  // ─────────────────────────────────────────────

  /// Returns true if the user has NOT yet used their free trial for [featureKey].
  Future<bool> hasFreeTrialRemaining(String featureKey) async {
    final box = await _box;
    final usedCount = box.get(featureKey, defaultValue: 0) as int;
    return usedCount < AppConstants.freeAiTrialCount;
  }

  /// Records one free-trial use for [featureKey].
  Future<void> recordFreeTrialUsage(String featureKey) async {
    final box = await _box;
    final usedCount = box.get(featureKey, defaultValue: 0) as int;
    await box.put(featureKey, usedCount + 1);
  }

  // ─────────────────────────────────────────────
  // WEEKLY AI LIMIT helpers (premium users only)
  // ─────────────────────────────────────────────

  /// Returns current weekly AI call count (resets automatically if week changed).
  Future<int> getWeeklyAiUsage() async {
    final box = await _box;
    await _resetWeeklyCounterIfNeeded(box);
    return box.get(_weeklyAiCountKey, defaultValue: 0) as int;
  }

  /// Returns true if premium user has exhausted their weekly AI limit.
  Future<bool> hasWeeklyAiLimitReached() async {
    final count = await getWeeklyAiUsage();
    return count >= AppConstants.weeklyAiLimitPremium;
  }

  /// Records one AI call (for premium weekly counter).
  Future<void> recordWeeklyAiUsage() async {
    final box = await _box;
    await _resetWeeklyCounterIfNeeded(box);
    final count = box.get(_weeklyAiCountKey, defaultValue: 0) as int;
    await box.put(_weeklyAiCountKey, count + 1);
  }

  /// Resets usage data (useful in tests or debug).
  Future<void> resetAll() async {
    final box = await _box;
    await box.clear();
  }

  // ─────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────

  Future<void> _resetWeeklyCounterIfNeeded(Box box) async {
    final storedDateStr = box.get(_weeklyAiResetKey) as String?;
    final now = DateTime.now();

    if (storedDateStr == null) {
      // First time — set the start-of-week date
      await box.put(_weeklyAiResetKey, _weekStart(now).toIso8601String());
      await box.put(_weeklyAiCountKey, 0);
      return;
    }

    final storedDate = DateTime.parse(storedDateStr);
    final currentWeekStart = _weekStart(now);

    if (currentWeekStart.isAfter(storedDate)) {
      // New week — reset counter
      await box.put(_weeklyAiResetKey, currentWeekStart.toIso8601String());
      await box.put(_weeklyAiCountKey, 0);
    }
  }

  /// Returns the Monday 00:00:00 of the week containing [date].
  DateTime _weekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1; // weekday: Mon=1 … Sun=7
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
}
