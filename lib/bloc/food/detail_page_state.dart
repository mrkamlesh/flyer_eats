import 'package:equatable/equatable.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailPageState extends Equatable {
  const DetailPageState();
}

class Uninitialized extends DetailPageState {
  const Uninitialized();

  @override
  List<Object> get props => [];
}

class OnDataLoading extends DetailPageState {
  const OnDataLoading();

  @override
  List<Object> get props => [];
}

class OnDataLoaded extends DetailPageState {
  final List<Food> list;

  const OnDataLoaded(this.list);

  @override
  List<Object> get props => [list];
}

class OnDataError extends DetailPageState {
  final String error;

  const OnDataError(this.error);

  @override
  List<Object> get props => [error];
}

class CartState extends DetailPageState {
  final FoodCart cart;

  const CartState(this.cart);

  @override
  List<Object> get props => [cart];
}

class MenusLoaded extends DetailPageState {
  final List<MenuCategory> menus;

  const MenusLoaded(this.menus);

  @override
  List<Object> get props => [menus];
}

class NoFoodAvailable extends DetailPageState {

  const NoFoodAvailable();

  @override
  List<Object> get props => [];
}