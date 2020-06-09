import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/user.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  DataRepository _repository = DataRepository();

  @override
  LoginState get initialState => InitialState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEventWithEmail) {
      yield* mapLoginEventWithEmailToState(event.email, event.password);
    } else if (event is ValidateInput) {
      yield* mapValidateInputToState(event.email, event.password);
    } else if (event is InitLoginEvent) {
      yield* mapInitLoginEventToState();
    }
  }

  Stream<LoginState> mapLoginEventWithEmailToState(
      String email, String password) async* {
    yield Loading(user: state.user, isValid: state.isValid);
    try {
      User user = await _repository.loginWithEmail(email, password);
      if (user != null) {
        _repository.saveLoginInformation(email, password);
        yield Success(user: user, isValid: state.isValid);
      } else {
        yield Error("Login Failed. Either username or password is incorrect",
            user: state.user, isValid: state.isValid);
      }
    } catch (e) {
      yield Error(e.toString(), user: state.user, isValid: state.isValid);
    }
  }

  Stream<LoginState> mapValidateInputToState(
      String email, String password) async* {
    if (email != null && email != "" && password != null && password != "") {
      yield state.copyWith(user: state.user, isValid: true);
    } else {
      yield state.copyWith(user: state.user, isValid: false);
    }
  }

  Stream<LoginState> mapInitLoginEventToState() async* {
    Map<String, String> map = await _repository.getLoginInformation();
    if (map['email'] != null && map['password'] != null) {
      User user =
          await _repository.loginWithEmail(map['email'], map['password']);
      yield LoggedIn(user: user, isValid: state.isValid);
    } else {
      yield NotLoggedIn(isValid: false);
    }
  }
}
