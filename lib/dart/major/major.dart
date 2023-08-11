import 'dart:convert';

class Major {
  final String name;
  final List<Requirement> requirements;
  final int totalPoints;

  Major({
    required this.name,
    required this.requirements,
    required this.totalPoints,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    final List<dynamic> requirementsJson = json['requirements'] ?? [];
    final List<Requirement> requirements = requirementsJson.map((req) => Requirement.fromJson(req)).toList();

    return Major(
      name: json['name'],
      requirements: requirements,
      totalPoints: json['totalPoints'],
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





void main() {
  String jsonString = '''
    {
      "requirements": [
        {
          "level": 100,
          "papers": ["ENGL 121", "ENGL 131"],
          "selectOneFrom": ["ENGL 120", "ENGL 121", "ENGL 127", "ENGL 128", "ENGL 131", "LING 111"]
        },
        {
          "level": 200,
          "papers": ["Three 200-level ENGL papers", "DHUM 201 or EURO 202"]
        },
        {
          "level": 300,
          "papers": ["Four 300-level ENGL papers", "EURO 302"]
        },
        {
          "points": 198,
          "notes": "Must include 54 points at 200-level or above. Up to 90 points may be taken from outside Arts."
        }
      ]
    }
  ''';

  Map<String, dynamic> parsedJson = jsonDecode(jsonString);
  print(parsedJson['requirements']);
  List<dynamic> requirementsJson = parsedJson['requirements'];
  print(requirementsJson);
  List<Requirement> requirements = requirementsJson.map((req) => Requirement.fromJson(req)).toList();

  print(requirements);
}
