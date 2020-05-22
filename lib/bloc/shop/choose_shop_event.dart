import 'package:equatable/equatable.dart';
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

class EntryAddress extends ChooseShopEvent {
  final String address;

  const EntryAddress(this.address);

  @override
  List<Object> get props => [address];
}
