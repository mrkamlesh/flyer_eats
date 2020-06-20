class Promo {
  final String promoId;
  final String merchantId;
  final String image;

  Promo(this.promoId, this.merchantId, this.image);

  factory Promo.fromJson(Map<String, dynamic> parsedJson) {
    return Promo(parsedJson['soffer_id'], parsedJson['merchant_id'],
        parsedJson['soffer_img1']);
  }
}
