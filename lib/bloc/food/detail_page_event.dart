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
  final String address;

  const PageDetailRestaurantOpen(this.restaurantId, this.address);

  @override
  List<Object> get props => [restaurantId, address];
}

class RestaurantMenuChange extends DetailPageEvent {
  final String restaurantId;
  final String menuId;

  final int menuSelected;
  final String address;

  const RestaurantMenuChange(
      this.restaurantId, this.menuId, this.menuSelected, this.address);

  @override
  List<Object> get props => [restaurantId, menuId, menuSelected, address];
}

class SwitchVegOnly extends DetailPageEvent {
  final bool isVegOnly;
  final String restaurantId;
  final String address;

  const SwitchVegOnly(this.restaurantId, this.isVegOnly, this.address);

  @override
  List<Object> get props => [restaurantId, isVegOnly, address];
}

class FilterList extends DetailPageEvent {
  const FilterList();

  @override
  List<Object> get props => [];
}

class SearchFood extends DetailPageEvent {
  final String restaurantId;
  final String keyword;
  final String address;

  SearchFood(this.restaurantId, this.keyword, this.address);

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

class InitializeSearch extends DetailPageEvent {
  InitializeSearch();

  @override
  List<Object> get props => [];
}
