import 'package:clients/model/restaurant.dart';
import 'package:equatable/equatable.dart';
import 'package:clients/model/food_cart.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailPageEvent extends Equatable {
  const DetailPageEvent();
}

class PageDetailRestaurantOpen extends DetailPageEvent {
  final String restaurantId;

  const PageDetailRestaurantOpen(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class RestaurantMenuChange extends DetailPageEvent {
  final String restaurantId;
  final String menuId;

  final int menuSelected;

  const RestaurantMenuChange(this.restaurantId, this.menuId, this.menuSelected);

  @override
  List<Object> get props => [restaurantId, menuId, menuSelected];
}

class SwitchVegOnly extends DetailPageEvent {
  final bool isVegOnly;
  final String restaurantId;

  const SwitchVegOnly(this.restaurantId, this.isVegOnly);

  @override
  List<Object> get props => [restaurantId, isVegOnly];
}

class FilterList extends DetailPageEvent {
  const FilterList();

  @override
  List<Object> get props => [];
}

class SearchFood extends DetailPageEvent {
  final String restaurantId;
  final String keyword;

  SearchFood(this.restaurantId, this.keyword);

  @override
  List<Object> get props => [restaurantId, keyword];
}

class UpdateCurrentCart extends DetailPageEvent {
  final Restaurant cartRestaurant;
  final FoodCart foodCart;

  UpdateCurrentCart(this.foodCart, this.cartRestaurant);

  @override
  List<Object> get props => [foodCart, cartRestaurant];
}
