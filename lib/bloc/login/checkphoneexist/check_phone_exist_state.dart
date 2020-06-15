import 'package:flyereats/model/login_status.dart';

class LoginPhoneState {
  LoginPhoneState();
}

class InitialLoginPhoneState extends LoginPhoneState {
  InitialLoginPhoneState() : super();
}

class LoadingCheckPhoneExist extends LoginPhoneState {
  LoadingCheckPhoneExist() : super();
}

class SuccessCheckPhoneExist extends LoginPhoneState {
  final String phoneNumber;
  final LoginStatus status;

  SuccessCheckPhoneExist(this.status, this.phoneNumber) : super();
}

class ErrorCheckPhoneExist extends LoginPhoneState {
  final String message;
  final String phoneNumber;

  ErrorCheckPhoneExist(this.message, this.phoneNumber) : super();
}
