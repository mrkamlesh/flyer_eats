import 'package:equatable/equatable.dart';
import 'package:clients/model/shop.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChooseShopEvent extends Equatable {
  const ChooseShopEvent();
}

class EntryShopName extends ChooseShopEvent {
  final String name;

  const EntryShopName(this.name);

  @override
  List<Object> get props => [name];
}

class EntryDescription extends ChooseShopEvent {
  final String description;

  const EntryDescription(this.description);

  @override
  List<Object> get props => [description];
}

class EntryAddress extends ChooseShopEvent {
  final String address;

  const EntryAddress(this.address);

  @override
  List<Object> get props => [address];
}

class PageOpen extends ChooseShopEvent {
  final Shop shop;

  const PageOpen(this.shop);

  @override
  List<Object> get props => [shop];
}

class UpdateLatLng extends ChooseShopEvent {
  final double lat;
  final double lng;

  UpdateLatLng(this.lat, this.lng);

  @override
  List<Object> get props => [lat, lng];
}
