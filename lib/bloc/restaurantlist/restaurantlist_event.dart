import 'package:equatable/equatable.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();
}

class GetFirstDataRestaurantList extends RestaurantListEvent {
  final String token;
  final String address;
  final MerchantType merchantType;
  final RestaurantListType type;
  final String category;

  const GetFirstDataRestaurantList(
      this.token, this.address, this.merchantType, this.type, this.category);

  @override
  List<Object> get props => [token, address, merchantType, type, category];
}

class LoadMore extends RestaurantListEvent {
  final String token;
  final String address;
  final MerchantType merchantType;
  final RestaurantListType type;
  final String category;

  const LoadMore(
      this.token, this.address, this.merchantType, this.type, this.category);

  @override
  List<Object> get props => [token, address, merchantType, type, category];
}

class SelectSortBy extends RestaurantListEvent {
  final String selectedSortBy;

  const SelectSortBy(this.selectedSortBy);

  @override
  List<Object> get props => [selectedSortBy];
}

class AddFilter extends RestaurantListEvent {
  final String addedFilter;

  const AddFilter(this.addedFilter);

  @override
  List<Object> get props => [addedFilter];
}

class RemoveFilter extends RestaurantListEvent {
  final String removedFilter;

  const RemoveFilter(this.removedFilter);

  @override
  List<Object> get props => [removedFilter];
}

class ApplyFilter extends RestaurantListEvent {
  final String token;
  final String address;
  final MerchantType merchantType;
  final RestaurantListType type;
  final String category;

  const ApplyFilter(
      this.token, this.address, this.merchantType, this.type, this.category);

  @override
  List<Object> get props => [token, address, merchantType, type, category];
}

class ClearFilter extends RestaurantListEvent {
  final String token;
  final String address;
  final MerchantType merchantType;
  final RestaurantListType type;
  final String category;

  const ClearFilter(
      this.token, this.address, this.merchantType, this.type, this.category);

  @override
  List<Object> get props => [token, address, merchantType, type, category];
}
