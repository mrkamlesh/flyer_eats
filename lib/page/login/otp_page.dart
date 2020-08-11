import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/model/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/currentorder/current_order_event.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final Location location;
  final bool isShowContactConfirmationSheet;
  final String otpSignature;

  const OtpPage(
      {Key key, this.phoneNumber, this.location, this.isShowContactConfirmationSheet = false, this.otpSignature})
      : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with CodeAutoFill {
  TextEditingController _otpController;
  String otpCode = "";

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpController.addListener(() {
      setState(() {
        otpCode = _otpController.text;
      });
    });

    print(widget.otpSignature);

    listenForCode();
  }

  bool isValid() {
    return otpCode.length >= 6;
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code;
    });
    Future.delayed(Duration(milliseconds: 150));
    BlocProvider.of<LoginBloc>(context).add(VerifyOtp(widget.phoneNumber, _otpController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is Success) {
          BlocProvider.of<HomeBloc>(context).add(InitGetData(state.user.token, widget.location));
          BlocProvider.of<CurrentOrderBloc>(context).add(GetActiveOrder(state.user.token));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Home(
              contactNumber: widget.phoneNumber,
              isShowContactConfirmationSheet: widget.isShowContactConfirmationSheet,
            );
          }));
        } else if (state is Error) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    "Error",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          _otpController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: appLogoBackground),
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
                            AppUtil.getAppLogo(),
                            alignment: Alignment.center,
                            width: AppUtil.getScreenWidth(context) - 140,
                            height: 0.46 * (AppUtil.getScreenWidth(context) - 140),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                      padding:
                          EdgeInsets.only(top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20, top: 40),
                            child: Text(
                              "ENTER OTP",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                              controller: _otpController,
                              length: 6,
                              onChanged: (code) {},
                              textInputType: TextInputType.number,
                              autoFocus: true,
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldWidth:
                                      (AppUtil.getScreenWidth(context) - 50 - 2 * horizontalPaddingDraggable) / 6,
                                  fieldHeight:
                                      (AppUtil.getScreenWidth(context) - 50 - 2 * horizontalPaddingDraggable) / 6,
                                  selectedColor: primary2,
                                  borderRadius: BorderRadius.circular(8),
                                  inactiveColor: primary2),
                            ),
                          ),
                          GestureDetector(
                            onTap: isValid()
                                ? () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(VerifyOtp(widget.phoneNumber, _otpController.text));
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
                                    "SUBMIT",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: isValid() ? 0.0 : 0.5,
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
              state is Loading
                  ? Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
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
    );
  }
}
