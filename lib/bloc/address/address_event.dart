import 'package:equatable/equatable.dart';
import 'package:clients/model/address.dart';
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
  final String token;

  const OpenListAddress(this.token);

  @override
  List<Object> get props => [token];
}

class OpenAddress extends AddressEvent {
  final String id;
  final String token;

  const OpenAddress(this.id, this.token);

  @override
  List<Object> get props => [id, token];
}

class AddAddress extends AddressEvent {
  final Address address;

  final String token;

  const AddAddress(this.address, this.token);

  @override
  List<Object> get props => [address, token];
}

class UpdateAddress extends AddressEvent {
  final Address address;
  final String token;

  const UpdateAddress(this.address, this.token);

  @override
  List<Object> get props => [address, token];
}

class RemoveAddress extends AddressEvent {
  final String id;

  final String token;

  const RemoveAddress(this.id, this.token);

  @override
  List<Object> get props => [id, token];
}

class ValidatingAddress extends AddressEvent {
  final Address address;

  const ValidatingAddress(this.address);

  @override
  List<Object> get props => [address];
}

class AddressAddPageOpen extends AddressEvent {
  const AddressAddPageOpen();

  @override
  List<Object> get props => [];
}

class UpdateAddressLocation extends AddressEvent {
  final double lat;
  final double lng;

  const UpdateAddressLocation(this.lat, this.lng);

  @override
  List<Object> get props => [lat, lng];
}

class UpdateAddressInformation extends AddressEvent {
  final String title;
  final String address;
  final AddressType type;
  final bool isDefault;

  const UpdateAddressInformation({
    this.title,
    this.address,
    this.type,
    this.isDefault,
  });

  @override
  List<Object> get props => [title, address, type, isDefault];
}

class AddressUpdatePageOpen extends AddressEvent {
  final Address address;

  const AddressUpdatePageOpen(this.address);

  @override
  List<Object> get props => [address];
}
