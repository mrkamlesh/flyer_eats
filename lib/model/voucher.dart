class Voucher {
  final String id;
  final String name;
  final String type;
  final double amount;
  final double rate;
  final String code;
  final String image;
  final String text;

  Voucher({
    this.id,
    this.name,
    this.type,
    this.amount,
    this.code,
    this.rate,
    this.image,
    this.text,
  });

  Voucher copyWith({
    String id,
    String name,
    String type,
    double amount,
    double rate,
    String code,
    String image,
    String text,
  }) {
    return Voucher(
        id: id ?? this.id,
        rate: rate ?? this.rate,
        amount: amount ?? this.amount,
        code: code ?? this.code,
        image: image ?? this.image,
        name: name ?? this.name,
        text: text ?? this.text,
        type: type ?? this.type);
  }

  factory Voucher.fromJson(Map<String, dynamic> parsedJson) {
    return Voucher(
        id: parsedJson['voucher_id'],
        name: parsedJson['voucher_name'],
        type: parsedJson['voucher_type'],
        rate: double.parse(parsedJson['rate'].toString()),
        amount: double.parse(parsedJson['amount'].toString()));
  }

  factory Voucher.fromJson2(Map<String, dynamic> parsedJson) {
    return Voucher(
        code: parsedJson['coupon_name'],
        name: parsedJson['voucher'],
        type: parsedJson['voucher_type'],
        image: parsedJson['image'],
        text: parsedJson['promo_text']);
  }
}
