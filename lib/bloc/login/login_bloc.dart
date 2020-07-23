import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/login/login_event.dart';
import 'package:clients/bloc/login/login_state.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/classes/push_notification_manager.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/user.dart';
import 'package:package_info/package_info.dart';

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
    } else if (event is UpdatePrimaryContact) {
      yield* mapUpdatePrimaryContactToState(event.contact);
    } else if (event is UpdateDefaultAddress) {
      yield* mapUpdateDefaultAddressToState(event.address);
    }
  }

  Stream<LoginState> mapVerifyOtpToState(String contactPhone, String otpCode) async* {
    yield Loading(user: state.user, isValid: state.isValid);
    try {
      String firebaseToken = await PushNotificationsManager().getToken();
      String version = await _getVersion();

      var result = await _repository.verifyOtp(contactPhone, otpCode, firebaseToken, _getPlatform(), version);
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
        String firebaseToken = await PushNotificationsManager().getToken();
        String version = await _getVersion();

        User user = await _repository.checkTokenValid(token, firebaseToken, _getPlatform(), version);

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
      bool isLoggedOut = await _repository.removeData();
      if (isLoggedOut) {
        yield LoggedOut();
      }
    } catch (e) {}
  }

  Stream<LoginState> mapUpdateUserProfileToState(User user) async* {
    yield LoginState(
        isValid: state.isValid, user: state.user.copyWith(phone: user.phone, name: user.name, avatar: user.avatar));
  }

  Stream<LoginState> mapUpdatePrimaryContactToState(String contact) async* {
    yield LoginState(isValid: state.isValid, user: state.user.copyWith(phone: contact));
  }

  String _getPlatform() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "Ios";
    }
    return "";
  }

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Stream<LoginState> mapUpdateDefaultAddressToState(Address address) async* {
    yield LoginState(isValid: state.isValid, user: state.user.copyWith(defaultAddress: address));
  }
}
