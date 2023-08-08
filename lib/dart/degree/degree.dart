class Degree {
  String title;
  String field;
  int year;

  Degree(this.title, this.field, this.year);

  @override
  String toString() {
    return '$title in $field, $year';
  }
}
