import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/course_model.dart';
import 'package:mindpath/services/course_service.dart';
import 'package:mindpath/services/auth_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseService _courseService = CourseService();
  final AuthService _authService = AuthService();
  List<String> _completedLessons = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final progress = await _courseService.getCourseProgress(userId, widget.course.id);
      if (progress != null) {
        setState(() {
          _completedLessons = List<String>.from(progress['completedLessons'] ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCourseColor(widget.course.tags);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.3), AppColors.primaryBeige],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_completedLessons.length}/${widget.course.totalLessons} Tamamlandı',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.course.title,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.course.instructor,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.mediumGray,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.course.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // Lessons List
              Expanded(
                child: StreamBuilder<List<LessonModel>>(
                  stream: _courseService.getCourseLessons(widget.course.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Dersler yüklenirken hata oluştu',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    final lessons = snapshot.data ?? [];

                    if (lessons.isEmpty) {
                      return Center(
                        child: Text(
                          'Bu kursta henüz ders bulunmuyor',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: lessons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        final isCompleted = _completedLessons.contains(lesson.id);
                        final isLocked = index > 0 && !_completedLessons.contains(lessons[index - 1].id);

                        return _LessonTile(
                          lesson: lesson,
                          color: color,
                          isCompleted: isCompleted,
                          isLocked: isLocked,
                          onTap: () async {
                            if (!isLocked) {
                              final result = await Navigator.pushNamed(
                                context,
                                '/lesson-player',
                                arguments: {
                                  'lesson': lesson,
                                  'courseId': widget.course.id,
                                  'color': color,
                                },
                              );

                              if (result == true) {
                                _loadProgress();
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCourseColor(List<String> tags) {
    if (tags.contains('science') || tags.contains('bilim')) {
      return AppColors.pastelGreen;
    } else if (tags.contains('emotion') || tags.contains('duygu')) {
      return AppColors.lavender;
    } else if (tags.contains('stress') || tags.contains('stres')) {
      return AppColors.calmTeal;
    } else if (tags.contains('compassion') || tags.contains('şefkat')) {
      return AppColors.peach;
    }
    return AppColors.energyOrange;
  }
}

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final Color color;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.color,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted
                  ? color
                  : isLocked
                      ? AppColors.lightGray
                      : color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: AppColors.white)
                  : isLocked
                      ? const Icon(Icons.lock_outline, color: AppColors.mediumGray)
                      : Text(
                          '${lesson.orderIndex + 1}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
            ),
          ),
          title: Text(
            lesson.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: AppColors.mediumGray,
                ),
                const SizedBox(width: 4),
                Text(
                  '${lesson.durationMinutes} dakika',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (lesson.audioUrl != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.headphones,
                    size: 14,
                    color: AppColors.mediumGray,
                  ),
                ],
                if (lesson.videoUrl != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.play_circle_outline,
                    size: 14,
                    color: AppColors.mediumGray,
                  ),
                ],
              ],
            ),
          ),
          trailing: isLocked
              ? null
              : Icon(
                  Icons.chevron_right,
                  color: color,
                ),
          onTap: isLocked ? null : onTap,
        ),
      ),
    );
  }
}

