import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
import 'package:geolocator/geolocator.dart';
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
      LoginStatus status = await repository.checkPhoneExist(state.countryCode + state.number);
      if (status.status) {
        yield PhoneIsExist(countryCode: state.countryCode, number: state.number);
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
    AppUtil.checkLocationServiceAndPermission();
    yield LoadingLoginPhoneState(countryCode: state.countryCode, number: state.number);
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 5), onTimeout: () {
        return null;
      });

      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemark[0].isoCountryCode == "SG") {
        yield LoginPhoneState(countryCode: "+65", number: "");
      } else {
        yield LoginPhoneState(countryCode: "+91", number: "");
      }
    } catch (e) {
      yield InitialLoginPhoneState();
    }
  }
}
