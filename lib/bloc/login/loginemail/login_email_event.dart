import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEmailEvent extends Equatable {
  const LoginEmailEvent();
}

class Login extends LoginEmailEvent {
  final String email;
  final String password;

  const Login(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class UpdatePassword extends LoginEmailEvent {
  final String password;

  const UpdatePassword(this.password);

  @override
  List<Object> get props => [password];
}

class ForgotPassword extends LoginEmailEvent {
  final String email;

  const ForgotPassword(this.email);

  @override
  List<Object> get props => [email];
}

