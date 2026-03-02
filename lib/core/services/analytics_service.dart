import 'dart:developer';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Mixpanel? _mixpanel;
  bool _isInitialized = false;

  // Replace with your actual project token
  static const String _projectToken = '5b5130c5f85b958947fb280dcb009b7b';

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      _mixpanel = await Mixpanel.init(
        _projectToken,
        trackAutomaticEvents: true,
        optOutTrackingDefault: false,
      );
      
      // Since your project snippet included api_host: 'https://api-eu.mixpanel.com'
      _mixpanel?.setServerURL('https://api-eu.mixpanel.com');

      _isInitialized = true;
      log('✅ Mixpanel Analytics Initialized Successfully');
      
      // Track initial app open
      trackEvent('app_open');
    } catch (e) {
      log('❌ Failed to initialize Mixpanel: $e');
    }
  }

  /// Identifies a user with a unique ID
  void identifyUser(String userId) {
    if (!_isInitialized) return;
    _mixpanel?.identify(userId);
    log('👤 Mixpanel User Identified: $userId');
  }

  /// Sets user properties (e.g. name, email, plan type)
  void setUserProperties(Map<String, dynamic> properties) {
    if (!_isInitialized) return;
    for (var entry in properties.entries) {
      _mixpanel?.getPeople().set(entry.key, entry.value);
    }
  }

  /// Tracks a specific event with optional properties
  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    if (!_isInitialized) return;
    _mixpanel?.track(eventName, properties: properties);
    log('📈 Mixpanel Event: $eventName | Properties: $properties');
  }

  /// Resets the user identity (useful on logout)
  void reset() {
    if (!_isInitialized) return;
    _mixpanel?.reset();
    log('🔄 Mixpanel Identity Reset');
  }
}
