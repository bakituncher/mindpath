import 'package:flutter/material.dart';
import 'package:mindpath/models/user_model.dart';
import 'package:mindpath/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        _currentUser = await _authService.getUserData(uid);
      }
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    if (_currentUser == null) return;

    try {
      await _authService.updateUserData(_currentUser!.id, data);
      await loadUser();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateStats({
    int? meditationMinutes,
    int? breathingSessions,
    int? journalEntries,
  }) {
    if (_currentUser == null) return;

    final newStats = UserStats(
      totalMeditationMinutes: _currentUser!.stats.totalMeditationMinutes +
          (meditationMinutes ?? 0),
      totalBreathingSessions: _currentUser!.stats.totalBreathingSessions +
          (breathingSessions ?? 0),
      totalJournalEntries: _currentUser!.stats.totalJournalEntries +
          (journalEntries ?? 0),
      currentStreak: _currentUser!.stats.currentStreak,
      longestStreak: _currentUser!.stats.longestStreak,
      completedCourses: _currentUser!.stats.completedCourses,
      earnedBadges: _currentUser!.stats.earnedBadges,
    );

    _currentUser = _currentUser!.copyWith(stats: newStats);
    notifyListeners();

    // Update in Firestore
    updateUser({'stats': newStats.toJson()});
  }
}

