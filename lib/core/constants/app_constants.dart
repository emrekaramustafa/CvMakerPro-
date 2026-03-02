class AppConstants {
  // ── OpenAI ──────────────────────────────────────────────────────────────
  // Pass at build time:
  //   flutter build ipa --dart-define=OPENAI_API_KEY=sk-...
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // ── RevenueCat ──────────────────────────────────────────────────────────
  // Pass at build time:
  //   flutter build ipa --dart-define=RC_IOS_KEY=appl_...
  //   flutter build apk --dart-define=RC_ANDROID_KEY=goog_...
  static const String revenueCatIosKey = String.fromEnvironment(
    'RC_IOS_KEY',
    defaultValue: '',
  );

  static const String revenueCatAndroidKey = String.fromEnvironment(
    'RC_ANDROID_KEY',
    defaultValue: '',
  );

  // RevenueCat entitlement ID — must match exactly what you set in the RC dashboard
  static const String revenueCatEntitlement = 'premium';

  // RevenueCat offering ID — 'default' unless you created a custom one
  static const String revenueCatOffering = 'default';

  // ── Free trial limits ────────────────────────────────────────────────────
  static const int freeAiTrialCount = 3;

  // ── Premium weekly AI usage limit ────────────────────────────────────────
  static const int weeklyAiLimitPremium = 50;
}
