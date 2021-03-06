import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clients/bloc/address/address_bloc.dart';
import 'package:clients/bloc/address/address_event.dart';
import 'package:clients/bloc/address/address_repository.dart';
import 'package:clients/bloc/address/address_state.dart';
import 'package:clients/bloc/login/login_bloc.dart';
import 'package:clients/bloc/login/login_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/address.dart';
import 'package:clients/page/edit_account_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';

import 'address_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AddressBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddressBloc(AddressRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<AddressBloc>(
          create: (context) {
            return _bloc..add(OpenListAddress(loginState.user.token));
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        width: AppUtil.getScreenWidth(context),
                        height: AppUtil.getBannerHeight(context),
                        padding: EdgeInsets.only(
                            top: AppUtil.getToolbarHeight(context),
                            bottom: AppUtil.getBannerOffset()),
                        color: Color(0xFFA4A4A4),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            if (state.user.avatar == null &&
                                state.user.avatar == "") {
                              return Center(
                                child: SvgPicture.asset(
                                  "assets/account.svg",
                                  color: Color(0xFFFFFFFF),
                                  height: AppUtil.getBannerHeight(context) -
                                      AppUtil.getToolbarHeight(context) -
                                      AppUtil.getBannerOffset() -
                                      20,
                                  width: AppUtil.getBannerHeight(context) -
                                      AppUtil.getToolbarHeight(context) -
                                      AppUtil.getBannerOffset() -
                                      20,
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  height: AppUtil.getBannerHeight(context) -
                                      AppUtil.getToolbarHeight(context) -
                                      AppUtil.getBannerOffset() -
                                      20,
                                  width: AppUtil.getBannerHeight(context) -
                                      AppUtil.getToolbarHeight(context) -
                                      AppUtil.getBannerOffset() -
                                      20,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: state.user.avatar,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      placeholder: (context, url) {
                                        return Shimmer.fromColors(
                                            child: Container(
                                              height: AppUtil.getBannerHeight(
                                                      context) -
                                                  AppUtil.getToolbarHeight(
                                                      context) -
                                                  AppUtil.getBannerOffset() -
                                                  20,
                                              width: AppUtil.getBannerHeight(
                                                      context) -
                                                  AppUtil.getToolbarHeight(
                                                      context) -
                                                  AppUtil.getBannerOffset() -
                                                  20,
                                              color: Colors.black,
                                            ),
                                            baseColor: Colors.grey[300],
                                            highlightColor: Colors.grey[100]);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: CustomAppBar(
                    backgroundColor: Colors.transparent,
                    leading: "assets/back.svg",
                    title: "Profile",
                    onTapLeading: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: AppUtil.getDraggableHeight(context) /
                      AppUtil.getScreenHeight(context),
                  minChildSize: AppUtil.getDraggableHeight(context) /
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
                            top: 40,
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return CustomScrollView(
                              controller: controller,
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        state.user.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return EditAccountPage(
                                              user: state.user,
                                            );
                                          }));
                                        },
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: primary3, fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: distanceSectionContent,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Text(
                                    state.user.phone,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black45),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: distanceSectionContent,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Text(
                                    state.user.username,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black45),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: distanceSectionContent,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Divider(
                                    height: 1.0,
                                    color: Colors.black12,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: distanceSectionContent,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: distanceSectionContent,
                                  ),
                                ),
                                BlocBuilder<AddressBloc, AddressState>(
                                    builder: (context, state) {
                                  if (state is ListAddressLoaded) {
                                    List<Address> list = state.list;
                                    List<Widget> address = [];
                                    for (int i = 0; i < list.length; i++) {
                                      address.add(AddressItemWidget(
                                        bloc: _bloc,
                                        address: list[i],
                                        token: loginState.user.token,
                                      ));
                                    }

                                    return SliverToBoxAdapter(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            address.isNotEmpty
                                                ? Column(
                                                    children: address,
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 50),
                                                    child: Center(
                                                        child: Text(
                                                            "No Address Available"))),
                                            GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return AddressPage();
                                                }));
                                                _bloc.add(OpenListAddress(
                                                    loginState.user.token));
                                              },
                                              child: Container(
                                                width: AppUtil.getScreenWidth(
                                                    context),
                                                height:
                                                    kBottomNavigationBarHeight,
                                                margin:
                                                    EdgeInsets.only(bottom: 30),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 20,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                    Text(
                                                      "ADD NEW ADDRESS",
                                                      style: TextStyle(
                                                          color: primary3,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (state is LoadingListAddress) {
                                    return SliverToBoxAdapter(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 50),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())));
                                  } else if (state is ErrorLoadingListAddress) {
                                    return SliverToBoxAdapter(
                                        child: Column(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(top: 50),
                                            child: Center(
                                                child: Text(
                                                    "Fail load addresses"))),
                                        GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return AddressPage();
                                            }));
                                            _bloc.add(OpenListAddress(
                                                loginState.user.token));
                                          },
                                          child: Container(
                                            width:
                                                AppUtil.getScreenWidth(context),
                                            height: kBottomNavigationBarHeight,
                                            margin: EdgeInsets.only(bottom: 30),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                Text(
                                                  "ADD NEW ADDRESS",
                                                  style: TextStyle(
                                                      color: primary3,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                                  }
                                  return SliverToBoxAdapter(child: Container());
                                })
                              ],
                            );
                          },
                        ));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final AddressBloc bloc;
  final String token;

  const AddressItemWidget({Key key, this.address, this.bloc, this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    String icon;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        icon = "assets/home address.svg";
        break;
      case AddressType.office:
        type = "OFFICE";
        icon = "assets/office address.svg";
        break;
      case AddressType.other:
        type = "OTHER";
        icon = "assets/others address.svg";
        break;
      default:
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          type,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          address.title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        address.address,
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 41,
              ),
              InkWell(
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return AddressPage(
                      address: address,
                    );
                  }));

                  bloc.add(OpenListAddress(token));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                        fontSize: 16,
                        color: primary3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text("DELETE?"),
                        content: Text("Delete ${address.title}?"),
                        actions: <Widget>[
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, loginState) {
                              return FlatButton(
                                  onPressed: () {
                                    bloc.add(RemoveAddress(
                                        address.id, loginState.user.token));
                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes"));
                            },
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No")),
                        ],
                      );
                    },
                    barrierDismissible: true,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                        fontSize: 16,
                        color: primary3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
