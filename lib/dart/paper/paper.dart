import 'package:path_provider/path_provider.dart';

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
  int? grade;
  bool isSelected = false;

  /// Constructs a [Paper].
  ///
  /// [papercode]: The unique code for the paper.
  /// [subjectCode]: The subject code associated with the paper.
  /// [year]: The year when the paper is offered.
  /// [title]: The title of the paper.
  /// [points]: The points/credits associated with the paper.
  /// [efts]: The equivalent full-time student value of the paper.
  /// [teachingPeriods]: List of teaching periods when the paper is offered.
  /// [description]: Description of the paper.
  /// [prerequisites]: List of prerequisites for the paper.
  /// [restrictions]: List of restrictions for the paper.
  /// [schedule]: Schedule details of the paper.
  /// [isSelected]: Indicates if the paper is selected by the user.
  /// [grade]: The user's grade for the paper.
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
    required this.isSelected,
    this.grade,
  });

  /// Constructs a [Paper] instance with only the name.
  ///
  /// [name]: The name of the major.
  Paper.withName({
    required this.papercode,
    required this.title,
    required this.teachingPeriods,
    required this.points
  }) : 
      subjectCode = "",
      year = "",
      efts = 0.0,
      description = "",
      prerequisites = const [],
      restrictions = const [],
      schedule = "",
      isSelected = false,
      grade = 0;

  /// Constructs a [Paper] instance from a JSON map.
  ///
  /// [json]: A JSON map representing the paper.
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
      isSelected: json['isSelected'] ?? false,
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'papercode': papercode,
      'subject_code': subjectCode,
      'year': year,
      'title': title,
      'points': points,
      'efts': efts,
      'teaching_periods': teachingPeriods,
      'description': description,
      'prerequisites': prerequisites,
      'restrictions': restrictions,
      'schedule': schedule,
      'isSelected': isSelected,
      'grade': grade,
    };
  }
}

List<Map<String, dynamic>> papersListToJson(List<Paper> papers) {
  List<Map<String, dynamic>> jsonList = [];

  for (var paper in papers) {
    jsonList.add(paper.toJson());
  }

  return jsonList;
}
