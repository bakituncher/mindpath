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
      goals: List<String>.from(json['goals'] ?? []),
      selectedExam: json['selectedExam'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'])
          : null,
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      stats: UserStats.fromJson(json['stats'] ?? {}),
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
  final int currentStreak;
  final int longestStreak;
  final List<String> completedCourses;
  final List<String> earnedBadges;

  UserStats({
    this.totalMeditationMinutes = 0,
    this.totalBreathingSessions = 0,
    this.totalJournalEntries = 0,
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
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      completedCourses: List<String>.from(json['completedCourses'] ?? []),
      earnedBadges: List<String>.from(json['earnedBadges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMeditationMinutes': totalMeditationMinutes,
      'totalBreathingSessions': totalBreathingSessions,
      'totalJournalEntries': totalJournalEntries,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedCourses': completedCourses,
      'earnedBadges': earnedBadges,
    };
  }
}

