class Voucher {
  final String id;
  final String name;
  final String type;
  final double amount;

  Voucher({this.id, this.name, this.type, this.amount});

  factory Voucher.fromJson(Map<String, dynamic> parsedJson) {
    return Voucher(
        id: parsedJson['voucher_id'],
        name: parsedJson['voucher_name'],
        type: parsedJson['voucher_type'],
        amount: double.parse(parsedJson['amount']));
  }
}
