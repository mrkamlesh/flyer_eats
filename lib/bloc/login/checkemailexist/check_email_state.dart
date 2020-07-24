import 'package:meta/meta.dart';

@immutable
class CheckEmailState {
  final String email;
  final String name;
  final String avatar;

  CheckEmailState({this.email, this.name, this.avatar});
}

class InitialLoginEmailState extends CheckEmailState {
  InitialLoginEmailState() : super(email: "");
}

class LoadingCheckEmailExist extends CheckEmailState {
  LoadingCheckEmailExist(String email) : super(email: email);
}

class EmailIsExist extends CheckEmailState {
  EmailIsExist(String email) : super(email: email);
}

class EmailIsNotExist extends CheckEmailState {
  EmailIsNotExist({String email, String name, String avatar})
      : super(email: email, avatar: avatar, name: name);
}

class ErrorCheckEmailExist extends CheckEmailState {
  final String message;

  ErrorCheckEmailExist(this.message) : super();
}
