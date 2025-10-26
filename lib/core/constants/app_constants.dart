class AppConstants {
  // App Info
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API & Services
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Meditation
  static const List<int> meditationDurations = [3, 5, 10, 15, 20, 30];
  static const int defaultMeditationDuration = 5;
  static const List<String> voiceOptions = ['female', 'male', 'silent'];

  // Breathing
  static const int maxBreathingCycles = 20;
  static const int minBreathingCycles = 3;

  // Journal
  static const int maxJournalTitleLength = 100;
  static const int maxJournalContentLength = 5000;
  static const int minMoodScore = 1;
  static const int maxMoodScore = 10;

  // Notifications
  static const String dailyReminderChannelId = 'daily_reminder';
  static const String dailyReminderChannelName = 'Daily Reminders';
  static const int dailyReminderNotificationId = 1;

  // Cache
  static const int imageCacheDays = 7;
  static const int audioCacheDays = 30;

  // Pagination
  static const int itemsPerPage = 20;

  // Achievements
  static const Map<String, int> achievementThresholds = {
    'first_meditation': 1,
    'meditation_week': 7,
    'meditation_month': 30,
    'meditation_100_minutes': 100,
    'meditation_500_minutes': 500,
    'meditation_1000_minutes': 1000,
    'journal_week': 7,
    'journal_month': 30,
    'first_course': 1,
    'all_courses': 5,
  };

  // Premium Features
  static const List<String> premiumFeatures = [
    'advanced_meditations',
    'all_courses',
    'ai_coach_unlimited',
    'custom_programs',
    'offline_access',
  ];

  // Social
  static const int maxCommunityPostLength = 280;
  static const int maxReportReasonLength = 500;

  // Audio
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const double defaultVolume = 0.7;
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5];

  // URLs
  static const String privacyPolicyUrl = 'https://mindpath.app/privacy';
  static const String termsOfServiceUrl = 'https://mindpath.app/terms';
  static const String supportEmail = 'info@mindpath.app';
  static const String websiteUrl = 'https://mindpath.app';

  // Error Messages
  static const String errorGeneric = 'Bir hata oluştu. Lütfen tekrar deneyin.';
  static const String errorNetwork = 'İnternet bağlantınızı kontrol edin.';
  static const String errorAuth = 'Oturum süreniz doldu. Lütfen tekrar giriş yapın.';
  static const String errorPermission = 'Bu işlem için izin gerekiyor.';

  // Success Messages
  static const String successSave = 'Başarıyla kaydedildi';
  static const String successUpdate = 'Başarıyla güncellendi';
  static const String successDelete = 'Başarıyla silindi';
}

class FirestoreCollections {
  static const String users = 'users';
  static const String meditations = 'meditations';
  static const String meditationSessions = 'meditation_sessions';
  static const String journalEntries = 'journal_entries';
  static const String courses = 'courses';
  static const String userProgress = 'user_progress';
  static const String sleepStories = 'sleep_stories';
  static const String breathingExercises = 'breathing_exercises';
  static const String communityPosts = 'community_posts';
  static const String userActivity = 'user_activity';
  static const String analyticsEvents = 'analytics_events';
  static const String questionReports = 'question_reports';
}

class StoragePaths {
  static const String audio = 'audio';
  static const String images = 'images';
  static const String userRecordings = 'user_recordings';
  static const String profilePictures = 'profile_pictures';
  static const String courseThumbnails = 'course_thumbnails';
}

