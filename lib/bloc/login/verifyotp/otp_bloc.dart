import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/user.dart';
import './bloc.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  DataRepository repository = DataRepository();

  @override
  OtpState get initialState => InitialOtpState();

  @override
  Stream<OtpState> mapEventToState(
    OtpEvent event,
  ) async* {
    if (event is VerifyOtp) {
      yield* mapVerifyOtpToState(event.contactPhone, event.otpCode);
    }
  }

  Stream<OtpState> mapVerifyOtpToState(
      String contactPhone, String otpCode) async* {
    yield LoadingVerifyOtp();
    try {
      var result = await repository.verifyOtp(contactPhone, otpCode);
      if (result is User) {
        yield SuccessVerifyOtp(result);
      } else {
        yield ErrorVerifyOtp(result as String);
      }
    } catch (e) {
      yield ErrorVerifyOtp(e.toString());
    }
  }
}
