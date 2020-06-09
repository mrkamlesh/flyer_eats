import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flyereats/bloc/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/home.dart';

class LoginEmailPage extends StatefulWidget {
  final String email;

  const LoginEmailPage({Key key, this.email}) : super(key: key);

  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  ScrollController _controller;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();

    _emailController.addListener(() {
      BlocProvider.of<LoginBloc>(context).add(ValidateInput(
          _emailController.text.toString(),
          _passwordController.text.toString()));
    });

    _passwordController.addListener(() {
      BlocProvider.of<LoginBloc>(context).add(ValidateInput(
          _emailController.text.toString(),
          _passwordController.text.toString()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 &&
        _controller.hasClients) {
      _controller.animateTo(100,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          SingleChildScrollView(
            controller: _controller,
            child: Container(
              height: AppUtil.getScreenHeight(context),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 50),
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.asset(
                            "assets/flyereatslogo.png",
                            alignment: Alignment.center,
                            width: AppUtil.getScreenWidth(context) - 140,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32),
                              topLeft: Radius.circular(32))),
                      padding: EdgeInsets.only(
                          top: 20,
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Text(
                              "DETAILS",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextField(
                              autofocus: true,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: "Enter your email",
                                hintStyle: TextStyle(
                                    fontSize: 16, color: Colors.black38),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    fontSize: 16, color: Colors.black38),
                              ),
                            ),
                          ),
                          Container(
                            width: AppUtil.getScreenWidth(context),
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Forgot Password",
                            ),
                          ),
                          BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is Success) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Login Success",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                            "You have been logged in succesfully"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return Home();
                                                }));
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                              } else if (state is Error) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Error!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(state.error),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  if (!(state is Loading) && state.isValid) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        LoginEventWithEmail(
                                            _emailController.text.toString(),
                                            _passwordController.text
                                                .toString()));
                                  }
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFB531),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: !(state is Loading)
                                          ? Text(
                                              "PROCEED",
                                              style: TextStyle(fontSize: 20),
                                            )
                                          : SpinKitCircle(
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                    ),
                                    AnimatedOpacity(
                                      opacity:
                                          !(state is Loading) && state.isValid
                                              ? 0.0
                                              : 0.5,
                                      child: Container(
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(milliseconds: 300),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Animal {
  final String name;

  Animal({this.name});
}

class Cat extends Animal {
  Cat({String name}) : super(name: name);
}
