import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/login/login_event.dart';
import 'package:flyereats/bloc/login/login_state.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  DataRepository _repository = DataRepository();

  @override
  LoginState get initialState => InitialState();

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is VerifyOtp) {
      yield* mapVerifyOtpToState(event.contactPhone, event.otpCode);
    }
  }

  Stream<LoginState> mapVerifyOtpToState(
      String contactPhone, String otpCode) async* {
    yield Loading(user: state.user, isValid: state.isValid);
    try {
      var result = await _repository.verifyOtp(contactPhone, otpCode);
      if (result is User) {
        yield Success(user: result, isValid: true);
      } else {
        yield Error(result as String);
      }
    } catch (e) {
      yield Error(e.toString(), user: state.user, isValid: state.isValid);
    }
  }
}