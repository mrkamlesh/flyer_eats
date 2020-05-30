import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyereats/bloc/food/detail_page_bloc.dart';
import 'package:flyereats/bloc/food/food_repository.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/page/home.dart';

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
          BlocProvider<DetailPageBloc>(
            create: (context) {
              return DetailPageBloc(FoodRepository());
            },
          ),
          BlocProvider<LocationBloc>(
            create: (context) {
              return LocationBloc()..add(GetCurrentLocation());
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
            "/": (context) => Home(),
          },
        ));
  }
}
