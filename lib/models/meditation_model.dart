class MeditationModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final String voiceType; // 'male', 'female', 'silent'
  final String? audioUrl;
  final String? imageUrl;
  final List<String> tags;
  final int playCount;
  final double rating;
  final bool isPremium;

  MeditationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.voiceType = 'female',
    this.audioUrl,
    this.imageUrl,
    this.tags = const [],
    this.playCount = 0,
    this.rating = 0.0,
    this.isPremium = false,
  });

  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 5,
      voiceType: json['voiceType'] ?? 'female',
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      playCount: json['playCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'durationMinutes': durationMinutes,
      'voiceType': voiceType,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'tags': tags,
      'playCount': playCount,
      'rating': rating,
      'isPremium': isPremium,
    };
  }
}

enum MeditationCategory {
  morning('morning', 'Güne Başlarken', '🌅'),
  evening('evening', 'Günü Bitirirken', '🌙'),
  anxiety('anxiety', 'Kaygı & Stres', '😌'),
  focus('focus', 'Odaklanma', '🎯'),
  emotions('emotions', 'Duygu Farkındalığı', '💭'),
  relationships('relationships', 'İlişkiler', '💖'),
  selfLove('selfLove', 'Kendini Sevme', '🌸'),
  nature('nature', 'Doğa & Anda Kalma', '🌿');

  final String id;
  final String title;
  final String emoji;

  const MeditationCategory(this.id, this.title, this.emoji);
}

