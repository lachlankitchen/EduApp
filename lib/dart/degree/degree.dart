class Degree {
  String title;

  Degree(this.title);

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
