import 'package:clients/bloc/foodorder/changecontact/change_contact_bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ChangeContactVerifyOtp extends StatefulWidget {
  final bool isChangePrimaryContact;
  final String contact;
  final String token;

  const ChangeContactVerifyOtp(
      {Key key, this.isChangePrimaryContact, this.contact, this.token})
      : super(key: key);

  @override
  _ChangeContactVerifyOtpState createState() => _ChangeContactVerifyOtpState();
}

class _ChangeContactVerifyOtpState extends State<ChangeContactVerifyOtp>
    with CodeAutoFill {
  ChangeContactBloc _bloc = ChangeContactBloc();
  TextEditingController _otpController;

  @override
  void dispose() {
    _bloc.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangeContactBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocConsumer<ChangeContactBloc, ChangeContactState>(
        listener: (context, state) {
          if (state is ErrorChangeContact) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
          } else if (state is SuccessChangeContact) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Success",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text("Success Change Contact Number"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          child: Text("OK"))
                    ],
                  );
                });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              height: AppUtil.getScreenHeight(context),
              width: AppUtil.getScreenWidth(context),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: appLogoBackground),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: AppUtil.getScreenHeight(context),
                      width: AppUtil.getScreenWidth(context),
                      child: Column(
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
                                    width:
                                        AppUtil.getScreenWidth(context) - 140,
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
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 40),
                                    child: Text(
                                      "ENTER OTP",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Enter 6 digit OTP to verify the contact",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black38),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: PinCodeTextField(
                                      controller: _otpController,
                                      length: 6,
                                      onChanged: (code) {
                                        _bloc.add(ChangeOtpCode(code));
                                      },
                                      textInputType: TextInputType.number,
                                      autoFocus: true,
                                      pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          fieldWidth: (AppUtil
                                                      .getScreenWidth(context) -
                                                  50 -
                                                  2 *
                                                      horizontalPaddingDraggable) /
                                              6,
                                          fieldHeight: (AppUtil.getScreenWidth(
                                                      context) -
                                                  50 -
                                                  2 *
                                                      horizontalPaddingDraggable) /
                                              6,
                                          selectedColor: primary2,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          inactiveColor: primary2),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: state.isCodeValid() &&
                                            !(state is LoadingChangeContact)
                                        ? () {
                                            _bloc.add(VerifyOtpChangeContact(
                                                widget.contact,
                                                widget.isChangePrimaryContact,
                                                widget.token));
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
                                            "SUBMIT",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity:
                                              state.isCodeValid() ? 0.0 : 0.5,
                                          child: Container(
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(milliseconds: 300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  state is LoadingChangeContact
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5)),
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
            ),
          );
        },
      ),
    );
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code;
    });
    Future.delayed(Duration(milliseconds: 150));
    _bloc.add(VerifyOtpChangeContact(
        widget.contact, widget.isChangePrimaryContact, widget.token));
  }
}
