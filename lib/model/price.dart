class Price {
  final double price;
  final String formattedPrice;
  final String formattedDiscountPrice;
  final String size;
  final String sizeId;
  final double discountedPrice;

  Price({this.price, this.formattedPrice, this.formattedDiscountPrice, this.size, this.sizeId, this.discountedPrice});

  factory Price.fromJson(Map<String, dynamic> parsedJson) {
    return Price(
      price: double.parse(parsedJson['price'].toString()),
      formattedPrice: parsedJson['formatted_price'],
      formattedDiscountPrice: parsedJson['price_discount_pretty'],
      size: parsedJson['size'],
      sizeId: parsedJson['size_id'].toString(),
    );
  }

  factory Price.fromJsonFoodDetail(Map<String, dynamic> parsedJson) {
    return Price(
      price: double.parse(parsedJson['price'].toString()),
      formattedPrice: parsedJson['formatted_price'],
      formattedDiscountPrice: parsedJson['price_discount_pretty'],
      size: parsedJson['size'],
      sizeId: parsedJson['size_id'].toString(),
      discountedPrice: double.parse(parsedJson['discounted_price'].toString()),
    );
  }
}
