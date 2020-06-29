class BannerItem {
  final String promoId;
  final String merchantId;
  final String image;

  BannerItem(this.promoId, this.merchantId, this.image);

  factory BannerItem.fromJson(Map<String, dynamic> parsedJson) {
    return BannerItem(parsedJson['soffer_id'], parsedJson['merchant_id'],
        parsedJson['soffer_img1']);
  }
}
