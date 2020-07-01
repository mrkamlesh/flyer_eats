class PaymentMethod {
  final String value;
  final String label;

  PaymentMethod({this.value, this.label});

  String getIcon(){
    switch(value){
      case "cod":
        return "assets/cod.svg";
      default:
        return "assets/onlinepayment.svg";
    }
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> parsedJson) {
    return PaymentMethod(
      value: parsedJson['value'],
      label: parsedJson['label'],
    );
  }
}
