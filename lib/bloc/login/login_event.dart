import 'package:clients/model/address.dart';
import 'package:equatable/equatable.dart';
import 'package:clients/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class VerifyOtp extends LoginEvent {
  final String contactPhone;
  final String otpCode;

  const VerifyOtp(this.contactPhone, this.otpCode);

  @override
  List<Object> get props => [contactPhone, otpCode];
}

class InitLoginEvent extends LoginEvent {
  const InitLoginEvent();

  @override
  List<Object> get props => [];
}

class LogOut extends LoginEvent {
  const LogOut();

  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends LoginEvent {
  final User user;

  const UpdateUserProfile(this.user);

  @override
  List<Object> get props => [user];
}

class UpdatePrimaryContact extends LoginEvent {
  final String contact;

  const UpdatePrimaryContact(this.contact);

  @override
  List<Object> get props => [contact];
}

class UpdateDefaultAddress extends LoginEvent {
  final Address address;

  const UpdateDefaultAddress(this.address);

  @override
  List<Object> get props => [address];
}
