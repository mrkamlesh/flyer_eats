part of 'search_restaurant_bloc.dart';

@immutable
abstract class SearchRestaurantEvent extends Equatable {
  const SearchRestaurantEvent();
}

class SearchRestaurant extends SearchRestaurantEvent {
  final String token;
  final String address;
  final String searchText;

  SearchRestaurant(this.token, this.address, this.searchText);

  @override
  List<Object> get props => [token, address, searchText];
}
