import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/address/address_bloc.dart';
import 'package:flyereats/bloc/address/address_event.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/address_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/pickup.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/widget/delivery_information_widget.dart';
import 'package:flyereats/widget/place_order_bottom_navbar.dart';

class DeliveryPlaceOderPage extends StatefulWidget {
  final PickUp pickUp;

  const DeliveryPlaceOderPage({Key key, this.pickUp}) : super(key: key);

  @override
  _DeliveryPlaceOderPageState createState() => _DeliveryPlaceOderPageState();
}

class _DeliveryPlaceOderPageState extends State<DeliveryPlaceOderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  AddressBloc _bloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    widget.pickUp.items.removeWhere((item) {
      return item == "" || item == null;
    });

    _bloc = AddressBloc(AddressRepository())..add(InitDefaultAddress());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: AnimatedBuilder(
          animation: _navBarAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: _navBarAnimation.value,
              child: child,
            );
          },
          child: PlaceOrderBar(
            placeOrder: () {},
            amount: 50,
          )),
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
                      "assets/pickup.png",
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
                  drawer: "assets/drawer.svg",
                  title: "Pickup & Drop",
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
                    left: horizontalPaddingDraggable,
                    right: horizontalPaddingDraggable,
                    top: 20),
                child: CustomScrollView(
                  controller: controller,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                "assets/locationpick.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        widget.pickUp.shop.name,
                                        style: TextStyle(fontSize: 16),
                                      )),
                                  Text(
                                    widget.pickUp.shop.address,
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                "assets/additems.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        "ADD ITEMS",
                                        style: TextStyle(fontSize: 16),
                                      )),
                                  Column(
                                    children: List.generate(
                                        widget.pickUp.items.length, (index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          widget.pickUp.items[index],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                "assets/attachment.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "ATTACHMENTS",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                widget.pickUp.attachment.length != 0
                                    ? Column(
                                        children: List.generate(
                                            widget.pickUp.attachment.length,
                                            (index) {
                                          return Container(
                                            width: AppUtil.getScreenWidth(
                                                    context) -
                                                80,
                                            height: 60,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                ImageThumbnail(
                                                    0,
                                                    widget.pickUp
                                                        .attachment[index])
                                              ],
                                            ),
                                          );
                                        }),
                                      )
                                    : Container(
                                        child: Text(
                                          "No Attachment",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                "assets/distance.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "DISTANCE",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: AppUtil.getScreenWidth(context) - 80,
                                  child: Text(
                                    "7 Kilometers",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //PickupInformationWidget()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: PickupInformationWidget(),
                    )
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: BlocProvider<AddressBloc>(
                create: (context) {
                  return _bloc;
                },
                child: Column(
                  children: <Widget>[
                    BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return Container();
                        } else if (state is AddressLoaded) {
                          return DeliveryInformationWidget(
                            address: state.address,
                            distance: "30 Min",
                            allAddresses: ExampleModel.getAddresses(),
                          );
                        }
                        return Text("Fail");
                      },
                    ),
                    OrderBottomNavBar(
                      isValid: true,
                      description: "Delivery Amount",
                      amount: 110,
                      showRupee: true,
                      buttonText: "PLACE ORDER",
                      onButtonTap: () {},
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class PickupInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
          child: Text(
            "Upto 8 kg allowed",
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class PlaceOrderBar extends StatelessWidget {
  final int amount;
  final Function placeOrder;

  const PlaceOrderBar({Key key, this.amount, this.placeOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: AppUtil.getScreenWidth(context),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.yellow[600]))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Delivery Amount",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/rupee.svg",
                      width: 13,
                      height: 13,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "$amount",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
            onTap: placeOrder,
            child: SizedBox.expand(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(18))),
                child: Text(
                  "PLACE ORDER",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class ImageThumbnail extends StatelessWidget {
  final int index;
  final File file;

  ImageThumbnail(this.index, this.file);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
