class Voucher {
  final String id;
  final String name;
  final String type;
  final double amount;
  final double rate;
  final String code;

  Voucher({this.id, this.name, this.type, this.amount, this.code, this.rate});

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
        type: parsedJson['voucher_type']);
  }
}
