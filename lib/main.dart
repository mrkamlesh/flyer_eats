import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyereats/bloc/food/detail_page_bloc.dart';
import 'package:flyereats/bloc/food/food_repository.dart';
import 'package:flyereats/page/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<DetailPageBloc>(
          create: (context) {
            return DetailPageBloc(FoodRepository());
          },
          child: Home()),
    );
  }
}
