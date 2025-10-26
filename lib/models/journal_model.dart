class JournalEntry {
  final String id;
  final String userId;
  final DateTime createdAt;
  final String? title;
  final String content;
  final String? audioUrl;
  final List<String> emotions;
  final int moodScore; // 1-10
  final Map<String, dynamic>? aiAnalysis;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.createdAt,
    this.title,
    required this.content,
    this.audioUrl,
    this.emotions = const [],
    this.moodScore = 5,
    this.aiAnalysis,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      content: json['content'] ?? '',
      audioUrl: json['audioUrl'],
      emotions: List<String>.from(json['emotions'] ?? []),
      moodScore: json['moodScore'] ?? 5,
      aiAnalysis: json['aiAnalysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'content': content,
      'audioUrl': audioUrl,
      'emotions': emotions,
      'moodScore': moodScore,
      'aiAnalysis': aiAnalysis,
    };
  }
}

class JournalPrompt {
  final String question;
  final String category;
  final String? icon;

  JournalPrompt({
    required this.question,
    required this.category,
    this.icon,
  });

  static List<JournalPrompt> get defaultPrompts => [
    JournalPrompt(
      question: 'Bugün en çok ne hissettim?',
      category: 'emotions',
      icon: '💭',
    ),
    JournalPrompt(
      question: 'Bedenimde hangi duyumlar vardı?',
      category: 'body',
      icon: '🧘',
    ),
    JournalPrompt(
      question: 'Bugün neye şükrediyorum?',
      category: 'gratitude',
      icon: '🙏',
    ),
    JournalPrompt(
      question: 'Zor bir duyguyla nasıl başa çıktım?',
      category: 'coping',
      icon: '💪',
    ),
    JournalPrompt(
      question: 'Bugün hangi anlarımda en çok "anda" idim?',
      category: 'presence',
      icon: '✨',
    ),
  ];
}

