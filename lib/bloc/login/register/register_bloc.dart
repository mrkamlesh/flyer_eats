import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
import 'package:clients/model/register_post.dart';
import 'dart:io' show Platform;
import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  DataRepository repository = DataRepository();

  @override
  RegisterState get initialState => InitialRegisterState();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      yield* mapRegisterToState();
    } else if (event is InitRegisterEvent) {
      yield* mapInitRegisterEventToState(event);
    } else if (event is ChangeName) {
      yield* mapChangeNameToState(event.name);
    } else if (event is ChangeLocation) {
      yield* mapChangeLocationToState(event.location);
    } else if (event is ChangeAvatar) {
      yield* mapChangeAvatarToState(event.file);
    } else if (event is ChangeReferral) {
      yield* mapChangeReferralToState(event.referral);
    } else if (event is ChangeIsUseReferral) {
      yield* mapChangeIsUseReferralToState(event.isUseReferral);
    }
  }

  Stream<RegisterState> mapRegisterToState() async* {
    yield LoadingRegister(listLocations: state.listLocations, registerPost: state.registerPost);

    try {
      LoginStatus status = await repository.register(state.registerPost);
      if (status.status) {
        yield SuccessRegister(status, listLocations: state.listLocations, registerPost: state.registerPost);
      } else {
        yield ErrorRegister(status.message, listLocations: state.listLocations, registerPost: state.registerPost);
      }
    } catch (e) {
      yield ErrorRegister(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
    }
  }

  Stream<RegisterState> mapInitRegisterEventToState(InitRegisterEvent event) async* {
    yield LoadingLocations(listLocations: state.listLocations, registerPost: state.registerPost);

    String devicePlatform = "";
    String deviceId = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      devicePlatform = "Android";
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      devicePlatform = "IOs";
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else {
      devicePlatform = "Other";
      deviceId = "Device ID Other Platform";
    }

    try {
      RegisterPost registerPost = RegisterPost(
        imageUrl: event.imageUrl,
        name: event.name,
        email: event.email,
        contactPhone: event.phoneNumber,
        countryId: event.phoneNumber.substring(0, 2) == "+91" ? "IN" : "SG",
        devicePlatform: devicePlatform,
        deviceId: deviceId,
        appVersion: "5.0",
        referral: "",
        isUseReferral: false,
      );

      List<String> list = List();
      try {
        list = await repository.getRegisterLocations();
      } catch (e) {
        yield ErrorLocations(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
      }

      yield RegisterState(listLocations: list, registerPost: registerPost);
    } catch (e) {
      yield ErrorLocations(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
    }
  }

  Stream<RegisterState> mapChangeNameToState(String name) async* {
    yield RegisterState(listLocations: state.listLocations, registerPost: state.registerPost.copyWith(name: name));
  }

  Stream<RegisterState> mapChangeLocationToState(String location) async* {
    yield RegisterState(
        listLocations: state.listLocations, registerPost: state.registerPost.copyWith(location: location));
  }

  Stream<RegisterState> mapChangeAvatarToState(File file) async* {
    yield RegisterState(listLocations: state.listLocations, registerPost: state.registerPost.copyWith(avatar: file));
  }

  Stream<RegisterState> mapChangeReferralToState(String referral) async* {
    yield RegisterState(
        listLocations: state.listLocations, registerPost: state.registerPost.copyWith(referral: referral));
  }

  Stream<RegisterState> mapChangeIsUseReferralToState(bool isUseReferral) async* {
    yield RegisterState(
        listLocations: state.listLocations, registerPost: state.registerPost.copyWith(isUseReferral: isUseReferral));
  }
}
