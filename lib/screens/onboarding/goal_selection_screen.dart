import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/core/constants/app_strings.dart';
import 'package:mindpath/screens/onboarding/assessment_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final List<String> _selectedGoals = [];

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'reduce_stress',
      title: AppStrings.reduceStress,
      icon: Icons.self_improvement,
      color: AppColors.calmTeal,
    ),
    GoalOption(
      id: 'sleep_better',
      title: AppStrings.sleepBetter,
      icon: Icons.bedtime_outlined,
      color: AppColors.pastelBlue,
    ),
    GoalOption(
      id: 'balance_emotions',
      title: AppStrings.balanceEmotions,
      icon: Icons.favorite_outline,
      color: AppColors.peaceViolet,
    ),
    GoalOption(
      id: 'improve_focus',
      title: AppStrings.improveFocus,
      icon: Icons.center_focus_strong,
      color: AppColors.energyOrange,
    ),
    GoalOption(
      id: 'know_myself',
      title: AppStrings.knowMyself,
      icon: Icons.psychology_outlined,
      color: AppColors.lavender,
    ),
  ];

  void _toggleGoal(String goalId) {
    setState(() {
      if (_selectedGoals.contains(goalId)) {
        _selectedGoals.remove(goalId);
      } else {
        _selectedGoals.add(goalId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.morningGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  AppStrings.whatBringsYouHere,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Birden fazla seçebilirsin',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 32),
                
                // Goals Grid
                Expanded(
                  child: ListView.separated(
                    itemCount: _goals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      final isSelected = _selectedGoals.contains(goal.id);
                      
                      return GoalCard(
                        goal: goal,
                        isSelected: isSelected,
                        onTap: () => _toggleGoal(goal.id),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedGoals.isEmpty
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AssessmentScreen(
                                  selectedGoals: _selectedGoals,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.pastelGreen,
                      disabledBackgroundColor: AppColors.lightGray,
                    ),
                    child: Text(
                      'Devam Et (${_selectedGoals.length} seçili)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalOption {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class GoalCard extends StatelessWidget {
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? goal.color.withOpacity(0.2) : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? goal.color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: goal.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                goal.icon,
                size: 32,
                color: goal.color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                goal.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: goal.color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

