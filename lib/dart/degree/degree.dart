import '../major/major.dart';

class Degree {
  String title;
  List<Major?> majors; // A list to store up to two majors

  Degree(this.title) : majors = List<Major?>.filled(2, null);

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(json['title']);
  }

  static List<Degree> fromJsonList(List<String> jsonList) {
    return jsonList.map((title) => Degree(title)).toList();
  }

  @override
  String toString() {
    return title;
  }
}
