import 'package:equatable/equatable.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class Search extends SearchEvent {
  final String token;
  final String address;
  final String searchText;

  Search(this.token, this.address, this.searchText);

  @override
  List<Object> get props => [token, address, searchText];
}

class LoadMore extends SearchEvent {
  final String token;
  final String address;

  LoadMore(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}

class ChangeQuantity extends SearchEvent {
  final String id;
  final Food food;
  final int quantity;
  final Restaurant selectedRestaurant;

  const ChangeQuantity(this.id, this.food, this.quantity, this.selectedRestaurant);

  @override
  List<Object> get props => [id, food, quantity, selectedRestaurant];
}

class ClearCart extends SearchEvent {
  const ClearCart();

  @override
  List<Object> get props => [];
}

class UpdateCart extends SearchEvent {
  final FoodCart foodCart;

  UpdateCart(this.foodCart);

  @override
  List<Object> get props => [foodCart];
}
