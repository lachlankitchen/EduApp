class Major {
  final String name;
  final List<Requirement> requirements;
  final int totalPoints;

  bool isSelected = false; // Add this property to track selection

  Major({
    required this.name,
    required this.requirements,
    required this.totalPoints,
    required this.isSelected
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    final List<dynamic> requirementsJson = json['requirements'] ?? [];
    final List<Requirement> requirements = requirementsJson.map((req) => Requirement.fromJson(req)).toList();

    return Major(
      name: json['name'],
      requirements: requirements,
      totalPoints: json['totalPoints'],
      isSelected: false
    );
  }

  @override
  String toString() {
    String requirementsString = requirements.map((requirement) => requirement.toString()).join('\n');
    return "Major Name: $name\nTotal Points: $totalPoints\nRequirements:\n$requirementsString";
  }
}

class Requirement {
  int? level;
  List<String>? papers;
  List<String>? selectOneFrom;
  int? points;
  String? notes;

  Requirement({
    this.level,
    this.papers,
    this.selectOneFrom,
    this.points,
    this.notes,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      level: json['level'] as int?,
      papers: (json['papers'] as List<dynamic>?)?.cast<String>(),
      selectOneFrom: (json['selectOneFrom'] as List<dynamic>?)?.cast<String>(),
      points: json['points'] as int?,
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() {
    String selectOneFromString = selectOneFrom != null ? "Select One From: ${selectOneFrom!.join(', ')}" : "";
    String pointsString = points != null ? "Points: $points\nNotes: $notes" : "";
    return "Requirement Level: $level\nPapers: $papers, \n$selectOneFromString\n$pointsString";
  }
}