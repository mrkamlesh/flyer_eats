import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
import 'package:sms_autofill/sms_autofill.dart';
import './bloc.dart';

class LoginEmailBloc extends Bloc<LoginEmailEvent, LoginEmailState> {
  DataRepository repository = DataRepository();

  @override
  LoginEmailState get initialState => InitialLoginEmailState();

  @override
  Stream<LoginEmailState> mapEventToState(
    LoginEmailEvent event,
  ) async* {
    if (event is UpdatePassword) {
      yield* mapUpdatePasswordToState(event.password);
    } else if (event is Login) {
      yield* mapLoginToState(event.email, event.password, event.contactPhone);
    } else if (event is ForgotPassword) {
      yield* mapForgotPasswordToState(event.email);
    }
  }

  Stream<LoginEmailState> mapUpdatePasswordToState(String password) async* {
    yield LoginEmailState(password: password);
  }

  Stream<LoginEmailState> mapLoginToState(String email, String password, String contactPhone) async* {
    yield LoadingState(password: state.password);

    try {
      String otpSignature = await SmsAutoFill().getAppSignature;
      await repository.loginByEmail(contactPhone, email, password, otpSignature);
      yield SuccessState(otpSignature, password: password);
    } catch (e) {
      yield ErrorState(e.toString(), password: state.password);
    }
  }

  Stream<LoginEmailState> mapForgotPasswordToState(String email) async* {
    yield LoadingState(password: state.password);

    try {
      //Do something here like hit forgot password api
      LoginStatus loginStatus = await repository.forgotPassword(email);
      yield SuccessForgotPassword(loginStatus.message, password: state.password);
    } catch (e) {
      yield ErrorState(e.toString(), password: state.password);
    }
  }
}
