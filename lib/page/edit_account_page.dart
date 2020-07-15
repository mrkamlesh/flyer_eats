import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/editprofile/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/user_profile.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class EditAccountPage extends StatefulWidget {
  final User user;

  const EditAccountPage({Key key, this.user}) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  EditProfileBloc _bloc;
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _bloc = EditProfileBloc();
    _nameController = TextEditingController(text: widget.user.name);
    _nameController.addListener(() {
      _bloc.add(UpdateName(_nameController.text));
    });
    _phoneController = TextEditingController(text: widget.user.phone);
    _phoneController.addListener(() {
      _bloc.add(UpdatePhone(_phoneController.text));
    });
    _passwordController = TextEditingController();
    _passwordController.addListener(() {
      _bloc.add(UpdatePassword(_passwordController.text));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (context) {
        return _bloc..add(InitProfile(Profile(name: widget.user.name, phone: widget.user.phone)));
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          return BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is SuccessUpdateProfile) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Success",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          "Your profile updated",
                          style: TextStyle(color: Colors.black54),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("OK")),
                        ],
                      );
                    },
                    barrierDismissible: false);
                BlocProvider.of<LoginBloc>(context).add(UpdateUserProfile(state.user));
              } else if (state is ErrorUpdateProfile) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Error",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          state.message,
                          style: TextStyle(color: Colors.black54),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK")),
                        ],
                      );
                    },
                    barrierDismissible: true);
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: AppUtil.getScreenWidth(context),
                          height: AppUtil.getBannerHeight(context),
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(
                                "assets/allrestaurant.png",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.black54),
                      width: AppUtil.getScreenWidth(context),
                      height: AppUtil.getBannerHeight(context),
                    ),
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: CustomAppBar(
                            leading: "assets/back.svg",
                            title: "Edit Profile",
                            onTapLeading: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      maxChildSize: 1.0,
                      builder: (context, controller) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(
                              top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
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
                                            child: state.profile.avatar != null
                                                ? ClipOval(
                                                    child: FittedBox(
                                                        alignment: Alignment.center,
                                                        fit: BoxFit.cover,
                                                        child: Image.file(state.profile.avatar)),
                                                  )
                                                : widget.user.avatar != null
                                                    ? ClipOval(
                                                        child: FittedBox(
                                                            alignment: Alignment.center,
                                                            fit: BoxFit.cover,
                                                            child: CachedNetworkImage(
                                                              imageUrl: widget.user.avatar,
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.fill,
                                                              alignment: Alignment.center,
                                                              placeholder: (context, url) {
                                                                return Shimmer.fromColors(
                                                                    child: Container(
                                                                      height: 100,
                                                                      width: 100,
                                                                      color: Colors.black,
                                                                    ),
                                                                    baseColor: Colors.grey[300],
                                                                    highlightColor: Colors.grey[100]);
                                                              },
                                                            )),
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
                                CustomTextField(
                                  hint: "Enter Your name here",
                                  lines: 1,
                                  controller: _nameController,
                                ),
                                CustomTextField(
                                  hint: "+91 12345678910",
                                  lines: 1,
                                  controller: _phoneController,
                                ),
                                CustomTextField(
                                  controller: TextEditingController(text: widget.user.username),
                                  hint: "Your email here",
                                  lines: 1,
                                  isEnabled: false,
                                ),
                                /*CustomTextField(
                                  hint: "Change your password here",
                                  lines: 1,
                                  margin: EdgeInsets.only(bottom: 5),
                                  controller: _passwordController,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: horizontalPaddingDraggable),
                                  child: Text(
                                    "*Leave password empty if you dont want to change it",
                                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                                  ),
                                ),*/
                                GestureDetector(
                                  onTap: state.profile.isValid()
                                      ? () {
                                          _bloc.add(UpdateProfile(loginState.user.token));
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
                                          "UPDATE",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: state.profile.isValid() ? 0.0 : 0.5,
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(top: 20, bottom: 30),
                                          color: Colors.white,
                                        ),
                                        duration: Duration(milliseconds: 300),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    state is LoadingUpdateProfile
                        ? Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                            child: Center(
                              child: SpinKitCircle(
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              );
            },
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
                        _bloc.add(UpdateImage(File(file.path)));
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
                        _bloc.add(UpdateImage(File(file.path)));
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

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Function(String) onChange;
  final EdgeInsets margin;
  final TextInputType type;
  final bool isEnabled;

  const CustomTextField(
      {Key key,
      this.hint,
      this.controller,
      this.lines,
      this.onChange,
      this.margin = const EdgeInsets.only(bottom: 20),
      this.type = TextInputType.text,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: lines,
        keyboardType: type,
        enabled: isEnabled,
        onChanged: (text) {
          onChange(text);
        },
        decoration: InputDecoration(
          hintText: hint != null ? hint : "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
