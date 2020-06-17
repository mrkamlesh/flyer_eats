import 'package:flyereats/model/login_status.dart';
import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final List<String> listLocations;

  RegisterState({this.listLocations});
}

class InitialRegisterState extends RegisterState {
  InitialRegisterState() : super(listLocations: List());
}

class LoadingRegister extends RegisterState {
  LoadingRegister({List<String> listLocations})
      : super(listLocations: listLocations);
}

class SuccessRegister extends RegisterState {
  final LoginStatus status;

  SuccessRegister(this.status, {List<String> listLocations})
      : super(listLocations: listLocations);
}

class ErrorRegister extends RegisterState {
  final String message;

  ErrorRegister(this.message, {List<String> listLocations})
      : super(listLocations: listLocations);
}

class LoadingLocations extends RegisterState {
  LoadingLocations({List<String> listLocations})
      : super(listLocations: listLocations);
}

class SuccessLocations extends RegisterState {

  SuccessLocations(List<String> listLocations) : super(listLocations: listLocations);
}

class ErrorLocations extends RegisterState {
  final String message;

  ErrorLocations(this.message, {List<String> listLocations})
      : super(listLocations: listLocations);
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
