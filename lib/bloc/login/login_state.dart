import 'package:clients/model/user.dart';

class LoginState {
  final User user;
  final bool isValid;

  LoginState({
    this.isValid,
    this.user,
  });

  LoginState copyWith({User user, bool isValid}) {
    return LoginState(
        user: user ?? this.user, isValid: isValid ?? this.isValid);
  }
}

class Loading extends LoginState {
  Loading({User user, bool isValid}) : super(user: user, isValid: isValid);
}

class Success extends LoginState {
  Success({User user, bool isValid}) : super(user: user, isValid: isValid);
}

class LoggedIn extends LoginState {
  LoggedIn({User user, bool isValid}) : super(user: user, isValid: isValid);
}

class Error extends LoginState {
  final String error;

  Error(this.error, {User user, bool isValid})
      : super(user: user, isValid: isValid);
}

class InitialState extends LoginState {
  InitialState() : super();
}

class LoggedOut extends LoginState {
  LoggedOut() : super();
}

class NotLoggedIn extends LoginState {
  NotLoggedIn({bool isValid}) : super(isValid: isValid);
}

class ErrorInitLogin extends LoginState {
  final String message;

  ErrorInitLogin(this.message, {bool isValid}) : super(isValid: isValid);
}
