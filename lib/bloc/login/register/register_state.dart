import 'package:flyereats/model/login_status.dart';
import 'package:meta/meta.dart';

@immutable
class RegisterState {}

class InitialRegisterState extends RegisterState {
  InitialRegisterState() : super();
}

class LoadingRegister extends RegisterState {
  LoadingRegister() : super();
}

class SuccessRegister extends RegisterState {

  final LoginStatus status;

  SuccessRegister(this.status) : super();
}

class ErrorRegister extends RegisterState {
  final String message;

  ErrorRegister(this.message) : super();
}

/*
class LoadingLocationRegister extends RegisterState {
  LoadingRegister() : super();
}

class SuccessRegister extends RegisterState {

  final LoginStatus status;

  SuccessRegister(this.status) : super();
}

class ErrorRegister extends RegisterState {
  final String message;

  ErrorRegister(this.message) : super();
}*/
