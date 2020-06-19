import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/login_status.dart';
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
    }
  }

  Stream<LoginPhoneState> mapCheckPhoneExistToState() async* {
    yield LoadingCheckPhoneExist(
        countryCode: state.countryCode, number: state.number);

    try {
      LoginStatus status =
          await repository.checkPhoneExist(state.countryCode + state.number);
      if (status.status) {
        yield PhoneIsExist(
            countryCode: state.countryCode, number: state.number);
      } else {
        yield PhoneIsNotExist(
            countryCode: state.countryCode, number: state.number);
      }
    } catch (e) {
      yield ErrorCheckPhoneExist(e.toString(),
          countryCode: state.countryCode, number: state.number);
    }
  }

  Stream<LoginPhoneState> mapChangeCountryCodeToState(
      String countryCode) async* {
    yield LoginPhoneState(countryCode: countryCode, number: state.number);
  }

  Stream<LoginPhoneState> mapChangeNumberToState(String number) async* {
    yield LoginPhoneState(countryCode: state.countryCode, number: number);
  }
}
