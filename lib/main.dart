import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/bloc/login/login_bloc.dart';
import 'package:flyereats/bloc/login/login_event.dart';
import 'package:flyereats/page/home.dart';
import 'package:flyereats/page/login/login_facebook_gmail.dart';

import 'bloc/location/location_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            create: (context) {
              return LocationBloc()..add(GetCurrentLocation());
            },
          ),
          BlocProvider<LoginBloc>(
            create: (context) {
              return LoginBloc()..add(InitLoginEvent());
            },
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => LoginFacebookGmail(),
            "/home": (context) => Home(),
          },
        ));
  }
}
