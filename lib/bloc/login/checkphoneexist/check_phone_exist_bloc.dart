import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/login_status.dart';
import './bloc.dart';

class LoginPhoneBloc extends Bloc<LoginPhoneEvent, LoginPhoneState> {
  DataRepository repository = DataRepository();

  @override
  LoginPhoneState get initialState => InitialLoginPhoneState();

  @override
  Stream<LoginPhoneState> mapEventToState(
    LoginPhoneEvent event,
  ) async* {
    if (event is CheckPhoneExist) {
      yield* mapCheckPhoneExistToState(event.contactPhone);
    }
  }

  Stream<LoginPhoneState> mapCheckPhoneExistToState(
      String contactPhone) async* {

    yield LoadingCheckPhoneExist();

    try {
      LoginStatus status = await repository.checkPhoneExist(contactPhone);

      if (status.status) {
        yield SuccessCheckPhoneExist(status, contactPhone);
      } else {
        yield ErrorCheckPhoneExist(status.message, contactPhone);
      }
    } catch (e) {
      yield ErrorCheckPhoneExist(e.toString(), contactPhone);
    }
  }
}
