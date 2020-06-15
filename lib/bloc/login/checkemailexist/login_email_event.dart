import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEmailEvent extends Equatable {
  const LoginEmailEvent();
}

class CheckEmailExist extends LoginEmailEvent {
  final String email;

  const CheckEmailExist(this.email);

  @override
  List<Object> get props => [email];
}