import 'dart:async';

import 'package:clients/bloc/pickup/chooseshop/choose_shop_bloc.dart';
import 'package:clients/bloc/pickup/chooseshop/choose_shop_event.dart';
import 'package:clients/bloc/pickup/chooseshop/choose_shop_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/shop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickShopLocationPage extends StatefulWidget {
  final Shop shop;

  const PickShopLocationPage({Key key, this.shop}) : super(key: key);

  @override
  _PickShopLocationPageState createState() => _PickShopLocationPageState();
}

class _PickShopLocationPageState extends State<PickShopLocationPage> {
  ChooseShopBloc _bloc = ChooseShopBloc();
  TextEditingController nameController;
  TextEditingController addressController;

  Completer<GoogleMapController> _controller = Completer();
  final double initLat = 28.620446;
  final double initLng = 77.227515;

  @override
  void initState() {
    super.initState();
    _bloc.add(PageOpen(widget.shop));
    nameController =
        TextEditingController(text: widget.shop != null ? widget.shop.name != null ? widget.shop.name : "" : "");
    addressController = TextEditingController(
        text: widget.shop != null ? widget.shop.description != null ? widget.shop.description : "" : "");
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChooseShopBloc>(
      create: (context) {
        return _bloc;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppUtil.getScreenHeight(context),
                width: AppUtil.getScreenWidth(context),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: AppUtil.getScreenHeight(context) * 0.55,
                      width: AppUtil.getScreenWidth(context),
                      child: BlocBuilder<ChooseShopBloc, ChooseShopState>(
                        builder: (context, state) {
                          Marker marker;
                          if (state.shop.long != null && state.shop.lat != null) {
                            marker = Marker(
                                markerId: MarkerId("location"),
                                position: LatLng(state.shop.lat, state.shop.long),
                                icon: BitmapDescriptor.defaultMarker);
                            _animateCameraToPosition(LatLng(state.shop.lat, state.shop.long));
                          }
                          return GoogleMap(
                            markers: Set.of((marker != null) ? [marker] : []),
                            mapType: MapType.normal,
                            onTap: (latLng) {
                              _bloc.add(UpdateLatLng(latLng));
                            },
                            zoomControlsEnabled: true,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomGesturesEnabled: true,
                            padding: EdgeInsets.only(bottom: 15, right: 15, top: 30, left: 15),
                            compassEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(initLat, initLng),
                              zoom: 15.5,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          );
                        },
                      ),
                    ),
                    BlocBuilder<ChooseShopBloc, ChooseShopState>(
                      builder: (context, state) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              width: AppUtil.getScreenWidth(context),
                              height: AppUtil.getScreenHeight(context) * 0.45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 0)]),
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingDraggable, vertical: distanceBetweenSection),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  CustomTextField(
                                    controller: nameController,
                                    hint: "ENTER SHOP",
                                    lines: 1,
                                    onChange: (text) {
                                      _bloc.add(EntryShopName(text));
                                    },
                                  ),
                                  CustomTextField(
                                    controller: addressController,
                                    lines: 1,
                                    hint: "Enter Shop Number, Building Name",
                                    onChange: (text) {
                                      _bloc.add(EntryDescription(text));
                                    },
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        state.shop.address != null ? state.shop.address : "",
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<ChooseShopBloc, ChooseShopState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: state.shop.isValid()
                                            ? () {
                                                Navigator.pop(context, state.shop);
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
                                              child: Text(
                                                "Done",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              opacity: state.shop.isValid() ? 0.0 : 0.5,
                                              child: Container(
                                                height: 50,
                                                color: Colors.white,
                                              ),
                                              duration: Duration(milliseconds: 300),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            state is LoadingState ? LinearProgressIndicator() : SizedBox(),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppUtil.getToolbarHeight(context) / 2,
              left: 0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                          "assets/back.svg",
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.black45),
                    height: 30,
                    child: Text(
                      "Select Shop Location On the Map",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _animateCameraToPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 15.5)));
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Function(String) onChange;

  CustomTextField({Key key, this.hint, this.controller, this.lines, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: lines,
        style: TextStyle(fontSize: 16),
        onChanged: (text) {
          onChange(text);
        },
        decoration: InputDecoration(
          hintText: hint != null ? hint : "",
          hintStyle: TextStyle(fontSize: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
