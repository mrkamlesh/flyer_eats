class LoginPhoneState {
  final String countryCode;
  final String number;

  LoginPhoneState({this.countryCode, this.number});

  bool isNumberValid() {
    return countryCode == "+91"
        ? number.length == 10 ? true : false
        : number.length == 8 ? true : false;
  }
}

class InitialLoginPhoneState extends LoginPhoneState {
  InitialLoginPhoneState() : super(countryCode: "+91", number: "");
}

class LoadingLoginPhoneState extends LoginPhoneState {
  LoadingLoginPhoneState({String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}

class PhoneIsExist extends LoginPhoneState {
  final String otpSignature;

  PhoneIsExist(this.otpSignature, {String countryCode, String number})
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

class LocationDetected extends LoginPhoneState {
  final String address;
  final String isoCountryCode;

  LocationDetected(this.address, this.isoCountryCode,
      {String countryCode, String number})
      : super(countryCode: countryCode, number: number);
}
