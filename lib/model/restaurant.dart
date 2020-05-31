class Restaurant {
  final String id;
  final String name;
  final String image;
  final String deliveryEstimation;
  final String review;
  final String cuisine;
  final String address;
  final String discountTitle;
  final String discountDescription;

  Restaurant(this.id, this.name, this.deliveryEstimation, this.review,
      this.image, this.cuisine, this.address,
      {this.discountTitle, this.discountDescription});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
        parsedJson['merchant_id'],
        parsedJson['restaurant_name'],
        parsedJson['delivery_est'],
        parsedJson['ratings']['ratings'].toString(),
        parsedJson['logo'],
        parsedJson['cuisine'],
        parsedJson['address'],
        discountTitle: parsedJson['promos_text'],
        discountDescription: parsedJson['promos_text_catpage']);
  }
}
