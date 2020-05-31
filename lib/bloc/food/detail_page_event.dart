import 'package:equatable/equatable.dart';
import 'package:flyereats/model/food.dart';
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

  const RestaurantMenuChange(this.restaurantId, this.menuId);

  @override
  List<Object> get props => [restaurantId, menuId];
}

class SwitchVegOnly extends DetailPageEvent {
  final bool isVegOnly;

  const SwitchVegOnly(this.isVegOnly);

  @override
  List<Object> get props => [isVegOnly];
}

class FilterList extends DetailPageEvent {
  const FilterList();

  @override
  List<Object> get props => [];
}

class ChangeQuantity extends DetailPageEvent {
  final int id;
  final Food food;
  final int quantity;

  const ChangeQuantity(this.id, this.food, this.quantity);

  @override
  List<Object> get props => [id, food, quantity];
}
