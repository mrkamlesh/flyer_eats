import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/bloc/address/address_bloc.dart';
import 'package:clients/bloc/address/address_event.dart';
import 'package:clients/bloc/address/address_state.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/address.dart';
import 'package:clients/page/address_page.dart';

class DeliveryInformationWidget extends StatelessWidget {
  final Address address;
  final String distance;
  final List<Address> allAddresses;
  final AddressBloc bloc;

  const DeliveryInformationWidget(
      {Key key, this.address, this.distance, this.allAddresses, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: AppUtil.getScreenWidth(context),
        padding: EdgeInsets.symmetric(
            vertical: horizontalPaddingDraggable - 5,
            horizontal: horizontalPaddingDraggable),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.orange[100],
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, -1)),
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Delivery To"),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(address.title),
                ),
                Expanded(child: Container()),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, loginState) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<AddressBloc>(context)
                            .add(OpenListAddress(loginState.user.token));

                        showModalBottomSheet(
                            isScrollControlled: false,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32))),
                            context: context,
                            builder: (context) {
                              return BlocBuilder<AddressBloc, AddressState>(
                                bloc: bloc,
                                builder: (context, state) {
                                  if (state is ListAddressLoaded) {
                                    List<Address> list = state.list;
                                    List<Widget> address = [];
                                    for (int i = 0; i < list.length; i++) {
                                      address.add(AddressItemWidget(
                                        bloc: bloc,
                                        address: list[i],
                                      ));
                                    }

                                    return Stack(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom:
                                                    kBottomNavigationBarHeight,
                                                top: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(32)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 52),
                                                ),
                                                Column(
                                                  children: address,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: AppUtil.getScreenWidth(
                                                  context),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  32),
                                                          topRight:
                                                              Radius.circular(
                                                                  32)),
                                                  color: Colors.white),
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  left: 20,
                                                  bottom: 20),
                                              child: Text(
                                                "SELECT ADDRESS",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return AddressPage();
                                                }));
                                              },
                                              child: Container(
                                                width: AppUtil.getScreenWidth(
                                                    context),
                                                height:
                                                    kBottomNavigationBarHeight,
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
                                                          color: Colors.orange,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                            top: 5,
                                            right: 0,
                                            child: IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }))
                                      ],
                                    );
                                  } else if (state is LoadingListAddress) {
                                    return SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator());
                                  } else if (state is ErrorLoadingListAddress) {
                                    return Text("Fail load addresses");
                                  }
                                  return Container();
                                },
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        width: 60,
                        child: Text(
                          "Change",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Text(
                    /* "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100"*/
                    address.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    distance,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final AddressBloc bloc;

  const AddressItemWidget({Key key, this.address, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        break;
      case AddressType.office:
        type = "OFFICE";
        break;
      case AddressType.other:
        type = "OTHER";
        break;
      default:
        break;
    }
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: InkWell(
            onTap: () {
              bloc.add(OpenAddress(address.id, loginState.user.token));
              Navigator.pop(context);
            },
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15),
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
                                type,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                address.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              address.address,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black45),
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
      },
    );
  }
}
