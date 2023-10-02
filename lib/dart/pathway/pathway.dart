import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';


/// A class that represents a pathway containing selected degree, majors, and papers.
class Pathway {
  final Degree degree;
  final List<Major> majors;
  final List<Paper> papers;
  double gpa = -1;
  bool isSelected = false;

  /// Constructs a [Pathway] instance.
  ///
  /// The constructor initializes a pathway with the specified [degree], [majors], [papers],
  /// [gpa], and [isSelected] values.
  Pathway({
    required this.degree,
    required this.majors,
    required this.papers,
    required this.gpa,
    required this.isSelected,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree.toJson(),
      'majors': majors.map((major) => major.toJson()).toList(),
      'papers': papers.map((paper) => paper.toJson()).toList(),
      'gpa': gpa,
      'isSelected': isSelected,
    };
  }

  factory Pathway.fromJson(Map<String, dynamic> json) {
    return Pathway(
      degree: Degree.fromJson(json['degree']),
      majors: (json['majors'] as List).map((majorJson) => Major.fromJson(majorJson)).toList(),
      papers: (json['papers'] as List).map((paperJson) => Paper.fromJson(paperJson)).toList(),
      gpa: json['gpa'],
      isSelected: json['isSelected'],
    );
  }
}
