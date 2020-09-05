import 'package:clients/bloc/login/bloc.dart';
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
import 'package:mapbox_gl/mapbox_gl.dart';

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

  MapboxMapController mapController;

  final double initLat = 28.620446;
  final double initLng = 77.227515;

  @override
  void initState() {
    super.initState();
    _bloc.add(PageOpen(widget.shop));
    nameController = TextEditingController(
        text: widget.shop != null
            ? widget.shop.name != null ? widget.shop.name : ""
            : "");
    addressController = TextEditingController(
        text: widget.shop != null
            ? widget.shop.description != null ? widget.shop.description : ""
            : "");
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
      return BlocProvider<ChooseShopBloc>(
        create: (context) {
          return _bloc;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height: AppUtil.getScreenHeight(context),
              width: AppUtil.getScreenWidth(context),
              child: Column(
                children: <Widget>[
                  Container(
                    height: AppUtil.getScreenHeight(context) * 0.55,
                    width: AppUtil.getScreenWidth(context),
                    child: Stack(
                      children: [
                        MapboxMap(
                          accessToken: loginState.user.mapBoxToken,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(initLat, initLng),
                            zoom: 13.0,
                          ),
                          trackCameraPosition: true,
                          compassEnabled: false,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          styleString: MapboxStyles.MAPBOX_STREETS,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          //myLocationEnabled: true,
                          /*myLocationTrackingMode:
                          mapBox.MyLocationTrackingMode.None,
                      myLocationRenderMode: mapBox.MyLocationRenderMode.GPS,*/
                          onMapClick: (point, latLng) async {
                            _bloc.add(UpdateLatLng(
                                latLng.latitude, latLng.longitude));
                            mapController.removeSymbols(mapController.symbols);
                            mapController.addSymbol(SymbolOptions(
                              geometry: latLng,
                              iconSize: 0.6,
                              iconImage: "assets/location.png",
                            ));
                          },
                        ),
                        Positioned(
                          bottom: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable,
                          child: Material(
                            elevation: 5,
                            child: IconButton(
                                icon: Icon(Icons.my_location_sharp),
                                onPressed: () {
                                  _bloc..add(PageOpen(Shop()));
                                }),
                          ),
                        ),
                        Positioned(
                          top: AppUtil.getToolbarHeight(context) / 2,
                          left: 0,
                          child: Material(
                            color: Colors.transparent,
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black45),
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
                                  decoration:
                                      BoxDecoration(color: Colors.black45),
                                  height: 30,
                                  child: Text(
                                    "Select Shop Location On the Map",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<ChooseShopBloc, ChooseShopState>(
                    listener: (context, state) {
                      if (state is ErrorState) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  "Choose Shop",
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
                      } else if (state is SuccessGetCurrentLocation) {
                        _animateCameraToPosition(LatLng(state.lat, state.lng));
                      }
                    },
                    builder: (context, state) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            width: AppUtil.getScreenWidth(context),
                            height: AppUtil.getScreenHeight(context) * 0.45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 0)
                                ]),
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPaddingDraggable,
                                vertical: distanceBetweenSection),
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
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable),
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      state.shop.address != null
                                          ? state.shop.address
                                          : "",
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
                                              Navigator.pop(
                                                  context, state.shop);
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
                                            child: Text(
                                              "Done",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          AnimatedOpacity(
                                            opacity: state.shop.isValid()
                                                ? 0.0
                                                : 0.5,
                                            child: Container(
                                              height: 50,
                                              color: Colors.white,
                                            ),
                                            duration:
                                                Duration(milliseconds: 300),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          state is LoadingState
                              ? LinearProgressIndicator()
                              : SizedBox(),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _animateCameraToPosition(LatLng latLng) async {
    if (mapController != null) {
      mapController.removeSymbols(mapController.symbols);
      mapController.addSymbol(SymbolOptions(
        geometry: latLng,
        iconSize: 0.6,
        iconImage: "assets/location.png",
      ));
      mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 13.0,
        ),
      ));
    }
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Function(String) onChange;

  CustomTextField(
      {Key key, this.hint, this.controller, this.lines, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
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
