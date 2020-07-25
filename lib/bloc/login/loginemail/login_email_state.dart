import 'package:meta/meta.dart';

@immutable
class LoginEmailState {
  final String password;

  LoginEmailState({this.password});
}

class InitialLoginEmailState extends LoginEmailState {
  InitialLoginEmailState() : super();
}

class LoadingState extends LoginEmailState {
  LoadingState({String password}) : super(password: password);
}

class SuccessState extends LoginEmailState {
  SuccessState({String password}) : super(password: password);
}

class ErrorState extends LoginEmailState {
  final String message;

  ErrorState(this.message, {String password}) : super(password: password);
}

class SuccessForgotPassword extends LoginEmailState {
  final String message;

  SuccessForgotPassword(this.message, {String password}) : super(password: password);
}

class ErrorForgotPassword extends LoginEmailState {
  final String message;

  ErrorForgotPassword(this.message, {String password}) : super(password: password);
}
