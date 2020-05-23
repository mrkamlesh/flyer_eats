import 'package:equatable/equatable.dart';
import 'package:flyereats/model/address.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddressState extends Equatable {
  const AddressState();
}

class Loading extends AddressState {
  const Loading();

  @override
  List<Object> get props => [];
}

class AddressLoaded extends AddressState {
  final Address address;

  const AddressLoaded(this.address);

  @override
  List<Object> get props => [address];
}

class NoAddressLoaded extends AddressState {
  const NoAddressLoaded();

  @override
  List<Object> get props => [


  ];
}

class ErrorLoading extends AddressState {
  final String message;

  const ErrorLoading(this.message);

  @override
  List<Object> get props => [message];
}

class DefaultAddressLoaded extends AddressState {
  final Address address;

  const DefaultAddressLoaded(this.address);

  @override
  List<Object> get props => [address];
}

class ListAddressLoaded extends AddressState {
  final List<Address> list;

  const ListAddressLoaded(this.list);

  @override
  List<Object> get props => [list];
}

class AddressUpdated extends AddressState {
  const AddressUpdated();

  @override
  List<Object> get props => [];
}

class AddressAdded extends AddressState {
  const AddressAdded();

  @override
  List<Object> get props => [];
}

class AddressRemoved extends AddressState {
  const AddressRemoved();

  @override
  List<Object> get props => [];
}

class InitState extends AddressState {
  const InitState();

  @override
  List<Object> get props => [];
}
