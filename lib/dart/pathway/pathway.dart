import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';

class Pathway {
  final Degree degree;
  final List<Major> majors;
  final List<Paper> papers;
  double gpa = -1;
  bool isSelected = false;

  Pathway({
    required this.degree,
    required this.majors,
    required this.papers,
    required this.gpa,
    required this.isSelected
  });

  @override
  String toString() {
    return 'Pathway: $degree, $majors, $papers, $gpa, $isSelected';
  }
}
