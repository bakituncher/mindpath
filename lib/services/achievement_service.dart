import 'package:mindpath/models/user_model.dart';
import 'package:mindpath/core/constants/app_constants.dart';

class AchievementBadge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int threshold;
  final bool isUnlocked;

  AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.threshold,
    this.isUnlocked = false,
  });
}

class AchievementService {
  /// Kullanıcının tüm rozetlerini hesapla
  List<AchievementBadge> calculateAchievements(UserStats stats) {
    final badges = <AchievementBadge>[
      // Meditasyon rozetleri
      AchievementBadge(
        id: 'first_meditation',
        title: 'İlk Adım',
        description: 'İlk meditasyonunu tamamladın',
        icon: '🌱',
        threshold: AppConstants.achievementThresholds['first_meditation']!,
        isUnlocked: stats.totalMeditationMinutes >= 1,
      ),
      AchievementBadge(
        id: 'meditation_week',
        title: '7 Günlük Seri',
        description: '7 gün üst üste meditasyon yaptın',
        icon: '🔥',
        threshold: AppConstants.achievementThresholds['meditation_week']!,
        isUnlocked: stats.currentStreak >= 7,
      ),
      AchievementBadge(
        id: 'meditation_month',
        title: 'Ay Boyu Farkındalık',
        description: '30 gün üst üste meditasyon yaptın',
        icon: '🌟',
        threshold: AppConstants.achievementThresholds['meditation_month']!,
        isUnlocked: stats.currentStreak >= 30,
      ),
      AchievementBadge(
        id: 'meditation_100_minutes',
        title: '100 Dakika',
        description: 'Toplam 100 dakika meditasyon',
        icon: '⏱️',
        threshold: AppConstants.achievementThresholds['meditation_100_minutes']!,
        isUnlocked: stats.totalMeditationMinutes >= 100,
      ),
      AchievementBadge(
        id: 'meditation_500_minutes',
        title: 'Meditasyon Ustası',
        description: 'Toplam 500 dakika meditasyon',
        icon: '🧘',
        threshold: AppConstants.achievementThresholds['meditation_500_minutes']!,
        isUnlocked: stats.totalMeditationMinutes >= 500,
      ),
      AchievementBadge(
        id: 'meditation_1000_minutes',
        title: 'Zen Ustası',
        description: 'Toplam 1000 dakika meditasyon',
        icon: '🏆',
        threshold: AppConstants.achievementThresholds['meditation_1000_minutes']!,
        isUnlocked: stats.totalMeditationMinutes >= 1000,
      ),

      // Günlük rozetleri
      AchievementBadge(
        id: 'journal_week',
        title: 'Günlük Tutucu',
        description: '7 günlük kaydı tamamladın',
        icon: '📖',
        threshold: AppConstants.achievementThresholds['journal_week']!,
        isUnlocked: stats.totalJournalEntries >= 7,
      ),
      AchievementBadge(
        id: 'journal_month',
        title: 'Düşünce Yazarı',
        description: '30 günlük kaydı tamamladın',
        icon: '✍️',
        threshold: AppConstants.achievementThresholds['journal_month']!,
        isUnlocked: stats.totalJournalEntries >= 30,
      ),

      // Kurs rozetleri
      AchievementBadge(
        id: 'first_course',
        title: 'Öğrenci',
        description: 'İlk kursunu tamamladın',
        icon: '🎓',
        threshold: AppConstants.achievementThresholds['first_course']!,
        isUnlocked: stats.completedCourses.isNotEmpty,
      ),
      AchievementBadge(
        id: 'all_courses',
        title: 'Bilge',
        description: 'Tüm kursları tamamladın',
        icon: '🌈',
        threshold: AppConstants.achievementThresholds['all_courses']!,
        isUnlocked: stats.completedCourses.length >= 5,
      ),
    ];

    return badges;
  }

  /// Kilidi açılmış rozetleri getir
  List<AchievementBadge> getUnlockedBadges(UserStats stats) {
    return calculateAchievements(stats).where((b) => b.isUnlocked).toList();
  }

  /// Kilitli rozetleri getir
  List<AchievementBadge> getLockedBadges(UserStats stats) {
    return calculateAchievements(stats).where((b) => !b.isUnlocked).toList();
  }

  /// Bir sonraki kilidi açılacak rozeti getir
  AchievementBadge? getNextBadge(UserStats stats) {
    final locked = getLockedBadges(stats);
    if (locked.isEmpty) return null;

    // En yakın threshold'a sahip rozeti bul
    locked.sort((a, b) {
      final aDiff = a.threshold - _getCurrentValue(a.id, stats);
      final bDiff = b.threshold - _getCurrentValue(b.id, stats);
      return aDiff.compareTo(bDiff);
    });

    return locked.first;
  }

  /// Rozet ID'sine göre mevcut değeri getir
  int _getCurrentValue(String badgeId, UserStats stats) {
    if (badgeId.contains('meditation') && badgeId.contains('minutes')) {
      return stats.totalMeditationMinutes;
    } else if (badgeId.contains('meditation') && (badgeId.contains('week') || badgeId.contains('month'))) {
      return stats.currentStreak;
    } else if (badgeId.contains('journal')) {
      return stats.totalJournalEntries;
    } else if (badgeId.contains('course')) {
      return stats.completedCourses.length;
    }
    return 0;
  }

  /// Rozete ilerleme yüzdesi
  double getProgressPercentage(String badgeId, UserStats stats) {
    final currentValue = _getCurrentValue(badgeId, stats);
    final threshold = AppConstants.achievementThresholds[badgeId] ?? 1;
    return (currentValue / threshold).clamp(0.0, 1.0);
  }
}

