import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/meditation_model.dart';
import 'package:mindpath/services/audio_player_service.dart';
import 'dart:async';

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationModel meditation;

  const MeditationPlayerScreen({super.key, required this.meditation});

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayerService _audioService = AudioPlayerService();
  final AmbientAudioService _ambientService = AmbientAudioService();

  late AnimationController _breathingController;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    if (widget.meditation.audioUrl != null) {
      await _audioService.playFromUrl(widget.meditation.audioUrl!);
      setState(() => _isPlaying = true);
    }

    // Play ambient sound
    await _ambientService.playAmbient('assets/audio/ambient/nature.mp3');

    _positionSubscription = _audioService.positionStream.listen((position) {
      setState(() => _currentPosition = position);
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (duration != null) {
        setState(() => _totalDuration = duration);
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _audioService.dispose();
    _ambientService.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    _audioService.togglePlayPause();
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
          gradient: AppColors.meditationGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: AppColors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Breathing Animation
              AnimatedBuilder(
                animation: _breathingController,
                builder: (context, child) {
                  return Container(
                    width: 200 + (_breathingController.value * 50),
                    height: 200 + (_breathingController.value * 50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.white.withOpacity(0.3),
                          AppColors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.meditation.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.meditation.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Progress Bar
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            trackHeight: 4,
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            value: _totalDuration.inSeconds > 0
                                ? _currentPosition.inSeconds.toDouble()
                                : 0,
                            max: _totalDuration.inSeconds.toDouble(),
                            activeColor: AppColors.pastelGreen,
                            inactiveColor: AppColors.lightGray,
                            onChanged: (value) {
                              _audioService.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          iconSize: 32,
                          onPressed: () {
                            final newPosition = _currentPosition - const Duration(seconds: 10);
                            _audioService.seek(newPosition);
                          },
                        ),
                        const SizedBox(width: 32),
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppColors.pastelGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          iconSize: 32,
                          onPressed: () {
                            final newPosition = _currentPosition + const Duration(seconds: 10);
                            _audioService.seek(newPosition);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

