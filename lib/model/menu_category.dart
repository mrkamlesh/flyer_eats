class MenuCategory {
  final String id;
  final String name;

  MenuCategory(this.id, this.name);

  factory MenuCategory.fromJson(Map<String, dynamic> parsedJson) {
    return MenuCategory(
      parsedJson['cat_id'],
      parsedJson['category_name'],
    );
  }
}
