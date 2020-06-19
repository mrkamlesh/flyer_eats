import 'package:flyereats/model/login_status.dart';
import 'package:meta/meta.dart';
import 'package:flyereats/model/register_post.dart';

@immutable
class RegisterState {
  final List<String> listLocations;
  final RegisterPost registerPost;

  RegisterState({this.listLocations, this.registerPost});
}

class InitialRegisterState extends RegisterState {
  InitialRegisterState()
      : super(listLocations: List(), registerPost: RegisterPost());
}

class LoadingRegister extends RegisterState {
  LoadingRegister({List<String> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class SuccessRegister extends RegisterState {
  final LoginStatus status;

  SuccessRegister(this.status,
      {List<String> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class ErrorRegister extends RegisterState {
  final String message;

  ErrorRegister(this.message,
      {List<String> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class LoadingLocations extends RegisterState {
  LoadingLocations({List<String> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class ErrorLocations extends RegisterState {
  final String message;

  ErrorLocations(this.message,
      {List<String> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
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
