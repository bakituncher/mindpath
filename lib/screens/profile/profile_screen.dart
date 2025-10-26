import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/services/auth_service.dart';
import 'package:mindpath/services/achievement_service.dart';
import 'package:mindpath/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final AchievementService _achievementService = AchievementService();

  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        final userData = await _authService.getUserData(userId);
        setState(() {
          _user = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.morningGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.pastelGreen,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.morningGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.pastelGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _user?.displayName ?? _user?.email ?? 'Kullanıcı',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${_user?.stats.totalMeditationMinutes ?? 0}',
                          'Meditasyon\nDakikası',
                          Icons.self_improvement,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${_user?.stats.totalJournalEntries ?? 0}',
                          'Günlük\nGiriş',
                          Icons.book,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${_user?.stats.currentStreak ?? 0}',
                          'Gün\nSeri',
                          Icons.local_fire_department,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${_user?.stats.completedCourses.length ?? 0}',
                          'Tamamlanan\nKurs',
                          Icons.school,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (_user != null) _buildAchievementsSection(),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.settings_outlined,
                        'Ayarlar',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.notifications_outlined,
                        'Bildirimler',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'Yardım & Destek',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.info_outline,
                        'Hakkında',
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        Icons.logout,
                        'Çıkış Yap',
                        () async {
                          await _authService.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.pastelGreen,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mediumGray,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.darkGray,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : AppColors.darkGray,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildAchievementsSection() {
    final unlockedBadges = _achievementService.getUnlockedBadges(_user!.stats);
    final nextBadge = _achievementService.getNextBadge(_user!.stats);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.energyOrange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Rozetler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${unlockedBadges.length}/10',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.pastelGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (unlockedBadges.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: unlockedBadges.take(6).map((badge) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.pastelGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.pastelGreen.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      badge.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Henüz rozet kazanmadın.\nİlk meditasyonunu başlat!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mediumGray,
                      ),
                ),
              ),
            ),
          if (nextBadge != null) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.lightGray),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mediumGray.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.3,
                      child: Text(
                        nextBadge.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextBadge.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextBadge.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mediumGray,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _achievementService.getProgressPercentage(
                            nextBadge.id,
                            _user!.stats,
                          ),
                          backgroundColor: AppColors.lightGray.withOpacity(0.3),
                          color: AppColors.pastelGreen,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

