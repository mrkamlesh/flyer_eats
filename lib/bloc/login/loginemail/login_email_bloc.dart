import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
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
      yield* mapLoginToState(event.email, event.password);
    } else if (event is ForgotPassword) {
      yield* mapForgotPasswordToState(event.email);
    }
  }

  Stream<LoginEmailState> mapUpdatePasswordToState(String password) async* {
    yield LoginEmailState(password: password);
  }

  Stream<LoginEmailState> mapLoginToState(String email, String password) async* {
    yield LoadingState(password: state.password);

    try {
      await repository.loginByEmail(email, password);
      yield SuccessState(password: password);
    } catch (e) {
      yield ErrorState(e.toString(), password: state.password);
    }
  }

  Stream<LoginEmailState> mapForgotPasswordToState(String email) async* {
    yield LoadingState(password: state.password);

    try {
      //Do something here like hit forgot password api


    } catch (e) {
      yield ErrorState(e.toString(), password: state.password);
    }
  }
}
