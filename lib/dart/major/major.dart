/// Represents a major with its requirements and total points.
class Major {
  final String name;
  final List<Requirement> requirements;
  final int totalPoints;
  bool isSelected = false; // Add this property to track selection

  /// Constructs a [Major] instance.
  ///
  /// [name]: The name of the major.
  /// [requirements]: The list of requirements for the major.
  /// [totalPoints]: The total points required for the major.
  /// [isSelected]: Indicates whether the major is selected or not.
  Major({
    required this.name,
    required this.requirements,
    required this.totalPoints,
    required this.isSelected,
  });

  /// Constructs a [Major] instance from a JSON map.
  ///
  /// [json]: A JSON map representing the major.
  factory Major.fromJson(Map<String, dynamic> json) {
    final List<dynamic> requirementsJson = json['requirements'] ?? [];
    final List<Requirement> requirements =
        requirementsJson.map((req) => Requirement.fromJson(req)).toList();

    return Major(
      name: json['name'],
      requirements: requirements,
      totalPoints: json['totalPoints'],
      isSelected: false,
    );
  }

  @override
  String toString() {
    String requirementsString =
        requirements.map((requirement) => requirement.toString()).join('\n');
    return "Major Name: $name\nTotal Points: $totalPoints\nRequirements:\n$requirementsString";
  }
}

/// Represents a requirement for a major.
class Requirement {
  int? level;
  List<String>? papers;
  List<String>? selectOneFrom;
  int? points;
  String? notes;

  /// Constructs a [Requirement] instance.
  ///
  /// [level]: The level of the requirement.
  /// [papers]: The list of paper codes for the requirement.
  /// [selectOneFrom]: The list of options to select from.
  /// [points]: The number of points for the requirement.
  /// [notes]: Additional notes for the requirement.
  Requirement({
    this.level,
    this.papers,
    this.selectOneFrom,
    this.points,
    this.notes,
  });

  /// Constructs a [Requirement] instance from a JSON map.
  ///
  /// [json]: A JSON map representing the requirement.
  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      level: json['level'] as int?,
      papers: (json['papers'] as List<dynamic>?)?.cast<String>(),
      selectOneFrom: (json['selectOneFrom'] as List<dynamic>?)?.cast<String>(),
      points: json['points'] as int?,
      notes: json['notes'] as String?,
    );
  }
}