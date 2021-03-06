import 'package:clients/model/user.dart';
import 'package:clients/model/user_profile.dart';

class EditProfileState {
  final Profile profile;

  EditProfileState({this.profile});
}

class InitialEditProfileState extends EditProfileState {
  InitialEditProfileState() : super();
}

class LoadingUpdateProfile extends EditProfileState {
  LoadingUpdateProfile({Profile profile}) : super(profile: profile);
}

class SuccessUpdateProfile extends EditProfileState {
  final User user;

  SuccessUpdateProfile(this.user, {Profile profile}) : super(profile: profile);
}

class ErrorUpdateProfile extends EditProfileState {
  final String message;

  ErrorUpdateProfile(this.message, {Profile profile}) : super(profile: profile);
}

class LoadingRequestOtpEditProfile extends EditProfileState {
  LoadingRequestOtpEditProfile({Profile profile}) : super(profile: profile);
}

class SuccessRequestOtpEditProfile extends EditProfileState {
  final String newContact;

  SuccessRequestOtpEditProfile(this.newContact, {Profile profile})
      : super(profile: profile);
}

class ErrorRequestOtpEditProfile extends EditProfileState {
  final String message;

  ErrorRequestOtpEditProfile(this.message, {Profile profile})
      : super(profile: profile);
}
