import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/core/constants/app_strings.dart';
import 'package:mindpath/screens/breathing/breathing_exercise_screen.dart';
import 'package:mindpath/screens/courses/course_list_screen.dart';
import 'package:mindpath/screens/ai_coach/ai_coach_screen.dart';
import 'package:mindpath/screens/sleep/sleep_stories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.morningGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bugün kendine nasıl zaman ayıracaksın?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Daily Quote Card
                _buildDailyQuoteCard(),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Hızlı Başlat',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildQuickActions(),

                const SizedBox(height: 32),

                // Featured Content
                Text(
                  'Önerilen İçerik',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildFeaturedContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Günaydın ☀️';
    } else if (hour < 18) {
      return 'İyi Günler 🌤️';
    } else {
      return 'İyi Akşamlar 🌙';
    }
  }

  Widget _buildDailyQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.meditationGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.pastelGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote,
            size: 32,
            color: AppColors.white,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.motivCalmMind,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildQuickActionCard(
          title: '5 Dakika Meditasyon',
          icon: Icons.self_improvement,
          color: AppColors.pastelGreen,
          onTap: () {
            // Navigate to meditation
          },
        ),
        _buildQuickActionCard(
          title: 'Nefes Egzersizi',
          icon: Icons.air,
          color: AppColors.pastelBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BreathingExerciseScreen()),
            );
          },
        ),
        _buildQuickActionCard(
          title: 'Günlük Yaz',
          icon: Icons.edit_note,
          color: AppColors.lavender,
          onTap: () {
            // Navigate to journal
          },
        ),
        _buildQuickActionCard(
          title: 'AI Coach',
          icon: Icons.chat_bubble_outline,
          color: AppColors.peach,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiCoachScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGray,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFeaturedCard(
            title: 'Uyku Hikayeleri',
            description: 'Rahat bir uykuya dalın',
            icon: Icons.bedtime,
            gradient: AppColors.eveningGradient,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SleepStoriesScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
          _buildFeaturedCard(
            title: 'Eğitim Serileri',
            description: 'Farkındalığı öğren',
            icon: Icons.school_outlined,
            gradient: LinearGradient(
              colors: [AppColors.lavender, AppColors.pastelBlue],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CourseListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

