import 'package:clients/model/add_ons_type.dart';
import 'package:clients/model/price.dart';

class FoodDetail {
  final String foodId;
  final List<Price> prices;
  final List<AddOnsType> addOnsTypes;

  FoodDetail({this.foodId, this.prices, this.addOnsTypes});

  factory FoodDetail.fromJson(Map<String, dynamic> parsedJson) {
    var pricesJson = parsedJson['prices'] as List;
    List<Price> prices = pricesJson.map((i) {
      return Price.fromJsonFoodDetail(i);
    }).toList();

    var addOnsTypesJson = parsedJson['addon_item'] as List;
    List<AddOnsType> addOnsTypes = addOnsTypesJson.map((i) {
      return AddOnsType.fromJson(i);
    }).toList();

    return FoodDetail(prices: prices, addOnsTypes: addOnsTypes, foodId: parsedJson['item_id']);
  }
}
