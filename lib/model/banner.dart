import 'package:clients/model/restaurant.dart';

class BannerItem {
  final String promoId;
  final String merchantId;
  final String image;
  final Restaurant restaurant;

  BannerItem(this.promoId, this.merchantId, this.image, this.restaurant);

  factory BannerItem.fromJson(Map<String, dynamic> parsedJson) {
    return BannerItem(parsedJson['soffer_id'], parsedJson['merchant_id'],
        parsedJson['soffer_img1'], Restaurant.fromJson(parsedJson['restaurant_detail']));
  }
}
