class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String? imageUrl;
  final int totalLessons;
  final int estimatedDurationMinutes;
  final List<LessonModel> lessons;
  final bool isPremium;
  final List<String> tags;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.imageUrl,
    required this.totalLessons,
    required this.estimatedDurationMinutes,
    this.lessons = const [],
    this.isPremium = false,
    this.tags = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      imageUrl: json['imageUrl'],
      totalLessons: json['totalLessons'] ?? 0,
      estimatedDurationMinutes: json['estimatedDurationMinutes'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((l) => LessonModel.fromJson(l))
          .toList() ?? [],
      isPremium: json['isPremium'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'imageUrl': imageUrl,
      'totalLessons': totalLessons,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'isPremium': isPremium,
      'tags': tags,
    };
  }
}

class LessonModel {
  final String id;
  final String title;
  final String description;
  final int orderIndex;
  final int durationMinutes;
  final String? audioUrl;
  final String? videoUrl;
  final String? textContent;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.durationMinutes,
    this.audioUrl,
    this.videoUrl,
    this.textContent,
    this.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
      textContent: json['textContent'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'orderIndex': orderIndex,
      'durationMinutes': durationMinutes,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'textContent': textContent,
      'isCompleted': isCompleted,
    };
  }
}

