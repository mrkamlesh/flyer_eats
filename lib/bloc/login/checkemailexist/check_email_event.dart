import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckEmailEvent extends Equatable {
  const CheckEmailEvent();
}

class CheckEmailExist extends CheckEmailEvent {

  const CheckEmailExist();

  @override
  List<Object> get props => [];
}

class ChangeEmail extends CheckEmailEvent {
  final String email;

  const ChangeEmail(this.email);

  @override
  List<Object> get props => [email];
}

class LoginByFacebook extends CheckEmailEvent {
  const LoginByFacebook();

  @override
  List<Object> get props => [];
}

class LoginByGmail extends CheckEmailEvent {
  const LoginByGmail();

  @override
  List<Object> get props => [];
}

class CheckSocialMediaProfile extends CheckEmailEvent {
  final String email;
  final String name;
  final String avatar;

  const CheckSocialMediaProfile({this.email, this.name, this.avatar});

  @override
  List<Object> get props => [];
}


