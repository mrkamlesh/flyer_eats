import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/location/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/page/home.dart';
import 'package:clients/page/login/login_number_page.dart';
import 'package:clients/page/order_history_page.dart';
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

    return MultiBlocProvider(providers: [
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
    ], child: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginNumberPage(),
        "/home": (context) => Home(),
        "/orderHistory": (context) => OrderHistoryPage(),
      },
    );
  }
}
