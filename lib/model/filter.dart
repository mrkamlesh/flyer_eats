class Filter {
  final String id;
  final String title;

  Filter({this.id, this.title});

  factory Filter.fromJson(Map<String, dynamic> parsedJson) {
    return Filter(
      id: parsedJson["id"],
      title: parsedJson["title"],
    );
  }
}
