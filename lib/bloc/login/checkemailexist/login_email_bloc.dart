import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/login_status.dart';
import './bloc.dart';

class LoginEmailBloc extends Bloc<LoginEmailEvent, LoginEmailState> {
  DataRepository repository = DataRepository();

  @override
  LoginEmailState get initialState => InitialLoginEmailState();

  @override
  Stream<LoginEmailState> mapEventToState(
    LoginEmailEvent event,
  ) async* {
    if (event is CheckEmailExist) {
      yield* mapCheckEmailExistToState(event.email);
    }
  }

  Stream<LoginEmailState> mapCheckEmailExistToState(String email) async* {

    yield LoadingCheckEmailExist();

    try {
      LoginStatus status = await repository.checkEmailExist(email);
      if (status.status) {
        yield SuccessCheckEmailExist(status);
      } else {
        yield ErrorCheckEmailExist(status.message);
      }
    } catch (e) {
      yield ErrorCheckEmailExist(e.toString());
    }
  }
}
