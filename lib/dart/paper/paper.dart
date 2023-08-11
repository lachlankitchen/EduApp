import 'dart:convert';

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

  @override
  String toString() {
    return '''
      Paper Code: $papercode
      Subject Code: $subjectCode
      Year: $year
      Title: $title
      Points: $points
      EFTS: $efts
      Teaching Periods: ${teachingPeriods.join(', ')}
      Description: $description
      Prerequisites: ${prerequisites.join(', ')}
      Restrictions: ${restrictions.join(', ')}
      Schedule: $schedule
    ''';
  }
}

void main() {
  const String paperJson = ''' 
    {
      "papercode": "CS 101",
      "subject_code": "COMPSCI",
      "year": "2023",
      "title": "Introduction to Computer Science",
      "points": 15,
      "efts": 0.125,
      "teaching_periods": ["Semester 1"],
      "description": "An introduction to...",
      "prerequisites": [],
      "restrictions": [],
      "schedule": "Lecture 1: Monday 9:00 AM"
    }
  ''';

  Map<String, dynamic> parsedPaperJson = json.decode(paperJson);
  Paper paper = Paper.fromJson(parsedPaperJson);

  print(paper.toString());
}