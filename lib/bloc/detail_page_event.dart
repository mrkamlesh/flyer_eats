import 'package:equatable/equatable.dart';
import 'package:flyereats/model/food.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailPageEvent extends Equatable {
  const DetailPageEvent();
}

class PageOpen extends DetailPageEvent {
  const PageOpen();

  @override
  List<Object> get props => [];
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

class SwitchCategory extends DetailPageEvent {
  final String id;

  const SwitchCategory(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeQuantity extends DetailPageEvent {
  final int id;
  final Food food;
  final int quantity;

  const ChangeQuantity(this.id, this.food, this.quantity);

  @override
  List<Object> get props => [id, food, quantity];
}
