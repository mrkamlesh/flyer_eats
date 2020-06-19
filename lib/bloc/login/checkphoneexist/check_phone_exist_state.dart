class LoginPhoneState {
  final String countryCode;
  final String number;

  LoginPhoneState({this.countryCode, this.number});
}

class InitialLoginPhoneState extends LoginPhoneState {
  InitialLoginPhoneState() : super(countryCode: "+91", number: "");
}

class LoadingCheckPhoneExist extends LoginPhoneState {
  LoadingCheckPhoneExist({String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}

class PhoneIsExist extends LoginPhoneState {
  PhoneIsExist({String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}

class PhoneIsNotExist extends LoginPhoneState {

  PhoneIsNotExist({String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}

class ErrorCheckPhoneExist extends LoginPhoneState {
  final String message;

  ErrorCheckPhoneExist(this.message, {String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}
