import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();
}

class GetFirstDataRestaurantList extends RestaurantListEvent {
  final String address;

  const GetFirstDataRestaurantList(this.address);

  @override
  List<Object> get props => [address];
}

class LoadMore extends RestaurantListEvent {
  final String address;

  const LoadMore(this.address);

  @override
  List<Object> get props => [address];
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
  final String address;

  const ApplyFilter(this.address);

  @override
  List<Object> get props => [address];
}

class ClearFilter extends RestaurantListEvent {
  final String address;

  const ClearFilter(this.address);

  @override
  List<Object> get props => [address];
}
