import 'dart:io';

import 'package:clients/model/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/register/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/login/otp_page.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final String name;
  final String imageUrl;

/*  email: widget.email,
  contactPhone: widget.phoneNumber,
  locationName: "TEST",
  fullName: _nameController.text,
  referralCode: "FE010421",
  devicePlatform: "android",
  appVersion: "4.0",
  countryCode: "IN",
  deviceId: "DASDASDA",
  avatar: _photo*/

  const RegisterPage({Key key, this.phoneNumber, this.email, this.name, this.imageUrl}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ScrollController _controller;
  TextEditingController _nameController;
  RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc();
    _controller = ScrollController();
    _nameController = TextEditingController(text: widget.name);
    _nameController.addListener(() {
      _bloc.add(ChangeName(_nameController.text));
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
      _controller.animateTo(MediaQuery.of(context).viewInsets.bottom,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return BlocProvider<RegisterBloc>(
      create: (context) {
        return _bloc
          ..add(InitRegisterEvent(
              email: widget.email, name: widget.name, imageUrl: widget.imageUrl, phoneNumber: widget.phoneNumber));
      },
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is SuccessRegister) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(
                otpSignature: state.otpSignature,
                phoneNumber: widget.phoneNumber,
                location: state.registerPost.location,
              );
            }));
          } else if (state is ErrorRegister) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Registration Error",
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
                  height: AppUtil.getScreenHeight(context),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: appLogoBackground),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AppUtil.getScreenHeight(context),
                  child: SingleChildScrollView(
                    controller: _controller,
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
                                  AppUtil.getAppLogo(),
                                  alignment: Alignment.center,
                                  width: AppUtil.getScreenWidth(context) - 140,
                                  height: 0.46 * (AppUtil.getScreenWidth(context) - 140),
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(
                              top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "DETAILS",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(12, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    _chooseImage();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle, border: Border.all(color: Colors.black12)),
                                          width: 100,
                                          height: 100,
                                          child: state.registerPost.avatar != null
                                              ? ClipOval(
                                                  child: FittedBox(
                                                      alignment: Alignment.center,
                                                      fit: BoxFit.cover,
                                                      child: Image.file(state.registerPost.avatar)),
                                                )
                                              : widget.imageUrl != null
                                                  ? ClipOval(
                                                      child: FittedBox(
                                                          alignment: Alignment.center,
                                                          fit: BoxFit.cover,
                                                          child: Image.network(widget.imageUrl)),
                                                    )
                                                  : FittedBox(
                                                      fit: BoxFit.none,
                                                      child: SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: SvgPicture.asset(
                                                          "assets/account.svg",
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.black38,
                                          size: 24,
                                        )
                                      ],
                                    ),
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
                                margin: EdgeInsets.only(bottom: 20),
                                child: TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: widget.email),
                                  decoration: InputDecoration(
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
                                margin: EdgeInsets.only(bottom: 20),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                                    border: InputBorder.none,
                                    hintText: "Your name here",
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
                                child: DropdownButton<Location>(
                                  underline: Container(),
                                  isExpanded: true,
                                  hint: Text("Select Your Location"),
                                  value: state.registerPost.location,
                                  icon: Icon(Icons.expand_more),
                                  items: state.listLocations
                                      .map<DropdownMenuItem<Location>>((value) => new DropdownMenuItem<Location>(
                                            value: value,
                                            child: Container(
                                              child: Text(
                                                value.address,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (i) {
                                    _bloc.add(ChangeLocation(i));
                                  },
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: state.registerPost.isUseReferral,
                                    onChanged: (value) {
                                      _bloc.add(ChangeIsUseReferral(value));
                                    },
                                    visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                                  ),
                                  Expanded(child: Text("Use Referral Code"))
                                ],
                              ),
                              state.registerPost.isUseReferral
                                  ? Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: EdgeInsets.only(top: 10),
                                      child: TextField(
                                        enabled: true,
                                        onChanged: (value) {
                                          _bloc.add(ChangeReferral(value));
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                                          border: InputBorder.none,
                                          hintText: "Enter referral code here",
                                          hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              GestureDetector(
                                onTap: state.registerPost.isValid()
                                    ? () {
                                        _bloc.add(Register());
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
                                      margin: EdgeInsets.only(top: 20, bottom: 30),
                                      child: Text(
                                        "CONFIRM",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: state.registerPost.isValid() ? 0.0 : 0.5,
                                      child: Container(
                                        height: 50,
                                        margin: EdgeInsets.only(top: 20, bottom: 30),
                                        color: Colors.white,
                                      ),
                                      duration: Duration(milliseconds: 300),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                (state is LoadingRegister || state is LoadingLocations)
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
      ),
    );
  }

  void _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 20);
                      if (file != null) {
                        _bloc.add(ChangeAvatar(File(file.path)));
                      }
                    },
                    splashColor: Colors.black12,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_camera,
                      ),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
                      if (file != null) {
                        _bloc.add(ChangeAvatar(File(file.path)));
                      }
                    },
                    splashColor: Colors.black12,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                      ),
                      title: Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
