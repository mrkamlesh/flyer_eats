import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyereats/bloc/currentorder/current_order_bloc.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/page/home.dart';
import 'package:flyereats/page/login/login_number_page.dart';
import 'package:flyereats/page/order_history_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/location/location_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    AppUtil.checkLocationServiceAndPermission();

    return MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            create: (context) {
              return LocationBloc();
            },
          ),
          BlocProvider<LoginBloc>(
            create: (context) {
              return LoginBloc()..add(InitLoginEvent());
            },
          ),
          BlocProvider<CurrentOrderBloc>(
            create: (context) {
              return CurrentOrderBloc();
            },
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => LoginNumberPage(),
            "/home": (context) => Home(),
            "/orderHistory": (context) => OrderHistoryPage(),
          },
        ));
  }
}
