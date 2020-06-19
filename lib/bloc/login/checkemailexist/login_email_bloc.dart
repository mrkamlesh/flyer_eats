import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/login_status.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginEmailBloc extends Bloc<LoginEmailEvent, LoginEmailState> {
  DataRepository repository = DataRepository();

  @override
  LoginEmailState get initialState => InitialLoginEmailState();

  @override
  Stream<LoginEmailState> mapEventToState(
    LoginEmailEvent event,
  ) async* {
    if (event is CheckEmailExist) {
      yield* mapCheckEmailExistToState();
    } else if (event is LoginByFacebook) {
      yield* mapLoginByFacebookToState();
    } else if (event is CheckSocialMediaProfile) {
      yield* mapCheckFacebookProfileToState(
          event.email, event.name, event.avatar);
    } else if (event is LoginByGmail) {
      yield* mapLoginByGmailToState();
    } else if (event is ChangeEmail) {
      yield* mapChangeEmailToState(event.email);
    }
  }

  Stream<LoginEmailState> mapCheckEmailExistToState() async* {
    yield LoadingCheckEmailExist(state.email);

    try {
      LoginStatus status = await repository.checkEmailExist(state.email);
      if (status.status) {
        yield EmailIsExist(state.email);
      } else {
        yield EmailIsNotExist(email: state.email);
      }
    } catch (e) {
      yield ErrorCheckEmailExist(e.toString());
    }
  }

  Stream<LoginEmailState> mapLoginByFacebookToState() async* {
    yield LoadingCheckEmailExist(state.email);
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          facebookLogin.logOut(); //d;sakd;askd;askd;askddasdsadsa Ini Aneh!!
          final token = result.accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,picture.width(300).height(300),email&access_token=$token');
          final profile = JSON.jsonDecode(graphResponse.body);
          add(CheckSocialMediaProfile(
              email: profile['email'],
              avatar: profile['picture']['data']['url'],
              name: profile['name']));
          break;
        case FacebookLoginStatus.cancelledByUser:
          yield LoginEmailState(email: state.email);
          break;
        case FacebookLoginStatus.error:
          yield ErrorCheckEmailExist(result.errorMessage);
          break;
      }
    } catch (e) {
      yield ErrorCheckEmailExist(e.toString());
    }
  }

  Stream<LoginEmailState> mapCheckFacebookProfileToState(
      String email, String name, String avatar) async* {
    yield LoadingCheckEmailExist(state.email);
    try {
      LoginStatus status = await repository.checkEmailExist(email);
      if (status.status) {
        yield EmailIsExist(email);
      } else {
        yield EmailIsNotExist(email: email, avatar: avatar, name: name);
      }
    } catch (e) {
      yield ErrorCheckEmailExist(e.toString());
    }
  }

  Stream<LoginEmailState> mapLoginByGmailToState() async* {
    yield LoadingCheckEmailExist(state.email);

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); //dsjadkjasdas;dlkasdl sdkasd a;kda  a Ini Aneh!!!
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      add(CheckSocialMediaProfile(
          name: googleSignInAccount.displayName,
          avatar: googleSignInAccount.photoUrl,
          email: googleSignInAccount.email));
    } catch (e) {
      yield ErrorCheckEmailExist(e.toString());
    }
  }

  Stream<LoginEmailState> mapChangeEmailToState(String email) async* {
    yield LoginEmailState(email: email);
  }
}
