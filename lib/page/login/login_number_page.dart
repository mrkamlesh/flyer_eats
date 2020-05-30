import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/login_facebook_gmail.dart';

class LoginNumberPage extends StatefulWidget {
  @override
  _LoginNumberPageState createState() => _LoginNumberPageState();
}

class _LoginNumberPageState extends State<LoginNumberPage> {
  int _countrySelected = 0;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 && _controller.hasClients) {
      _controller.animateTo(30,
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
                            margin: EdgeInsets.only(bottom: 20, top: 40),
                            child: Text(
                              "GET STARTED",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
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
                                border: Border.all(color: primary2, width: 2)),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: DropdownButton<int>(
                                    underline: Container(),
                                    isExpanded: false,
                                    isDense: true,
                                    iconSize: 0,
                                    value: _countrySelected,
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Container(
                                          width: 80,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 1,
                                        child: Container(
                                          width: 80,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                                          FontWeight.bold),
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
                                                color: primary3, width: 2))),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: TextField(
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 15),
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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) {
                                return LoginFacebookGmail();
                              }));
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
        ],
      ),
    );
  }
}
