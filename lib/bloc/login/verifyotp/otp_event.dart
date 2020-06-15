import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OtpEvent extends Equatable {
  const OtpEvent();
}

class VerifyOtp extends OtpEvent {
  final String contactPhone;
  final String otpCode;

  const VerifyOtp(this.contactPhone, this.otpCode);

  @override
  List<Object> get props => [contactPhone, otpCode];
}
