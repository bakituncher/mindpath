import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/breathing_model.dart';
import 'dart:async';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  BreathingPattern? _selectedPattern;
  bool _isActive = false;
  int _currentCycle = 0;
  String _currentPhase = '';
  int _phaseCountdown = 0;
  Timer? _timer;

  final List<BreathingExercise> _exercises = [
    BreathingExercise(
      id: '478',
      name: '4-7-8 Nefes',
      description: 'Kaygıyı azaltmak ve rahatlamak için',
      pattern: BreathingPattern.breathing478,
      benefit: 'Stres ve kaygıyı azaltır',
      tags: ['kaygı', 'uyku', 'rahatlatıcı'],
    ),
    BreathingExercise(
      id: 'box',
      name: 'Box Breathing',
      description: 'Odaklanma ve zihinsel netlik için',
      pattern: BreathingPattern.boxBreathing,
      benefit: 'Odaklanmayı artırır',
      tags: ['odak', 'denge', 'sakinlik'],
    ),
    BreathingExercise(
      id: 'pranayama',
      name: 'Pranayama',
      description: 'Enerji dengeleme ve yaşam gücü',
      pattern: BreathingPattern.pranayama,
      benefit: 'Enerjiyi dengeler',
      tags: ['enerji', 'denge', 'yoga'],
    ),
    BreathingExercise(
      id: 'deep_belly',
      name: 'Derin Karın Nefesi',
      description: 'Uyku öncesi gevşeme',
      pattern: BreathingPattern.deepBelly,
      benefit: 'Gevşemeyi sağlar',
      tags: ['uyku', 'rahatlatıcı', 'gevşeme'],
    ),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise(BreathingPattern pattern) {
    setState(() {
      _selectedPattern = pattern;
      _isActive = true;
      _currentCycle = 0;
      _runCycle();
    });
  }

  void _stopExercise() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _currentCycle = 0;
      _currentPhase = '';
      _phaseCountdown = 0;
    });
  }

  void _runCycle() {
    if (_currentCycle >= _selectedPattern!.cycles) {
      _stopExercise();
      _showCompletionDialog();
      return;
    }

    _runPhase('Nefes Al', _selectedPattern!.inhaleSeconds, () {
      if (_selectedPattern!.holdInSeconds > 0) {
        _runPhase('Tut', _selectedPattern!.holdInSeconds, () {
          _runPhase('Nefes Ver', _selectedPattern!.exhaleSeconds, () {
            if (_selectedPattern!.holdOutSeconds > 0) {
              _runPhase('Tut', _selectedPattern!.holdOutSeconds, () {
                setState(() => _currentCycle++);
                _runCycle();
              });
            } else {
              setState(() => _currentCycle++);
              _runCycle();
            }
          });
        });
      } else {
        _runPhase('Nefes Ver', _selectedPattern!.exhaleSeconds, () {
          setState(() => _currentCycle++);
          _runCycle();
        });
      }
    });
  }

  void _runPhase(String phase, int seconds, VoidCallback onComplete) {
    setState(() {
      _currentPhase = phase;
      _phaseCountdown = seconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _phaseCountdown--;
        if (_phaseCountdown <= 0) {
          timer.cancel();
          onComplete();
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tebrikler! 🎉'),
        content: const Text('Nefes egzersizini tamamladınız.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isActive && _selectedPattern != null) {
      return _buildActiveExercise();
    }
    return _buildExerciseList();
  }

  Widget _buildExerciseList() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.pastelBlue, AppColors.primaryBeige],
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
                      'Nefes Egzersizleri',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nefesle zihni sakinleştir',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: _exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return _buildExerciseCard(exercise);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BreathingExercise exercise) {
    return GestureDetector(
      onTap: () => _startExercise(exercise.pattern),
      child: Container(
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.pastelBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.air,
                    color: AppColors.pastelBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        exercise.benefit,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mediumGray,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              exercise.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: exercise.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.pastelBlue.withOpacity(0.1),
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveExercise() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.pastelBlue, AppColors.primaryBeige],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _stopExercise,
                    ),
                    Text(
                      'Döngü ${_currentCycle + 1}/${_selectedPattern!.cycles}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),
              // Breathing Circle
              AnimatedContainer(
                duration: Duration(seconds: _phaseCountdown),
                width: _currentPhase == 'Nefes Al' ? 250 : 150,
                height: _currentPhase == 'Nefes Al' ? 250 : 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pastelBlue.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _phaseCountdown.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _currentPhase,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.darkGray,
                    ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

