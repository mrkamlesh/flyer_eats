import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEmailEvent extends Equatable {
  const LoginEmailEvent();
}

class CheckEmailExist extends LoginEmailEvent {

  const CheckEmailExist();

  @override
  List<Object> get props => [];
}

class ChangeEmail extends LoginEmailEvent {
  final String email;

  const ChangeEmail(this.email);

  @override
  List<Object> get props => [email];
}

class LoginByFacebook extends LoginEmailEvent {
  const LoginByFacebook();

  @override
  List<Object> get props => [];
}

class LoginByGmail extends LoginEmailEvent {
  const LoginByGmail();

  @override
  List<Object> get props => [];
}

class CheckSocialMediaProfile extends LoginEmailEvent {
  final String email;
  final String name;
  final String avatar;

  const CheckSocialMediaProfile({this.email, this.name, this.avatar});

  @override
  List<Object> get props => [];
}


