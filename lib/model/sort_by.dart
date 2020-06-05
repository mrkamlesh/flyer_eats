class SortBy {
  final String key;
  final String title;

  SortBy({this.key, this.title});

  factory SortBy.fromJson(Map<String, dynamic> parsedJson) {
    return SortBy(
      key: parsedJson["key"],
      title: parsedJson["title"],
    );
  }
}
