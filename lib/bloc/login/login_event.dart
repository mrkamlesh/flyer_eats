import 'package:equatable/equatable.dart';
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
