class BreathingExercise {
  final String id;
  final String name;
  final String description;
  final BreathingPattern pattern;
  final String benefit;
  final String? audioUrl;
  final String? animationUrl;
  final List<String> tags;

  BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.pattern,
    required this.benefit,
    this.audioUrl,
    this.animationUrl,
    this.tags = const [],
  });

  factory BreathingExercise.fromJson(Map<String, dynamic> json) {
    return BreathingExercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pattern: BreathingPattern.fromJson(json['pattern'] ?? {}),
      benefit: json['benefit'] ?? '',
      audioUrl: json['audioUrl'],
      animationUrl: json['animationUrl'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pattern': pattern.toJson(),
      'benefit': benefit,
      'audioUrl': audioUrl,
      'animationUrl': animationUrl,
      'tags': tags,
    };
  }
}

class BreathingPattern {
  final int inhaleSeconds;
  final int holdInSeconds;
  final int exhaleSeconds;
  final int holdOutSeconds;
  final int cycles;

  BreathingPattern({
    required this.inhaleSeconds,
    this.holdInSeconds = 0,
    required this.exhaleSeconds,
    this.holdOutSeconds = 0,
    this.cycles = 10,
  });

  factory BreathingPattern.fromJson(Map<String, dynamic> json) {
    return BreathingPattern(
      inhaleSeconds: json['inhaleSeconds'] ?? 4,
      holdInSeconds: json['holdInSeconds'] ?? 0,
      exhaleSeconds: json['exhaleSeconds'] ?? 4,
      holdOutSeconds: json['holdOutSeconds'] ?? 0,
      cycles: json['cycles'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inhaleSeconds': inhaleSeconds,
      'holdInSeconds': holdInSeconds,
      'exhaleSeconds': exhaleSeconds,
      'holdOutSeconds': holdOutSeconds,
      'cycles': cycles,
    };
  }

  // Predefined patterns
  static BreathingPattern get breathing478 => BreathingPattern(
    inhaleSeconds: 4,
    holdInSeconds: 7,
    exhaleSeconds: 8,
    cycles: 8,
  );

  static BreathingPattern get boxBreathing => BreathingPattern(
    inhaleSeconds: 4,
    holdInSeconds: 4,
    exhaleSeconds: 4,
    holdOutSeconds: 4,
    cycles: 10,
  );

  static BreathingPattern get pranayama => BreathingPattern(
    inhaleSeconds: 5,
    holdInSeconds: 5,
    exhaleSeconds: 5,
    cycles: 12,
  );

  static BreathingPattern get deepBelly => BreathingPattern(
    inhaleSeconds: 6,
    holdInSeconds: 2,
    exhaleSeconds: 8,
    cycles: 10,
  );
}

