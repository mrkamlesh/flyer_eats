import 'package:flyereats/model/login_status.dart';
import 'package:meta/meta.dart';

@immutable
class LoginEmailState {}

class InitialLoginEmailState extends LoginEmailState {
  InitialLoginEmailState() : super();
}


class LoadingCheckEmailExist extends LoginEmailState {
  LoadingCheckEmailExist() : super();
}

class SuccessCheckEmailExist extends LoginEmailState {

  final LoginStatus status;

  SuccessCheckEmailExist(this.status) : super();
}

class ErrorCheckEmailExist extends LoginEmailState {
  final String message;

  ErrorCheckEmailExist(this.message) : super();
}
