import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/user_profile.dart';
import './bloc.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  DataRepository repository = DataRepository();

  @override
  EditProfileState get initialState => InitialEditProfileState();

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is InitProfile) {
      yield* mapInitProfileToState(event.profile);
    } else if (event is UpdateName) {
      yield* mapUpdateNameToState(event.name);
    } else if (event is UpdatePassword) {
      yield* mapUpdatePasswordToState(event.password);
    } else if (event is UpdatePhone) {
      yield* mapUpdatePhoneToState(event.phone);
    } else if (event is UpdateImage) {
      yield* mapUpdateImageToState(event.file);
    } else if (event is UpdateProfile) {
      yield* mapUpdateProfileToState(event.token);
    }
  }

  Stream<EditProfileState> mapInitProfileToState(Profile profile) async* {
    yield EditProfileState(profile: profile);
  }

  Stream<EditProfileState> mapUpdateNameToState(String name) async* {
    yield EditProfileState(profile: state.profile.copyWith(name: name));
  }

  Stream<EditProfileState> mapUpdatePasswordToState(String password) async* {
    yield EditProfileState(profile: state.profile.copyWith(password: password));
  }

  Stream<EditProfileState> mapUpdatePhoneToState(String phone) async* {
    yield EditProfileState(profile: state.profile.copyWith(phone: phone));
  }

  Stream<EditProfileState> mapUpdateImageToState(File file) async* {
    yield EditProfileState(profile: state.profile.copyWith(avatar: file));
  }

  Stream<EditProfileState> mapUpdateProfileToState(String token) async* {
    yield LoadingUpdateProfile(profile: state.profile);
    try {
      var result = await repository.saveProfile(token, state.profile);
      if (result is User) {
        yield SuccessUpdateProfile(result, profile: state.profile);
      } else {
        yield ErrorUpdateProfile("Fail to update profile", profile: state.profile);
      }
    } catch (e) {
      yield ErrorUpdateProfile(e.toString(), profile: state.profile);
    }
  }
}
