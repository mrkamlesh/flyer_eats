class Food {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isAvailable;

  Food(this.id, this.title, this.description, this.price, this.image,
      this.isAvailable);

  factory Food.fromJson(Map<String, dynamic> parsedJson) {
    bool available = true;
    if (parsedJson['not_available'] == "1") available = false;

    return Food(
      parsedJson['item_id'],
      parsedJson['item_name'],
      parsedJson['item_description'],
      double.parse(parsedJson['prices'][0]['price']),
      parsedJson['photo'],
      available,
    );
  }
}
