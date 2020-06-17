import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/login/register/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/otp_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;

class RegisterPage extends StatefulWidget {
  final String email;
  final String phoneNumber;

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

  const RegisterPage({Key key, this.phoneNumber, this.email}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File _photo;
  String _selectedLocation;
  ScrollController _controller;
  TextEditingController _nameController;
  RegisterBloc _bloc = RegisterBloc();
  String _countryId = "IN";
  String _appVersion = "5.0";
  String _devicePlatform;
  String _deviceId = "";

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _nameController = TextEditingController();

    initRegisterInfo();
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
      _controller.animateTo(MediaQuery.of(context).viewInsets.bottom,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return BlocProvider<RegisterBloc>(
      create: (context) {
        return _bloc..add(GetLocations());
      },
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is SuccessRegister) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OtpPage(phoneNumber: widget.phoneNumber);
            }));
          } else if (state is ErrorRegister) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "DETAILS",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black12)),
                                            width: 100,
                                            height: 100,
                                            child: _photo != null
                                                ? ClipOval(
                                                    child: FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.cover,
                                                        child:
                                                            Image.file(_photo)),
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
                                    controller: TextEditingController(
                                        text: widget.email),
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
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                      hintText: "Your name here",
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
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: DropdownButton<String>(
                                    underline: Container(),
                                    isExpanded: true,
                                    hint: Text("Select Your Location"),
                                    value: _selectedLocation,
                                    icon: Icon(Icons.expand_more),
                                    items: state.listLocations
                                        .map<DropdownMenuItem<String>>(
                                            (value) =>
                                                new DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ))
                                        .toList(),
                                    onChanged: (i) {
                                      setState(() {
                                        _selectedLocation = i;
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _bloc.add(Register(
                                        email: widget.email,
                                        contactPhone: widget.phoneNumber,
                                        locationName: _selectedLocation,
                                        fullName: _nameController.text,
                                        referralCode: "FE010421",
                                        devicePlatform: _devicePlatform,
                                        appVersion: "5.0",
                                        countryCode: _countryId,
                                        deviceId: _deviceId,
                                        avatar: _photo));
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
                                          "CONFIRM",
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
                (state is LoadingRegister || state is LoadingLocations)
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

  void _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker().getImage(
                          source: ImageSource.camera, imageQuality: 20);
                      if (file != null) {
                        setState(() {
                          _photo = File(file.path);
                        });
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
                      PickedFile file = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (file != null) {
                        setState(() {
                          _photo = File(file.path);
                        });
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

  Future<void> initRegisterInfo() async {
    if (widget.phoneNumber.substring(0, 2) == "+95") {
      _countryId = "IN";
    } else {
      _countryId = "SG";
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      _devicePlatform = "Android";
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      _devicePlatform = "IOs";
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    } else {
      _devicePlatform = "Other";
      _deviceId = "Device ID Other Platform";
    }

    if (_photo == null){
      String dir = (await getApplicationDocumentsDirectory()).path;
      _photo = new File('$dir/$filename');
    }
  }
}
