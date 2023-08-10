class Paper {
  final String papercode;
  final String subjectCode;
  final String year;
  final String title;
  final int points;
  final double efts;
  final List<String> teachingPeriods;
  final String description;
  final List<String> prerequisites;
  final List<String> restrictions;
  final String schedule;

  Paper({
    required this.papercode,
    required this.subjectCode,
    required this.year,
    required this.title,
    required this.points,
    required this.efts,
    required this.teachingPeriods,
    required this.description,
    required this.prerequisites,
    required this.restrictions,
    required this.schedule,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      papercode: json['papercode'],
      subjectCode: json['subject_code'],
      year: json['year'],
      title: json['title'],
      points: json['points'],
      efts: json['efts'],
      teachingPeriods: List<String>.from(json['teaching_periods']),
      description: json['description'],
      prerequisites: List<String>.from(json['prerequisites']),
      restrictions: List<String>.from(json['restrictions']),
      schedule: json['schedule'],
    );
  }
}
