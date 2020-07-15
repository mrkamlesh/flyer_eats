import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/checkemailexist/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/login/otp_page.dart';
import 'package:clients/page/login/register_page.dart';

class LoginFacebookGmail extends StatefulWidget {
  final String phoneNumber;

  const LoginFacebookGmail({Key key, this.phoneNumber}) : super(key: key);

  @override
  _LoginFacebookGmailState createState() => _LoginFacebookGmailState();
}

class _LoginFacebookGmailState extends State<LoginFacebookGmail> {
  ScrollController _controller;
  TextEditingController _emailController;
  LoginEmailBloc _loginEmailBloc;

  @override
  void initState() {
    super.initState();
    _loginEmailBloc = LoginEmailBloc();
    _controller = ScrollController();
    _emailController = TextEditingController();
    _emailController.addListener(() {
      _loginEmailBloc.add(ChangeEmail(_emailController.text));
    });
  }

  @override
  void dispose() {
    _loginEmailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 &&
        _controller.hasClients) {
      _controller.animateTo(100,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginEmailBloc>(
          create: (context) {
            return _loginEmailBloc;
          },
        ),
      ],
      child: BlocConsumer<LoginEmailBloc, LoginEmailState>(
        listener: (context, state) {
          if (state is EmailIsExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(phoneNumber: widget.phoneNumber);
            }));
          } else if (state is EmailIsNotExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterPage(
                phoneNumber: widget.phoneNumber,
                email: state.email,
                imageUrl: state.avatar,
                name: state.name,
              );
            }));
          } else if (state is ErrorCheckEmailExist) {
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
                      mainAxisSize: MainAxisSize.min,
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
                                  height: 0.46 *
                                      (AppUtil.getScreenWidth(context) - 140),
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
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
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
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "OR",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                          child: SvgPicture.asset(
                                              "assets/facebook.svg"),
                                          onTap: () {
                                            _loginEmailBloc
                                                .add(LoginByFacebook());
                                          }),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            _loginEmailBloc.add(LoginByGmail());
                                          },
                                          child: SvgPicture.asset(
                                              "assets/gmail.svg")),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      state.email != null && state.email != ""
                                          ? () {
                                              _loginEmailBloc
                                                  .add(CheckEmailExist());
                                            }
                                          : () {},
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFB531),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "PROCEED",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: state.email != null &&
                                                state.email != ""
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
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<LoginEmailBloc, LoginEmailState>(
                  bloc: _loginEmailBloc,
                  builder: (context, state) {
                    if (state is LoadingCheckEmailExist) {
                      return Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
