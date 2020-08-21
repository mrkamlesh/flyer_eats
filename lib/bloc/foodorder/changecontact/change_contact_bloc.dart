import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:meta/meta.dart';

part 'change_contact_event.dart';

part 'change_contact_state.dart';

class ChangeContactBloc extends Bloc<ChangeContactEvent, ChangeContactState> {
  DataRepository repository = DataRepository();

  @override
  ChangeContactState get initialState => ChangeContactInitial();

  @override
  Stream<ChangeContactState> mapEventToState(
    ChangeContactEvent event,
  ) async* {
    if (event is VerifyOtpChangeContact) {
      yield* mapVerifyOtpChangeContactToState(
          event.contactPhone, event.isDefault, event.token);
    } else if (event is ChangeOtpCode) {
      yield* mapChangeOtpCodeToState(event.otpCode);
    }
  }

  Stream<ChangeContactState> mapVerifyOtpChangeContactToState(
      String contactPhone, bool isDefault, String token) async* {
    yield LoadingChangeContact(otpCode: state.otpCode);

    try {
      await repository.verifyOtpChangeContactPhone(
          contactPhone, state.otpCode, isDefault, token);
      yield SuccessChangeContact(otpCode: state.otpCode);
    } catch (e) {
      yield ErrorChangeContact(e.toString(), otpCode: state.otpCode);
    }
  }

  Stream<ChangeContactState> mapChangeOtpCodeToState(String otpCode) async* {
    yield ChangeContactState(otpCode: otpCode);
  }
}
