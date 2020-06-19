import 'package:meta/meta.dart';

@immutable
class LoginEmailState {
  final String email;
  final String name;
  final String avatar;

  LoginEmailState({this.email, this.name, this.avatar});
}

class InitialLoginEmailState extends LoginEmailState {
  InitialLoginEmailState() : super(email: "");
}

class LoadingCheckEmailExist extends LoginEmailState {
  LoadingCheckEmailExist(String email) : super(email: email);
}

class EmailIsExist extends LoginEmailState {
  EmailIsExist(String email) : super(email: email);
}

class EmailIsNotExist extends LoginEmailState {
  EmailIsNotExist({String email, String name, String avatar})
      : super(email: email, avatar: avatar, name: name);
}

class ErrorCheckEmailExist extends LoginEmailState {
  final String message;

  ErrorCheckEmailExist(this.message) : super();
}
