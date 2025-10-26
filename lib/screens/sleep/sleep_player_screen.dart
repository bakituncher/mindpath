import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/sleep_story_model.dart';
import 'package:mindpath/services/audio_player_service.dart';
import 'package:mindpath/services/ambient_audio_service.dart';
import 'package:mindpath/services/sleep_service.dart';
import 'package:mindpath/services/auth_service.dart';

class SleepPlayerScreen extends StatefulWidget {
  final SleepStoryModel story;

  const SleepPlayerScreen({super.key, required this.story});

  @override
  State<SleepPlayerScreen> createState() => _SleepPlayerScreenState();
}

class _SleepPlayerScreenState extends State<SleepPlayerScreen> {
  final AudioPlayerService _audioService = AudioPlayerService();
  final AmbientAudioService _ambientService = AmbientAudioService();
  final SleepService _sleepService = SleepService();
  final AuthService _authService = AuthService();

  bool _isPlaying = false;
  double _progress = 0.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Ambient sound
  String? _selectedAmbient;
  double _ambientVolume = 0.3;

  // Sleep timer
  int? _sleepTimerMinutes;
  Timer? _sleepTimer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _selectedAmbient = widget.story.ambientSound;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.story.audioUrl != null) {
      await _audioService.initialize(widget.story.audioUrl!);

      _audioService.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
            if (_totalDuration.inSeconds > 0) {
              _progress = position.inSeconds / _totalDuration.inSeconds;
            }
          });
        }
      });

      _audioService.durationStream.listen((duration) {
        if (mounted) {
          setState(() {
            _totalDuration = duration ?? Duration.zero;
          });
        }
      });

      _audioService.playbackStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state;
          });
        }
      });

      // Oynatma bittiğinde
      _audioService.completionStream.listen((completed) {
        if (completed) {
          _onPlaybackCompleted();
        }
      });
    }
  }

  Future<void> _onPlaybackCompleted() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _sleepService.recordSleepStorySession(
        userId: userId,
        storyId: widget.story.id,
        durationMinutes: widget.story.durationMinutes,
      );
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    _ambientService.dispose();
    _sleepTimer?.cancel();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
      if (_selectedAmbient != null) {
        await _ambientService.stopAmbient();
      }
    } else {
      await _audioService.play();
      if (_selectedAmbient != null) {
        await _ambientService.playAmbient(_selectedAmbient!, volume: _ambientVolume);
      }
    }
  }

  Future<void> _toggleAmbient(String? ambient) async {
    setState(() {
      _selectedAmbient = ambient;
    });

    await _ambientService.stopAmbient();
    if (ambient != null && _isPlaying) {
      await _ambientService.playAmbient(ambient, volume: _ambientVolume);
    }
  }

  void _setSleepTimer(int? minutes) {
    _sleepTimer?.cancel();

    setState(() {
      _sleepTimerMinutes = minutes;
      _remainingTime = minutes != null ? Duration(minutes: minutes) : Duration.zero;
    });

    if (minutes != null) {
      _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });

        if (_remainingTime.inSeconds <= 0) {
          timer.cancel();
          _fadeOutAndStop();
        }
      });
    }
  }

  Future<void> _fadeOutAndStop() async {
    // 10 saniyede fade out
    const steps = 10;
    const stepDuration = Duration(seconds: 1);

    for (int i = steps; i > 0; i--) {
      await Future.delayed(stepDuration);
      if (mounted) {
        await _audioService.setVolume(i / steps);
        await _ambientService.setVolume(_ambientVolume * (i / steps));
      }
    }

    await _audioService.pause();
    await _ambientService.stopAmbient();
    await _audioService.setVolume(1.0);
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
        decoration: const BoxDecoration(
          gradient: AppColors.nightGradient,
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
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Uyku Hikayesi',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                            ),
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
                    children: [
                      // Story Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.pastelBlue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.nightlight_round,
                          size: 64,
                          color: AppColors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        widget.story.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.story.narrator,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                      ),

                      const SizedBox(height: 32),

                      // Player Controls
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Progress Bar
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbColor: AppColors.white,
                                activeTrackColor: AppColors.white,
                                inactiveTrackColor: AppColors.white.withOpacity(0.3),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                              ),
                              child: Slider(
                                value: _progress,
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
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(_totalDuration),
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Play/Pause Button
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.pastelBlue,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.pastelBlue.withOpacity(0.4),
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

                      // Ambient Sounds
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arka Plan Sesi',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildAmbientButton('Yok', null, Icons.volume_off),
                                _buildAmbientButton('Yağmur', 'rain', Icons.water_drop),
                                _buildAmbientButton('Okyanus', 'ocean', Icons.waves),
                                _buildAmbientButton('Orman', 'forest', Icons.forest),
                                _buildAmbientButton('Şömine', 'fire', Icons.local_fire_department),
                              ],
                            ),
                            if (_selectedAmbient != null) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: AppColors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 2,
                                        thumbColor: AppColors.white,
                                        activeTrackColor: AppColors.white,
                                        inactiveTrackColor: AppColors.white.withOpacity(0.3),
                                      ),
                                      child: Slider(
                                        value: _ambientVolume,
                                        onChanged: (value) async {
                                          setState(() {
                                            _ambientVolume = value;
                                          });
                                          await _ambientService.setVolume(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sleep Timer
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Uyku Zamanlayıcısı',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            if (_sleepTimerMinutes != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Kalan: ${_formatDuration(_remainingTime)}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildTimerButton('Kapalı', null),
                                _buildTimerButton('15 dk', 15),
                                _buildTimerButton('30 dk', 30),
                                _buildTimerButton('45 dk', 45),
                                _buildTimerButton('60 dk', 60),
                              ],
                            ),
                          ],
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

  Widget _buildAmbientButton(String label, String? value, IconData icon) {
    final isSelected = _selectedAmbient == value;
    return GestureDetector(
      onTap: () => _toggleAmbient(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.pastelBlue
              : AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.pastelBlue
                : AppColors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerButton(String label, int? minutes) {
    final isSelected = _sleepTimerMinutes == minutes;
    return GestureDetector(
      onTap: () => _setSleepTimer(minutes),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.pastelBlue
              : AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.pastelBlue
                : AppColors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

