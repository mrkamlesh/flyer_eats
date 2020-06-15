import 'package:flyereats/model/user.dart';

class OtpState {
  OtpState();
}

class InitialOtpState extends OtpState {
  InitialOtpState() : super();
}

class LoadingVerifyOtp extends OtpState {
  LoadingVerifyOtp() : super();
}

class SuccessVerifyOtp extends OtpState {
  final User user;

  SuccessVerifyOtp(this.user) : super();
}

class ErrorVerifyOtp extends OtpState {
  final String message;

  ErrorVerifyOtp(this.message) : super();
}
