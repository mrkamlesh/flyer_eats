import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/change_contact_verify_otp.dart';
import 'package:clients/page/select_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = EditProfileBloc();
    _nameController = TextEditingController(text: widget.user.name);
    _nameController.addListener(() {
      _bloc.add(UpdateName(_nameController.text));
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
        return _bloc
          ..add(InitProfile(Profile(
              name: widget.user.name,
              phone: widget.user.phone,
              location: Location(
                  location: widget.user.location,
                  address: widget.user.location),
              countryCode: widget.user.countryCode)));
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          return BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, editProfileState) async {
              if (editProfileState is SuccessUpdateProfile) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                BlocProvider.of<LoginBloc>(context)
                    .add(UpdateUserProfile(editProfileState.user));
              } else if (editProfileState is ErrorUpdateProfile) {
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
                        content: Text(
                          editProfileState.message,
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
              } else if (editProfileState is SuccessRequestOtpEditProfile) {
                bool result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ChangeContactVerifyOtp(
                    isChangePrimaryContact: false,
                    contact: editProfileState.newContact,
                    token: loginState.user.token,
                  );
                }));

                if (result != null) {
                  _bloc.add(UpdatePhone(editProfileState.newContact));
                }
              } else if (editProfileState is ErrorRequestOtpEditProfile) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Request OTP Failed",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(editProfileState.message),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    });
              }
            },
            builder: (context, editProfileState) {
              if (editProfileState is InitialEditProfileState) {
                return SizedBox();
              }
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
                      initialChildSize: (AppUtil.getScreenHeight(context) -
                              AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      minChildSize: (AppUtil.getScreenHeight(context) -
                              AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      maxChildSize: 1.0,
                      builder: (context, controller) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(
                              top: 20,
                              left: horizontalPaddingDraggable,
                              right: horizontalPaddingDraggable),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            child: editProfileState
                                                        .profile.avatar !=
                                                    null
                                                ? ClipOval(
                                                    child: FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.cover,
                                                        child: Image.file(
                                                            editProfileState
                                                                .profile
                                                                .avatar)),
                                                  )
                                                : loginState.user.avatar != null
                                                    ? ClipOval(
                                                        child: FittedBox(
                                                            alignment: Alignment
                                                                .center,
                                                            fit: BoxFit.cover,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  loginState
                                                                      .user
                                                                      .avatar,
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.fill,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              placeholder:
                                                                  (context,
                                                                      url) {
                                                                return Shimmer
                                                                    .fromColors(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              100,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        baseColor:
                                                                            Colors.grey[
                                                                                300],
                                                                        highlightColor:
                                                                            Colors.grey[100]);
                                                              },
                                                            )),
                                                      )
                                                    : FittedBox(
                                                        fit: BoxFit.none,
                                                        child: SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/account.svg",
                                                            color:
                                                                Colors.black38,
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
                                InkWell(
                                  onTap: _showChangeContactSheet,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      editProfileState.profile.phone,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                CustomTextField(
                                  controller: TextEditingController(
                                      text: widget.user.username),
                                  hint: "Your email here",
                                  lines: 1,
                                  isEnabled: false,
                                ),
                                InkWell(
                                  onTap: () async {
                                    Location location = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                      return SelectLocationPage(
                                        isRedirectToHomePage: false,
                                        initialCountryToLoad:
                                            loginState.user.countryCode,
                                      );
                                    }));

                                    if (location != null) {
                                      _bloc.add(UpdateLocation(
                                          location, location.country));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            editProfileState
                                                .profile.location.address,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: editProfileState.profile.isValid()
                                      ? () {
                                          _bloc.add(UpdateProfile(
                                              loginState.user.token));
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
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 30),
                                        child: Text(
                                          "UPDATE",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity:
                                            editProfileState.profile.isValid()
                                                ? 0.0
                                                : 0.5,
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 30),
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
                    editProfileState is LoadingUpdateProfile ||
                            editProfileState is LoadingRequestOtpEditProfile
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
                      PickedFile file = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
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

  void _showChangeContactSheet() {
    int _countrySelected = 0;
    String _contactPredicate = "+91";
    String _number;
    bool _isValid = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: AppUtil.getScreenWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: Colors.white),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "ENTER NUMBER",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable,
                          bottom: horizontalPaddingDraggable),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12, width: 2)),
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
                                                fontWeight: FontWeight.bold),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (i) {
                                state(() {
                                  _countrySelected = i;
                                  _contactPredicate = i == 0 ? "+91" : "+65";
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.black12, width: 2))),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      _contactPredicate == "+91" ? 10 : 8),
                                ],
                                onChanged: (value) {
                                  state(() {
                                    _number = value;
                                    _isValid = _contactPredicate == "+91"
                                        ? _number.length == 10 ? true : false
                                        : _number.length == 8 ? true : false;
                                  });
                                },
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _isValid
                          ? () {
                              _bloc.add(RequestOtpEditProfile(
                                  _contactPredicate + _number,
                                  widget.user.token));
                              Navigator.pop(context);
                            }
                          : () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 32),
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
                                "SELECT",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: _isValid ? 0.0 : 0.5,
                              child: Container(
                                height: 50,
                                color: Colors.white,
                              ),
                              duration: Duration(milliseconds: 300),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
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
