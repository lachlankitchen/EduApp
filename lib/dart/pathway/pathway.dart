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
  final int furtherPoints;
  final int pointsAt200Level;

  double gpa = -1;
  bool isSelected = false;

  /// Constructs a [Pathway] instance.
  ///
  /// The constructor initializes a pathway with the following:
  /// - [degree]: The selected degree.
  /// - [majors]: The list of selected majors.
  /// - [selectedPapers]: The list of selected papers.
  /// - [remainingPapers]: The list of remaining papers.
  /// - [requirements]: The requirements for the pathway.
  /// - [furtherPoints]: The number of further points required for the pathway.
  /// - [pointsAt200Level]: The number of points at 200-level required for the pathway.
  /// - [gpa]: The GPA for the pathway.
  /// - [isSelected]: Indicates if the pathway is selected by the user.
  Pathway({
    required this.degree,
    required this.majors,
    required this.selectedPapers,
    required this.remainingPapers,
    required this.furtherPoints,
    required this.pointsAt200Level,
    required this.requirements,
    required this.gpa,
    required this.isSelected,
  });
}
