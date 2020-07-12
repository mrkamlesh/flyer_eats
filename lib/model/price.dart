class Price {
  final double price;
  final String formattedPrice;
  final String formattedDiscountPrice;
  final String size;
  final String sizeId;

  Price({this.price, this.formattedPrice, this.formattedDiscountPrice, this.size, this.sizeId});

  factory Price.fromJson(Map<String, dynamic> parsedJson) {
    return Price(
      price: double.parse(parsedJson['price'].toString()),
      formattedPrice: parsedJson['formatted_price'],
      formattedDiscountPrice: parsedJson['price_discount_pretty'],
      size: parsedJson['size'],
      sizeId: parsedJson['size_id'].toString(),
    );
  }
}
