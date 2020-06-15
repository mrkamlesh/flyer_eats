import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/login_status.dart';
import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  DataRepository repository = DataRepository();

  @override
  RegisterState get initialState => InitialRegisterState();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      yield* mapRegisterToState(event);
    }
  }

  Stream<RegisterState> mapRegisterToState(Register event) async* {

    yield LoadingRegister();

    try {
      LoginStatus status = await repository.register(
          referralCode: event.referralCode,
          locationName: event.locationName,
          fullName: event.fullName,
          devicePlatform: event.devicePlatform,
          deviceId: event.deviceId,
          countryCode: event.countryCode,
          contactPhone: event.contactPhone,
          appVersion: event.appVersion,
          email: event.email);
      if (status.status) {
        yield SuccessRegister(status);
      } else {
        yield ErrorRegister(status.message);
      }
    } catch (e) {
      yield ErrorRegister(e.toString());
    }
  }
}
