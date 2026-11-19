enum RouteDifficulty {
  easy,
  moderate,
  hard;

  String get label {
    switch (this) {
      case RouteDifficulty.easy:
        return '简单';
      case RouteDifficulty.moderate:
        return '中等';
      case RouteDifficulty.hard:
        return '困难';
    }
  }

  static RouteDifficulty fromJson(String value) {
    return RouteDifficulty.values.firstWhere(
      (difficulty) => difficulty.name == value,
      orElse: () => RouteDifficulty.moderate,
    );
  }
}

class HikingRoute {
  const HikingRoute({
    required this.id,
    required this.name,
    required this.area,
    required this.difficulty,
    required this.distanceKm,
    required this.ascentM,
    required this.durationMinutes,
    required this.summary,
    required this.description,
    required this.highlights,
    required this.tip,
    required this.coverAsset,
  });

  final String id;
  final String name;
  final String area;
  final RouteDifficulty difficulty;
  final double distanceKm;
  final int ascentM;
  final int durationMinutes;
  final String summary;
  final String description;
  final List<String> highlights;
  final String tip;
  final String coverAsset;

  String get distanceLabel {
    final whole = distanceKm.truncateToDouble() == distanceKm;
    return '${whole ? distanceKm.toInt() : distanceKm.toStringAsFixed(1)} km';
  }

  String get durationLabel {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours == 0) {
      return '$minutes 分钟';
    }
    if (minutes == 0) {
      return '$hours 小时';
    }
    return '$hours 小时 $minutes 分';
  }

  factory HikingRoute.fromJson(Map<String, dynamic> json) {
    return HikingRoute(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      difficulty: RouteDifficulty.fromJson(json['difficulty'] as String),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      ascentM: (json['ascentM'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      summary: json['summary'] as String,
      description: json['description'] as String,
      highlights: List<String>.from(json['highlights'] as List<dynamic>),
      tip: json['tip'] as String,
      coverAsset: json['coverAsset'] as String,
    );
  }
}
