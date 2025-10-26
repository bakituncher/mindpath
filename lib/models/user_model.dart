class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final List<String> goals;
  final String? selectedExam;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final UserPreferences preferences;
  final UserStats stats;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.goals = const [],
    this.selectedExam,
    required this.createdAt,
    this.lastActiveAt,
    required this.preferences,
    required this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      goals: (json['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      selectedExam: json['selectedExam'],
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastActiveAt: json['lastActiveAt'] != null && json['lastActiveAt'] is String
          ? DateTime.parse(json['lastActiveAt'])
          : null,
      preferences: json['preferences'] is Map<String, dynamic>
          ? UserPreferences.fromJson(json['preferences'])
          : UserPreferences(),
      stats: json['stats'] is Map<String, dynamic>
          ? UserStats.fromJson(json['stats'])
          : UserStats(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'goals': goals,
      'selectedExam': selectedExam,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    List<String>? goals,
    String? selectedExam,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      goals: goals ?? this.goals,
      selectedExam: selectedExam ?? this.selectedExam,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

class UserPreferences {
  final String voiceGender; // 'male', 'female', 'silent'
  final double volume;
  final bool notificationsEnabled;
  final String? notificationTime;
  final bool darkMode;
  final String language;

  UserPreferences({
    this.voiceGender = 'female',
    this.volume = 0.7,
    this.notificationsEnabled = true,
    this.notificationTime,
    this.darkMode = false,
    this.language = 'tr',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      voiceGender: json['voiceGender'] ?? 'female',
      volume: (json['volume'] ?? 0.7).toDouble(),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      notificationTime: json['notificationTime'],
      darkMode: json['darkMode'] ?? false,
      language: json['language'] ?? 'tr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voiceGender': voiceGender,
      'volume': volume,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime,
      'darkMode': darkMode,
      'language': language,
    };
  }
}

class UserStats {
  final int totalMeditationMinutes;
  final int totalBreathingSessions;
  final int totalJournalEntries;
  final int totalSleepMinutes;
  final int currentStreak;
  final int longestStreak;
  final List<String> completedCourses;
  final List<String> earnedBadges;

  UserStats({
    this.totalMeditationMinutes = 0,
    this.totalBreathingSessions = 0,
    this.totalJournalEntries = 0,
    this.totalSleepMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completedCourses = const [],
    this.earnedBadges = const [],
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalMeditationMinutes: json['totalMeditationMinutes'] ?? 0,
      totalBreathingSessions: json['totalBreathingSessions'] ?? 0,
      totalJournalEntries: json['totalJournalEntries'] ?? 0,
      totalSleepMinutes: json['totalSleepMinutes'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      completedCourses: (json['completedCourses'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      earnedBadges: (json['earnedBadges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMeditationMinutes': totalMeditationMinutes,
      'totalBreathingSessions': totalBreathingSessions,
      'totalJournalEntries': totalJournalEntries,
      'totalSleepMinutes': totalSleepMinutes,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedCourses': completedCourses,
      'earnedBadges': earnedBadges,
    };
  }
}

