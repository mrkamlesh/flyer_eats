import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/login/checkphoneexist/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/login_facebook_gmail.dart';
import 'package:flyereats/page/login/otp_page.dart';

class LoginNumberPage extends StatefulWidget {
  @override
  _LoginNumberPageState createState() => _LoginNumberPageState();
}

class _LoginNumberPageState extends State<LoginNumberPage> {
  String _countrySelected = "+91";
  ScrollController _controller;
  TextEditingController _textEditingController;
  LoginPhoneBloc _bloc = LoginPhoneBloc();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 &&
        _controller.hasClients) {
      _controller.animateTo(30,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return BlocProvider<LoginPhoneBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocConsumer<LoginPhoneBloc, LoginPhoneState>(
        listener: (context, state) {
          if (state is SuccessCheckPhoneExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(phoneNumber: state.phoneNumber);
            }));
          } else if (state is ErrorCheckPhoneExist) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginFacebookGmail(phoneNumber: state.phoneNumber);
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
                                  margin: EdgeInsets.only(bottom: 20, top: 40),
                                  child: Text(
                                    "GET STARTED",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "Enter your 10 digit phone number to kick start",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black38),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: primary2,
                                            blurRadius: 10,
                                            spreadRadius: -4,
                                            offset: Offset(-4, 4))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: primary2, width: 2)),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DropdownButton<String>(
                                          underline: Container(),
                                          isExpanded: false,
                                          isDense: true,
                                          iconSize: 0,
                                          value: _countrySelected,
                                          items: [
                                            DropdownMenuItem(
                                              value: "+91",
                                              child: Container(
                                                width: 80,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        height: 20,
                                                        child: SvgPicture.asset(
                                                            "assets/india_flag.svg"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "+91",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "+65",
                                              child: Container(
                                                width: 80,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        height: 20,
                                                        child: SvgPicture.asset(
                                                            "assets/singapore_flag.svg"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "+65",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          onChanged: (i) {
                                            setState(() {
                                              _countrySelected = i;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: primary3,
                                                      width: 2))),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: TextField(
                                            autofocus: true,
                                            controller: _textEditingController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15),
                                              border: InputBorder.none,
                                              hintText: "Enter phone number",
                                              hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _bloc.add(CheckPhoneExist(_countrySelected +
                                        _textEditingController.text));
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
                                          "START",
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
                        ),
                      ],
                    ),
                  ),
                ),
                state is LoadingCheckPhoneExist
                    ? Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : IgnorePointer(child: Container()),
              ],
            ),
          );
        },
      ),
    );
  }
}
