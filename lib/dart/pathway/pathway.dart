import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';

/// A class that represents a pathway containing selected degree, majors, and papers.
class Pathway {
  final Degree degree;
  final List<Major> majors;
  final Map<String, List<Paper>> selectedPapers;
  final Map<String, List<Paper>> remainingPapers;
  final String requirements;
  final int remainingPoints;
  double gpa = -1;
  bool isSelected = false;

  /// Constructs a [Pathway] instance.
  ///
  /// The constructor initializes a pathway with the specified [degree], [majors], [papers],
  /// [gpa], and [isSelected] values.
  Pathway({
    required this.degree,
    required this.majors,
    required this.selectedPapers,
    required this.remainingPapers,
    required this.remainingPoints,
    required this.requirements,
    required this.gpa,
    required this.isSelected,
  });
}
