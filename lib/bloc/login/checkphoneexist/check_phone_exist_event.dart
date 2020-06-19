import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginPhoneEvent extends Equatable {
  const LoginPhoneEvent();
}

class CheckPhoneExist extends LoginPhoneEvent {

  const CheckPhoneExist();

  @override
  List<Object> get props => [];
}

class ChangeCountryCode extends LoginPhoneEvent {
  final String countryCode;

  const ChangeCountryCode(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}

class ChangeNumber extends LoginPhoneEvent {
  final String number;

  const ChangeNumber(this.number);

  @override
  List<Object> get props => [number];
}