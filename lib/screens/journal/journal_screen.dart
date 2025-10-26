import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';
import 'package:mindpath/models/journal_model.dart';
import 'package:mindpath/services/journal_service.dart';
import 'package:mindpath/services/auth_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.uid ?? '';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lavender, AppColors.primaryBeige],
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
                    Text(
                      'Günlük',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Düşüncelerini keşfet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBeige,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: StreamBuilder<List<JournalEntry>>(
                    stream: _journalService.getUserJournalEntries(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final entry = snapshot.data![index];
                          return JournalEntryCard(entry: entry);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewJournalEntryScreen()),
          );
        },
        backgroundColor: AppColors.lavender,
        icon: const Icon(Icons.edit),
        label: const Text('Yeni Giriş'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: AppColors.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz günlük kaydın yok',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Düşüncelerini yazmaya başla',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  const JournalEntryCard({super.key, required this.entry});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(entry.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mediumGray,
                    ),
              ),
              _buildMoodIndicator(entry.moodScore),
            ],
          ),
          const SizedBox(height: 12),
          if (entry.title != null) ...[
            Text(
              entry.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            entry.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (entry.emotions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: entry.emotions.map((emotion) {
                return Chip(
                  label: Text(emotion),
                  backgroundColor: AppColors.lavender.withOpacity(0.2),
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildMoodIndicator(int mood) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    final index = ((mood - 1) / 2).floor().clamp(0, 4);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: colors[index],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$mood/10',
          style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
        ),
      ],
    );
  }
}

class NewJournalEntryScreen extends StatefulWidget {
  const NewJournalEntryScreen({super.key});

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final TextEditingController _contentController = TextEditingController();
  final JournalService _journalService = JournalService();
  final AuthService _authService = AuthService();
  int _selectedMood = 5;
  final List<String> _selectedEmotions = [];
  int _currentPromptIndex = 0;

  final List<String> _emotions = [
    'Mutlu', 'Huzurlu', 'Kaygılı', 'Üzgün', 'Kızgın',
    'Heyecanlı', 'Umutlu', 'Yorgun', 'Şükran', 'Kararsız',
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir şeyler yaz')),
      );
      return;
    }

    final userId = _authService.currentUser?.uid ?? '';
    final entry = JournalEntry(
      id: '',
      userId: userId,
      createdAt: DateTime.now(),
      content: _contentController.text,
      moodScore: _selectedMood,
      emotions: _selectedEmotions,
    );

    try {
      await _journalService.createJournalEntry(entry);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompts = JournalPrompt.defaultPrompts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Günlük Girişi'),
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: const Text('Kaydet'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt Selector
            Text(
              'İlham Al',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: prompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final prompt = prompts[index];
                  return GestureDetector(
                    onTap: () => setState(() => _currentPromptIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _currentPromptIndex == index
                            ? AppColors.lavender
                            : AppColors.lightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '${prompt.icon} ${prompt.category}',
                          style: TextStyle(
                            color: _currentPromptIndex == index
                                ? AppColors.white
                                : AppColors.darkGray,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Current Prompt
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                prompts[_currentPromptIndex].question,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),

            const SizedBox(height: 24),

            // Content Field
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Düşüncelerini yaz...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Mood Selector
            Text(
              'Ruh Halin (1-10)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Slider(
              value: _selectedMood.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _selectedMood.toString(),
              onChanged: (value) {
                setState(() => _selectedMood = value.toInt());
              },
            ),

            const SizedBox(height: 24),

            // Emotion Selector
            Text(
              'Duygularını Seç',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emotions.map((emotion) {
                final isSelected = _selectedEmotions.contains(emotion);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEmotions.remove(emotion);
                      } else {
                        _selectedEmotions.add(emotion);
                      }
                    });
                  },
                  child: Chip(
                    label: Text(emotion),
                    backgroundColor: isSelected
                        ? AppColors.lavender
                        : AppColors.lightGray,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.darkGray,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

