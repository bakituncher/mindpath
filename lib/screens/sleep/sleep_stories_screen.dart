import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';

class SleepStoriesScreen extends StatelessWidget {
  const SleepStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      SleepStory(
        id: '1',
        title: 'Ay Işığında Göl Kenarı',
        description: 'Sakin bir göl kenarında huzurlu bir gece yolculuğu',
        duration: 25,
        narrator: 'Kadın Ses',
        imageUrl: null,
      ),
      SleepStory(
        id: '2',
        title: 'Orman Yürüyüşü',
        description: 'Yeşil bir ormanda yavaş ve sakin bir yürüyüş',
        duration: 30,
        narrator: 'Erkek Ses',
        imageUrl: null,
      ),
      SleepStory(
        id: '3',
        title: 'Deniz Kıyısında Günbatımı',
        description: 'Dalgaların sesiyle birlikte huzurlu bir akşam',
        duration: 20,
        narrator: 'Kadın Ses',
        imageUrl: null,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.nightGradient,
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
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Uyku Hikayeleri',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rahat bir uykuya dalın',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return SleepStoryCard(story: story);
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

class SleepStory {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String narrator;
  final String? imageUrl;

  SleepStory({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.narrator,
    this.imageUrl,
  });
}

class SleepStoryCard extends StatelessWidget {
  final SleepStory story;

  const SleepStoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.pastelBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${story.duration} dk • ${story.narrator}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Play sleep story
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Dinle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pastelBlue.withOpacity(0.3),
                foregroundColor: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

