import 'package:flutter/material.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          Column(
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
                          "ENTER OTP",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Enter 6 digit OTP to kick start with us",
                          style: TextStyle(fontSize: 18, color: Colors.black38),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: PinCodeTextField(
                          length: 6,
                          onChanged: (code) {},
                          textInputType: TextInputType.number,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8), inactiveColor: primary2),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFB531),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "SUBMIT",
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
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
