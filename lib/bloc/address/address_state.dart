import 'package:equatable/equatable.dart';
import 'package:clients/model/address.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressLoaded extends AddressState {
  final Address address;

  const AddressLoaded(this.address);

  @override
  List<Object> get props => [address];
}

class LoadingAddressInformation extends AddressState {
  const LoadingAddressInformation();

  @override
  List<Object> get props => [];
}

class ErrorLoadingAddressInformation extends AddressState {
  final String message;

  const ErrorLoadingAddressInformation(this.message);

  @override
  List<Object> get props => [message];
}

class ListAddressLoaded extends AddressState {
  final List<Address> list;

  const ListAddressLoaded(this.list);

  @override
  List<Object> get props => [list];
}

class LoadingListAddress extends AddressState {
  const LoadingListAddress();

  @override
  List<Object> get props => [];
}

class ErrorLoadingListAddress extends AddressState {
  final String message;

  const ErrorLoadingListAddress(this.message);

  @override
  List<Object> get props => [message];
}

class NoAddressLoaded extends AddressState {
  const NoAddressLoaded();

  @override
  List<Object> get props => [];
}

class PriceCalculateSuccess extends AddressState {
  final double price;

  const PriceCalculateSuccess(this.price);

  @override
  List<Object> get props => [price];
}

class PriceCalculateLoading extends AddressState {
  const PriceCalculateLoading();

  @override
  List<Object> get props => [];
}

class PriceCalculateError extends AddressState {
  final String message;

  const PriceCalculateError(this.message);

  @override
  List<Object> get props => [message];
}

class AddressUpdated extends AddressState {
  final Address address;
  final bool isUpdated;

  const AddressUpdated(this.address, this.isUpdated);

  @override
  List<Object> get props => [address, isUpdated];
}

class AddressAdded extends AddressState {
  final bool isAdded;
  final Address address;

  const AddressAdded(this.isAdded, this.address);

  @override
  List<Object> get props => [];
}

class AddressRemoved extends AddressState {
  final bool isRemoved;

  const AddressRemoved(this.isRemoved);

  @override
  List<Object> get props => [isRemoved];
}

class InitState extends AddressState {
  const InitState();

  @override
  List<Object> get props => [];
}

class LoadingTemporaryAddress extends AddressState {
  const LoadingTemporaryAddress();

  @override
  List<Object> get props => [];
}

class LoadingTemporaryAddressError extends AddressState {
  final String message;

  const LoadingTemporaryAddressError(this.message);

  @override
  List<Object> get props => [message];
}

class LoadingTemporaryAddressSuccess extends AddressState {
  final Address address;
  final bool isFromMap;

  const LoadingTemporaryAddressSuccess(this.address, {this.isFromMap});

  @override
  List<Object> get props => [address];
}
