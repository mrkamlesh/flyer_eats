class Wallet {
  final double walletAmount;
  final double scratchAmount;
  final double loyaltyAmount;
  final String currency;
  final String razorpayKey;
  final String razorpaySecret;

  Wallet(
      {this.walletAmount,
      this.scratchAmount,
      this.loyaltyAmount,
      this.currency,
      this.razorpayKey,
      this.razorpaySecret});

  factory Wallet.fromJson(Map<String, dynamic> parsedJson) {
    return Wallet(
      currency: parsedJson['currency_code'],
      walletAmount: double.parse(parsedJson['wallet_amount'].toString()),
      scratchAmount: double.parse(parsedJson['scratch_amount'].toString()),
      loyaltyAmount: 0,
      razorpayKey: parsedJson['razor_key'],
      razorpaySecret: parsedJson['razor_secret'],
    );
  }
}
