import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/course_model.dart';
import 'package:mindpath/services/course_service.dart';
import 'package:mindpath/services/auth_service.dart';
import 'package:mindpath/services/audio_player_service.dart';

class LessonPlayerScreen extends StatefulWidget {
  final LessonModel lesson;
  final String courseId;
  final Color color;

  const LessonPlayerScreen({
    super.key,
    required this.lesson,
    required this.courseId,
    required this.color,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  final CourseService _courseService = CourseService();
  final AuthService _authService = AuthService();
  final AudioPlayerService _audioService = AudioPlayerService();

  bool _isPlaying = false;
  bool _isCompleted = false;
  double _progress = 0.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.lesson.audioUrl != null) {
      await _audioService.initialize(widget.lesson.audioUrl!);

      _audioService.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
          if (_totalDuration.inSeconds > 0) {
            _progress = position.inSeconds / _totalDuration.inSeconds;
          }
        });
      });

      _audioService.durationStream.listen((duration) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
        });
      });

      _audioService.playbackStateStream.listen((state) {
        setState(() {
          _isPlaying = state;
        });
      });
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  Future<void> _markAsCompleted() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null && !_isCompleted) {
      try {
        await _courseService.completeLesson(
          userId,
          widget.courseId,
          widget.lesson.id,
        );

        setState(() {
          _isCompleted = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎉 Ders tamamlandı!'),
              backgroundColor: AppColors.pastelGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        print('Error completing lesson: $e');
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [widget.color.withOpacity(0.3), AppColors.primaryBeige],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, _isCompleted);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Ders ${widget.lesson.orderIndex + 1}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lesson Title
                      Text(
                        widget.lesson.title,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Container(
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
                        child: Text(
                          widget.lesson.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Audio Player
                      if (widget.lesson.audioUrl != null) ...[
                        Container(
                          padding: const EdgeInsets.all(24),
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
                              // Progress Bar
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: _progress,
                                  activeColor: widget.color,
                                  inactiveColor: widget.color.withOpacity(0.2),
                                  onChanged: (value) async {
                                    final position = Duration(
                                      seconds: (value * _totalDuration.inSeconds).toInt(),
                                    );
                                    await _audioService.seek(position);
                                  },
                                ),
                              ),

                              // Time Labels
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_currentPosition),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      _formatDuration(_totalDuration),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Play/Pause Button
                              GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: widget.color,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.color.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: AppColors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Text Content
                      if (widget.lesson.textContent != null) ...[
                        Container(
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
                                  Icon(
                                    Icons.article_outlined,
                                    color: widget.color,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ders İçeriği',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.lesson.textContent!,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.8,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Complete Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isCompleted ? null : _markAsCompleted,
                          icon: Icon(
                            _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                          ),
                          label: Text(
                            _isCompleted ? 'Tamamlandı' : 'Dersi Tamamla',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCompleted
                                ? AppColors.mediumGray
                                : widget.color,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

