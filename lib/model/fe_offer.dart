class FEOffer {
  final String id;
  final String owner;
  final String name;
  final String type;
  final double amount;
  final double maxDiscount;
  final double minOrderAmount;
  final String promosText;
  final String promosDescription;
  final String image;

  FEOffer(
      {this.id,
      this.owner,
      this.name,
      this.type,
      this.amount,
      this.maxDiscount,
      this.minOrderAmount,
      this.promosText,
      this.promosDescription,
      this.image});

  factory FEOffer.fromJson(Map<String, dynamic> parsedJson) {
    return FEOffer(
      id: parsedJson['voucher_id'],
      image: parsedJson['image'],
      name: parsedJson['voucher_name'],
      type: parsedJson['voucher_type'],
      owner: parsedJson['voucher_owner'],
      amount: double.parse(parsedJson['amount'].toString()),
      maxDiscount: double.parse(parsedJson['max_discount']),
      minOrderAmount: double.parse(parsedJson['min_order_amount']),
      promosDescription: parsedJson['promos_text_catpage'],
      promosText: parsedJson['promos_text'],
    );
  }
}
