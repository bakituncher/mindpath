class SleepStoryModel {
  final String id;
  final String title;
  final String description;
  final String narrator;
  final String? audioUrl;
  final String? imageUrl;
  final int durationMinutes;
  final List<String> tags;
  final bool isPremium;
  final String? ambientSound; // 'rain', 'ocean', 'forest', 'fire'

  SleepStoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.narrator,
    this.audioUrl,
    this.imageUrl,
    required this.durationMinutes,
    this.tags = const [],
    this.isPremium = false,
    this.ambientSound,
  });

  factory SleepStoryModel.fromJson(Map<String, dynamic> json) {
    return SleepStoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      narrator: json['narrator'] ?? '',
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      durationMinutes: json['durationMinutes'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isPremium: json['isPremium'] ?? false,
      ambientSound: json['ambientSound'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'narrator': narrator,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'durationMinutes': durationMinutes,
      'tags': tags,
      'isPremium': isPremium,
      'ambientSound': ambientSound,
    };
  }
}

