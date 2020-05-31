import 'package:flutter/material.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/register_page.dart';

class LoginEmailPage extends StatefulWidget {
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) {
                                    return RegisterPage();
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
        ],
      ),
    );
  }
}
