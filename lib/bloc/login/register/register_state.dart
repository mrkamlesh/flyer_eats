import 'package:clients/model/location.dart';
import 'package:clients/model/login_status.dart';
import 'package:meta/meta.dart';
import 'package:clients/model/register_post.dart';

@immutable
class RegisterState {
  final List<Location> listLocations;
  final RegisterPost registerPost;

  RegisterState({this.listLocations, this.registerPost});
}

class InitialRegisterState extends RegisterState {
  InitialRegisterState() : super(listLocations: List(), registerPost: RegisterPost(isUseReferral: false));
}

class LoadingRegister extends RegisterState {
  LoadingRegister({List<Location> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class SuccessRegister extends RegisterState {
  final LoginStatus status;

  SuccessRegister(this.status, {List<Location> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class ErrorRegister extends RegisterState {
  final String message;

  ErrorRegister(this.message, {List<Location> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class LoadingLocations extends RegisterState {
  LoadingLocations({List<Location> listLocations, RegisterPost registerPost})
      : super(listLocations: listLocations, registerPost: registerPost);
}

class ErrorLocations extends RegisterState {
  final String message;

  ErrorLocations(this.message, {List<Location> listLocations, RegisterPost registerPost})
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
