import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/screens/auth/signup_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final List<String> selectedGoals;

  const AssessmentScreen({
    super.key,
    required this.selectedGoals,
  });

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<String, int> _answers = {};

  final List<AssessmentQuestion> _questions = [
    AssessmentQuestion(
      id: 'stress_level',
      question: 'Son zamanlarda ne kadar stresli hissediyorsun?',
      options: ['Hiç', 'Biraz', 'Orta Düzeyde', 'Oldukça', 'Çok Fazla'],
    ),
    AssessmentQuestion(
      id: 'sleep_quality',
      question: 'Uyku kalitenizi nasıl değerlendirirsiniz?',
      options: ['Mükemmel', 'İyi', 'Orta', 'Kötü', 'Çok Kötü'],
    ),
    AssessmentQuestion(
      id: 'mood_stability',
      question: 'Ruh haliniz ne kadar dengeli?',
      options: ['Çok Dengeli', 'Dengeli', 'Değişken', 'Dengesiz', 'Çok Dengesiz'],
    ),
    AssessmentQuestion(
      id: 'anxiety_frequency',
      question: 'Ne sıklıkla kaygı hissediyorsun?',
      options: ['Hiçbir Zaman', 'Nadiren', 'Bazen', 'Sık Sık', 'Her Zaman'],
    ),
    AssessmentQuestion(
      id: 'focus_ability',
      question: 'Odaklanma yeteneğinizi nasıl tanımlarsınız?',
      options: ['Mükemmel', 'İyi', 'Orta', 'Zayıf', 'Çok Zayıf'],
    ),
  ];

  void _answerQuestion(int value) {
    setState(() {
      _answers[_questions[_currentPage].id] = value;
    });

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeAssessment() {
    // Calculate assessment results
    final totalScore = _answers.values.reduce((a, b) => a + b);
    final averageScore = totalScore / _answers.length;

    // Navigate to signup with results
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignupScreen(
          selectedGoals: widget.selectedGoals,
          assessmentScore: averageScore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.morningGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Soru ${_currentPage + 1}/${_questions.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: _completeAssessment,
                          child: const Text('Atla'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / _questions.length,
                        backgroundColor: AppColors.lightGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.pastelGreen,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              // Questions
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return QuestionPage(
                      question: question,
                      selectedAnswer: _answers[question.id],
                      onAnswer: _answerQuestion,
                    );
                  },
                ),
              ),

              // Navigation Buttons
              if (_answers.containsKey(_questions[_currentPage].id))
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _currentPage == _questions.length - 1
                          ? _completeAssessment
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                      child: Text(
                        _currentPage == _questions.length - 1
                            ? 'Tamamla'
                            : 'Devam Et',
                      ),
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

class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

class QuestionPage extends StatelessWidget {
  final AssessmentQuestion question;
  final int? selectedAnswer;
  final Function(int) onAnswer;

  const QuestionPage({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final isSelected = selectedAnswer == index;
                return GestureDetector(
                  onTap: () => onAnswer(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.pastelGreen.withOpacity(0.2)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.pastelGreen
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.pastelGreen
                                  : AppColors.mediumGray,
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.pastelGreen
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

