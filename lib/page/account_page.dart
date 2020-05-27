import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyereats/bloc/address/address_bloc.dart';
import 'package:flyereats/bloc/address/address_event.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/address_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/widget/app_bar.dart';

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
    _bloc = AddressBloc(AddressRepository())..add(OpenListAddress());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
      create: (context) {
        return _bloc;
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
                    color: Color(0xFF777777),
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: SvgPicture.asset(
                        "assets/account.svg",
                        color: Color(0xFFFFFFFF),
                        height: 150,
                        width: 150,
                      ),
                    )),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                leading: "assets/back.svg",
                title: "Profile",
                onTapLeading: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.transparent,
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
                      bottom: 32,
                      left: horizontalPaddingDraggable,
                      right: horizontalPaddingDraggable),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Saravanan Nagarajan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(color: primary3, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(
                        height: distanceSectionContent,
                      ),
                      Text(
                        "9620077525",
                        style: TextStyle(fontSize: 18, color: Colors.black45),
                      ),
                      SizedBox(
                        height: distanceSectionContent,
                      ),
                      Text(
                        "sara@gmail.com",
                        style: TextStyle(fontSize: 18, color: Colors.black45),
                      ),
                      SizedBox(
                        height: distanceSectionContent,
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        height: distanceSectionContent,
                      ),
                      Text(
                        "Address",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: distanceSectionContent,
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
                            ));
                          }
                          return Stack(
                            children: <Widget>[
                              SingleChildScrollView(
                                controller: controller,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: address,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddressPage();
                                          }));
                                        },
                                        child: Container(
                                          width:
                                              AppUtil.getScreenWidth(context),
                                          height: kBottomNavigationBarHeight,
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
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              Text(
                                                "ADD NEW ADDRESS",
                                                style: TextStyle(
                                                    color: Colors.orange,
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
                              ),
                            ],
                          );
                        } else if (state is LoadingListAddress) {
                          return CircularProgressIndicator();
                        } else if (state is ErrorLoadingListAddress) {
                          return Text("Fail load addresses");
                        }
                        return Container();
                      })
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final AddressBloc bloc;

  const AddressItemWidget({Key key, this.address, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          bloc.add(OpenAddress(address.id));
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.home,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
            Divider(
              height: 1,
              color: Colors.black12,
            )
          ],
        ),
      ),
    );
  }
}
