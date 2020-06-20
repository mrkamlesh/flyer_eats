class FoodCategory {
  final String id;
  final String name;
  final String image;

  FoodCategory(this.id, this.name, this.image);

  factory FoodCategory.fromJson(Map<String, dynamic> parsedJson) {
    return FoodCategory(parsedJson['category_id'], parsedJson['category_name'],
        parsedJson['photo']);
  }
}
