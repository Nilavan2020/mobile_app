import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleService extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // Single-language mode; localization selection removed.
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
  ];

  LocaleService() {
    _locale = const Locale('en');
  }

  Future<void> setLanguage(String languageCode) async {
    // No-op; app stays in English.
    _locale = const Locale('en');
    notifyListeners();
  }

  String getLanguageName(String code) {
    return 'English';
  }

  static String translate(String key, String languageCode) {
    final translations = _translations[languageCode] ?? _translations['en']!;
    return translations[key] ?? key;
  }
  
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Common
      'app_name': 'Smart Safety Welfare',
      'welcome': 'Smart Safety Welfare',
      'get_started': 'Get Started',
      'choose_language': 'Choose Your Language',
      'select_language': 'Select Language',
      'save': 'Save',
      'cancel': 'Cancel',
      'logout': 'Logout',
      'settings': 'Settings',
      'profile_info': 'Profile Info',
      'change_password': 'Change Password',
      'language': 'Language',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'detections': 'Detections',
      'sessions': 'Sessions',
      'alerts': 'Alerts',
      'total_sessions': 'Total Sessions',
      'total_detections': 'Total Detections',
      'total_alerts': 'Total Alerts',
      'behavior_distribution': 'Behavior Distribution',
      'calm': 'Calm',
      'warning': 'Warning',
      'aggressive': 'Aggressive',
      'active': 'Active',
      'all_time': 'All time',
      'recent_sessions': 'Recent Sessions',
      'view_all': 'View All',
      'status': 'Status',
      'running': 'Running',
      'completed': 'Completed',
      'stopped': 'Stopped',
      'error': 'Error',
      'view': 'View',
      'search': 'Search',
      'filter': 'Filter',
      'clear': 'Clear',
      'no_data': 'No data available',
      'loading': 'Loading...',
      'failed_to_load': 'Failed to load data',
      'description': 'Stay safer with SOS alerts, missing-person search, and disaster relief coordination—all in one app.',
      'failed_to_load_dashboard': 'Failed to load dashboard data',
      'active_sessions': 'Active Sessions',
      'detections_label': 'Detections',
      'sessions_per_day': 'Sessions Per Day (Last 7 Days)',
      'detections_per_hour': 'Detections Per Hour (Last 24 Hours)',
      'alert_types_distribution': 'Alert Types Distribution',
      'no_alerts_data': 'No alerts data',
      'next': 'Next',
      'ai_elephant_detection': 'AI-Powered Elephant Detection',
      'elephant_detection_desc': 'Detect elephants in real-time using smart cameras and sensors. The system analyzes movement and predicts aggressive actions early to ensure safety.',
      'monitor_manage': 'Monitor & Manage',
      'monitor_manage_desc': 'Access live data, incident reports, and intelligent insights through the mobile dashboard. Analyze patterns to improve safety strategies and protect both humans and elephants.',
      'instant_alerts': 'Instant Alerts',
      'instant_alerts_desc': 'Receive immediate notifications when elephants are detected nearby. Stay informed with real-time alerts on your mobile device to take timely action.',
      'frames': 'frames',
      'session': 'Session',
      'elephant_aggression_detection': 'Elephant Aggression Detection',
      'elephant_aggression_detection_desc': 'Detect early signs of aggressive behavior using AI. The system analyzes posture, speed, trunk and ear movement to predict risk and trigger timely responses.',
      'adaptive_response_distance': 'Adaptive Response by Distance',
      'adaptive_response_distance_desc': 'Smart Safety Welfare intelligently measures proximity and threat levels. From gentle alerts to loud deterrents — the system reacts smartly based on the threat level.',
      'pending_approval': 'Pending Approval',
      'waitlist_message': 'You are currently on the waitlist',
      'waitlist_description': 'Please wait for the admin to approve your account.',
      'go_back': 'GO BACK',
      'login': 'Login',
      'create_account': 'Create Account',
    },
  };
}

