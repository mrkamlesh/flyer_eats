part of 'change_contact_bloc.dart';

@immutable
abstract class ChangeContactEvent {}

class VerifyOtpChangeContact extends ChangeContactEvent {
  final String contactPhone;
  final bool isDefault;
  final String token;

  VerifyOtpChangeContact(this.contactPhone, this.isDefault, this.token);
}

class ChangeOtpCode extends ChangeContactEvent {
  final String otpCode;

  ChangeOtpCode(this.otpCode);
}
