/// Represents a degree.
class Degree {
  String title;

  /// Constructs a [Degree] instance with a [title].
  Degree(this.title);

  /// Constructs a [Degree] instance from a JSON map.
  ///
  /// [json]: A JSON map representing the degree.
  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(json['title']);
  }

  /// Converts a list of JSON strings to a list of [Degree] instances.
  ///
  /// [jsonList]: A list of JSON strings containing degree titles.
  /// Returns a list of [Degree] instances.
  static List<Degree> fromJsonList(List<String> jsonList) {
    return jsonList.map((title) => Degree(title)).toList();
  }
}
