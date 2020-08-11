import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clients/model/location.dart';
import 'package:device_info/device_info.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/login_status.dart';
import 'package:clients/model/register_post.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms_autofill/sms_autofill.dart';
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
      String otpSignature = await SmsAutoFill().getAppSignature;
      LoginStatus status = await repository.register(state.registerPost, otpSignature);
      if (status.status) {
        yield SuccessRegister(status, otpSignature,
            listLocations: state.listLocations, registerPost: state.registerPost);
      } else {
        yield ErrorRegister(status.message, listLocations: state.listLocations, registerPost: state.registerPost);
      }
    } catch (e) {
      yield ErrorRegister(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
    }
  }

  Stream<RegisterState> mapInitRegisterEventToState(InitRegisterEvent event) async* {
    yield LoadingLocations(listLocations: state.listLocations, registerPost: state.registerPost);

    try {
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

      List<Location> list = List();
      Location predefinedLocationByCurrentLocation;

      try {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
            .timeout(Duration(seconds: 5), onTimeout: () {
          return null;
        });

        list = await repository.getLocations(event.phoneNumber.substring(0, 3) == "+91" ? "101" : "196");

        Location result;
        if (position != null) {
          result = await repository.getPredefinedLocationByLatLng(position.latitude, position.longitude);
        }

        if (result != null) {
          predefinedLocationByCurrentLocation = _getSelectedPredefinedLocation(result, list);
        }
      } catch (e) {
        yield ErrorLocations(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
      }

      RegisterPost registerPost = RegisterPost(
          imageUrl: event.imageUrl,
          name: event.name,
          email: event.email,
          contactPhone: event.phoneNumber,
          countryId: event.phoneNumber.substring(0, 3) == "+91" ? "IN" : "SG",
          devicePlatform: devicePlatform,
          deviceId: deviceId,
          appVersion: "5.0",
          referral: "",
          isUseReferral: false,
          location: predefinedLocationByCurrentLocation);

      yield RegisterState(listLocations: list, registerPost: registerPost);
    } catch (e) {
      yield ErrorLocations(e.toString(), listLocations: state.listLocations, registerPost: state.registerPost);
    }
  }

  Stream<RegisterState> mapChangeNameToState(String name) async* {
    yield RegisterState(listLocations: state.listLocations, registerPost: state.registerPost.copyWith(name: name));
  }

  Stream<RegisterState> mapChangeLocationToState(Location location) async* {
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

  Location _getSelectedPredefinedLocation(Location result, List<Location> list) {
    for (int i = 0; i < list.length; i++) {
      if (result.address == list[i].address) {
        return list[i];
      }
    }
    return null;
  }
}
