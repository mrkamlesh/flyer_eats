import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class InitLoginEvent extends LoginEvent {
  const InitLoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEventWithEmail extends LoginEvent {
  final String email;
  final String password;

  const LoginEventWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class ValidateInput extends LoginEvent {
  final String email;
  final String password;

  const ValidateInput(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
