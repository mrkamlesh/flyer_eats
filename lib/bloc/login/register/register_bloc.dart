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
    } else if (event is GetLocations) {
      yield* mapGetLocationsToState();
    }
  }

  Stream<RegisterState> mapRegisterToState(Register event) async* {
    yield LoadingRegister(listLocations: state.listLocations);

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
        email: event.email,
        avatar: event.avatar,
      );
      if (status.status) {
        yield SuccessRegister(status, listLocations: state.listLocations);
      } else {
        yield ErrorRegister(status.message, listLocations: state.listLocations);
      }
    } catch (e) {
      yield ErrorRegister(e.toString());
    }
  }

  Stream<RegisterState> mapGetLocationsToState() async* {
    yield LoadingLocations(listLocations: state.listLocations);

    try {
      List<String> list = await repository.getRegisterLocations();
      yield SuccessLocations(list);
    } catch (e) {
      yield ErrorLocations(e.toString(), listLocations: state.listLocations);
    }
  }
}
