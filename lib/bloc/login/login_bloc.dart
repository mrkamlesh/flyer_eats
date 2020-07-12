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
    } else if (event is InitLoginEvent) {
      yield* mapInitLoginEventToState();
    } else if (event is LogOut) {
      yield* mapLogOutToState();
    } else if (event is UpdateUserProfile) {
      yield* mapUpdateUserProfileToState(event.user);
    }
  }

  Stream<LoginState> mapVerifyOtpToState(String contactPhone, String otpCode) async* {
    yield Loading(user: state.user, isValid: state.isValid);
    try {
      var result = await _repository.verifyOtp(contactPhone, otpCode);
      if (result is User) {
        _repository.saveToken(result.token);
        yield Success(user: result, isValid: true);
      } else {
        yield Error(result as String);
      }
    } catch (e) {
      yield Error(e.toString(), user: state.user, isValid: state.isValid);
    }
  }

  Stream<LoginState> mapInitLoginEventToState() async* {
    try {
      String token = await _repository.getSavedToken();
      if (token != null) {
        User user = await _repository.checkTokenValid(token);
        yield LoggedIn(user: user, isValid: state.isValid);
      } else {
        yield NotLoggedIn(isValid: false);
      }
    } catch (e) {
      yield NotLoggedIn(isValid: false);
    }
  }

  Stream<LoginState> mapLogOutToState() async* {
    try {
      bool isLoggedOut = await _repository.removeSavedToken();
      if (isLoggedOut) {
        yield LoggedOut();
      }
    } catch (e) {}
  }

  Stream<LoginState> mapUpdateUserProfileToState(User user) async* {
    yield LoginState(
        isValid: state.isValid, user: state.user.copyWith(phone: user.phone, name: user.name, avatar: user.avatar));
  }
}
