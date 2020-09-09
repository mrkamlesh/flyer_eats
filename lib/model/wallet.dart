import 'package:clients/model/payment_method.dart';

class Wallet {
  final double walletAmount;
  final double scratchAmount;
  final double loyaltyAmount;
  final String currencyCode;
  final String razorpayKey;
  final String razorpaySecret;
  final List<PaymentMethod> paymentMethods;
  final String stripePublishKey;
  final String stripeSecretKey;

  Wallet(
      {this.walletAmount,
      this.scratchAmount,
      this.loyaltyAmount,
      this.currencyCode,
      this.razorpayKey,
      this.razorpaySecret,
      this.paymentMethods,
      this.stripePublishKey,
      this.stripeSecretKey});

  factory Wallet.fromJson(Map<String, dynamic> parsedJson) {
    var listPaymentMethod = parsedJson['payment_list'] as List;
    List<PaymentMethod> listPayment = listPaymentMethod.map((i) {
      return PaymentMethod.fromJson(i);
    }).toList();

    return Wallet(
        currencyCode: parsedJson['currency_code'],
        walletAmount: double.parse(parsedJson['wallet_amount'].toString()),
        scratchAmount: double.parse(parsedJson['scratch_amount'].toString()),
        loyaltyAmount: 0,
        razorpayKey: parsedJson['razorpay']['razor_key'],
        razorpaySecret: parsedJson['razorpay']['razor_secret'],
        stripePublishKey: parsedJson['stripe_publish_key'],
        stripeSecretKey: parsedJson['stripe_secret_key'],
        paymentMethods: listPayment);
  }
}
