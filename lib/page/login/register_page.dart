import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/login/otp_page.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {

  final String phoneNumber;

  const RegisterPage({Key key, this.phoneNumber}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File _photo;
  int _selectedLocation = 0;
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
      _controller.animateTo(MediaQuery.of(context).viewInsets.bottom,
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
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
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black12)),
                                      width: 100,
                                      height: 100,
                                      child: _photo != null
                                          ? ClipOval(
                                              child: FittedBox(
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover,
                                                  child: Image.file(_photo)),
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
                            child: DropdownButton<int>(
                              underline: Container(),
                              isExpanded: true,
                              value: _selectedLocation,
                              icon: Icon(Icons.expand_more),
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Container(
                                    width: 80,
                                    child: Text(
                                      "Pollachi",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Container(
                                    width: 80,
                                    child: Text(
                                      "Pollachi",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (i) {
                                setState(() {
                                  _selectedLocation = i;
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) {
                                    return OtpPage();
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
        ],
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
}
