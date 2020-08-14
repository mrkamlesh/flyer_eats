import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms_autofill/sms_autofill.dart';
import './bloc.dart';

class LoginPhoneBloc extends Bloc<LoginPhoneEvent, LoginPhoneState> {
  DataRepository repository = DataRepository();

  @override
  LoginPhoneState get initialState => InitialLoginPhoneState();

  @override
  Stream<LoginPhoneState> mapEventToState(
    LoginPhoneEvent event,
  ) async* {
    if (event is CheckPhoneExist) {
      yield* mapCheckPhoneExistToState();
    } else if (event is ChangeCountryCode) {
      yield* mapChangeCountryCodeToState(event.countryCode);
    } else if (event is ChangeNumber) {
      yield* mapChangeNumberToState(event.number);
    } else if (event is GetAutoLocation) {
      yield* mapGetAutoLocationToState();
    }
  }

  Stream<LoginPhoneState> mapCheckPhoneExistToState() async* {
    yield LoadingLoginPhoneState(countryCode: state.countryCode, number: state.number);

    try {
      String otpSignature = await SmsAutoFill().getAppSignature;
      LoginStatus status = await repository.checkPhoneExist(state.countryCode + state.number, otpSignature);
      if (status.status) {
        yield PhoneIsExist(otpSignature, countryCode: state.countryCode, number: state.number);
      } else {
        yield PhoneIsNotExist(countryCode: state.countryCode, number: state.number);
      }
    } catch (e) {
      yield ErrorCheckPhoneExist(e.toString(), countryCode: state.countryCode, number: state.number);
    }
  }

  Stream<LoginPhoneState> mapChangeCountryCodeToState(String countryCode) async* {
    yield LoginPhoneState(countryCode: countryCode, number: state.number);
  }

  Stream<LoginPhoneState> mapChangeNumberToState(String number) async* {
    yield LoginPhoneState(countryCode: state.countryCode, number: number);
  }

  Stream<LoginPhoneState> mapGetAutoLocationToState() async* {
    yield LoadingLoginPhoneState(countryCode: state.countryCode, number: state.number);
    await AppUtil.checkLocationServiceAndPermission();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 5), onTimeout: () {
        return null;
      });

      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      String thoroughfare =
          (placeMark[0].thoroughfare != "" && placeMark[0].thoroughfare != null) ? placeMark[0].thoroughfare + " " : "";
      String subThoroughfare = (placeMark[0].subThoroughfare != "" && placeMark[0].subThoroughfare != null)
          ? placeMark[0].subThoroughfare + " "
          : "";
      String subLocality =
          (placeMark[0].subLocality != "" && placeMark[0].subLocality != null) ? placeMark[0].subLocality + " " : "";
      String locality =
          (placeMark[0].locality != "" && placeMark[0].locality != null) ? placeMark[0].locality + " " : "";
      String subAdministrativeArea =
          (placeMark[0].subAdministrativeArea != "" && placeMark[0].subAdministrativeArea != null)
              ? placeMark[0].subAdministrativeArea + " "
              : "";
      String administrativeArea = (placeMark[0].administrativeArea != "" && placeMark[0].administrativeArea != null)
          ? placeMark[0].administrativeArea + " "
          : "";

      if (placeMark[0].isoCountryCode == "SG") {
        yield LocationDetected(
            thoroughfare + subThoroughfare + subLocality + locality + subAdministrativeArea + administrativeArea,
            placeMark[0].isoCountryCode,
            countryCode: "+65",
            number: "");
      } else {
        yield LocationDetected(
            thoroughfare + subThoroughfare + subLocality + locality + subAdministrativeArea + administrativeArea,
            placeMark[0].isoCountryCode,
            countryCode: "+91",
            number: "");
      }
    } catch (e) {
      yield InitialLoginPhoneState();
    }
  }
}
