import 'package:equatable/equatable.dart';
import 'package:flyereats/model/address.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddressEvent extends Equatable {
  const AddressEvent();
}

class InitDefaultAddress extends AddressEvent {
  const InitDefaultAddress();

  @override
  List<Object> get props => [];
}

class OpenListAddress extends AddressEvent {

  const OpenListAddress();

  @override
  List<Object> get props => [];
}

class OpenAddress extends AddressEvent {

  final String id;

  const OpenAddress(this.id);

  @override
  List<Object> get props => [id];
}


class AddAddress extends AddressEvent {

  final Address address;

  const AddAddress(this.address);

  @override
  List<Object> get props => [address];
}

class UpdateAddress extends AddressEvent {

  final String id;

  const UpdateAddress(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveAddress extends AddressEvent {

  final String id;

  const RemoveAddress(this.id);

  @override
  List<Object> get props => [id];
}

class ValidatingAddress extends AddressEvent{

  final Address address;

  const ValidatingAddress(this.address);

  @override
  List<Object> get props => [address];
}