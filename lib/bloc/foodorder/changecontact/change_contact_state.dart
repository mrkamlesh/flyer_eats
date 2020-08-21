part of 'change_contact_bloc.dart';

@immutable
class ChangeContactState {
  final String otpCode;

  ChangeContactState({this.otpCode});

  bool isCodeValid() {
    return otpCode.length == 6;
  }
}

class ChangeContactInitial extends ChangeContactState {
  ChangeContactInitial() : super(otpCode: "");
}

class LoadingChangeContact extends ChangeContactState {
  LoadingChangeContact({String otpCode}) : super(otpCode: otpCode);
}

class SuccessChangeContact extends ChangeContactState {
  SuccessChangeContact({String otpCode}) : super(otpCode: otpCode);
}

class ErrorChangeContact extends ChangeContactState {
  final String message;

  ErrorChangeContact(this.message, {String otpCode}) : super(otpCode: otpCode);
}
