import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/core/constants/app_strings.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      CourseInfo(
        title: AppStrings.mindfulnessScience,
        description: 'Farkındalığın bilimsel temellerini keşfet',
        lessons: 7,
        duration: 120,
        icon: Icons.science_outlined,
        color: AppColors.pastelGreen,
      ),
      CourseInfo(
        title: AppStrings.emotionalIntelligence,
        description: 'Duygusal zekayı geliştir ve farkındalığı artır',
        lessons: 6,
        duration: 90,
        icon: Icons.favorite_outline,
        color: AppColors.lavender,
      ),
      CourseInfo(
        title: AppStrings.breakStressCycle,
        description: 'Stresi anlayıp yönetmeyi öğren',
        lessons: 5,
        duration: 75,
        icon: Icons.spa_outlined,
        color: AppColors.calmTeal,
      ),
      CourseInfo(
        title: AppStrings.powerOfCompassion,
        description: 'Kendine ve başkalarına şefkatle yaklaş',
        lessons: 6,
        duration: 85,
        icon: Icons.volunteer_activism_outlined,
        color: AppColors.peach,
      ),
      CourseInfo(
        title: AppStrings.mindfulEating,
        description: 'Yemek yerken farkında ol',
        lessons: 5,
        duration: 60,
        icon: Icons.restaurant_outlined,
        color: AppColors.energyOrange,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.pastelGreen.withOpacity(0.3), AppColors.primaryBeige],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Eğitim Serileri',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uzman rehberliğinde farkındalık öğren',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(course: course);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseInfo {
  final String title;
  final String description;
  final int lessons;
  final int duration;
  final IconData icon;
  final Color color;

  CourseInfo({
    required this.title,
    required this.description,
    required this.lessons,
    required this.duration,
    required this.icon,
    required this.color,
  });
}

class CourseCard extends StatelessWidget {
  final CourseInfo course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  course.icon,
                  size: 32,
                  color: course.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 14,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.lessons} bölüm',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.duration} dk',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            course.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to course details
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: course.color,
              ),
              child: const Text('Kursa Başla'),
            ),
          ),
        ],
      ),
    );
  }
}

