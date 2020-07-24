import 'package:clients/bloc/login/loginemail/bloc.dart';
import 'package:clients/page/login/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';

class LoginEmailPage extends StatefulWidget {
  final String email;
  final String phoneNumber;

  const LoginEmailPage({Key key, this.email, this.phoneNumber}) : super(key: key);

  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  ScrollController _controller;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  LoginEmailBloc _bloc = LoginEmailBloc();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();

    _passwordController.addListener(() {
      _bloc.add(UpdatePassword(_passwordController.text));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 && _controller.hasClients) {
      _controller.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return BlocProvider<LoginEmailBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocConsumer<LoginEmailBloc, LoginEmailState>(
        listener: (context, state) {
          if (state is ErrorState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Error",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(state.message),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"))
                    ],
                  );
                });
          } else if (state is SuccessState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(phoneNumber: widget.phoneNumber);
            }));
          }
        },
        builder: (context, state) {
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
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                            padding: EdgeInsets.only(
                                top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  child: Text(
                                    "DETAILS",
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      enabled: false,
                                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                      hintText: "Enter your email",
                                      hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
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
                                    autofocus: true,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: Container(
                                    width: AppUtil.getScreenWidth(context),
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Forgot Password",
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: state.password != null && state.password != ""
                                      ? () {
                                          _bloc.add(Login(widget.email, state.password));
                                        }
                                      : () {},
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFB531),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "PROCEED",
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      AnimatedOpacity(
                                        opacity:
                                            state.password != null && state.password != "" && !(state is LoadingState)
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
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<LoginEmailBloc, LoginEmailState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      );
                    }
                    return IgnorePointer(
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
          );
        },
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
