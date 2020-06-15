import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/login/checkemailexist/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/otp_page.dart';
import 'package:flyereats/page/login/register_page.dart';

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
    _controller = ScrollController();
    _emailController = TextEditingController();
    _loginEmailBloc = LoginEmailBloc();
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
          if (state is SuccessCheckEmailExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(phoneNumber: widget.phoneNumber);
            }));
          } else if (state is ErrorCheckEmailExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterPage(phoneNumber: widget.phoneNumber);
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
                                      SvgPicture.asset("assets/facebook.svg"),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      SvgPicture.asset("assets/gmail.svg")
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _loginEmailBloc.add(
                                        CheckEmailExist(_emailController.text));
                                  },
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
                                        opacity: 0.0,
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
