import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/currentorder/bloc.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/status_order.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapBox;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({Key key}) : super(key: key);

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final double initLat = 28.620446;
  final double initLng = 77.227515;

  mapBox.MapboxMapController mapBoxController;
  Completer<GoogleMapController> googleMapsController = Completer();
  Marker driverMarker;
  Marker userMarker;
  BitmapDescriptor driverLocationIcon;
  BitmapDescriptor userLocationIcon;

  @override
  void initState() {
    super.initState();
    setPinIcon();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocConsumer<CurrentOrderBloc, CurrentOrderState>(
          listener: (context, state) {
            if (state is SuccessState) {
              if (state.currentOrder.driverLatitude != null &&
                  state.currentOrder.driverLongitude != null) {
                if (!(loginState.user.isGoogleMapsUsed())) {
                  _animateMapBoxCameraToBounds(
                      mapBox.LatLng(state.currentOrder.driverLatitude,
                          state.currentOrder.driverLongitude),
                      mapBox.LatLng(state.currentOrder.deliveryLatitude,
                          state.currentOrder.deliveryLongitude));
                } else {
                  if (state.currentOrder.driverLatitude != null &&
                      state.currentOrder.driverLongitude != null) {
                    driverMarker = Marker(
                        markerId: MarkerId("driver"),
                        position: LatLng(state.currentOrder.driverLatitude,
                            state.currentOrder.driverLongitude),
                        icon: driverLocationIcon);
                    userMarker = Marker(
                        markerId: MarkerId("delivery"),
                        position: LatLng(state.currentOrder.deliveryLatitude,
                            state.currentOrder.deliveryLongitude),
                        icon: userLocationIcon);

                    _animateGoogleMapCameraToBounds(getGoogleMapsCameraBounds(
                        state.currentOrder.driverLatitude,
                        state.currentOrder.driverLongitude,
                        state.currentOrder.deliveryLatitude,
                        state.currentOrder.deliveryLongitude));
                  }
                }
              }
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
                        child: loginState.user.isGoogleMapsUsed()
                            ? GoogleMap(
                                markers: Set.of(
                                    (driverMarker != null && userMarker != null)
                                        ? [driverMarker, userMarker]
                                        : []),
                                mapType: MapType.normal,
                                zoomControlsEnabled: true,
                                zoomGesturesEnabled: true,
                                compassEnabled: true,
                                onMapCreated: (GoogleMapController controller) {
                                  googleMapsController.complete(controller);
                                },
                                initialCameraPosition: CameraPosition(
                                  target: getInitialGoogleMapCameraPosition(
                                      state.currentOrder.driverLatitude,
                                      state.currentOrder.driverLongitude,
                                      state.currentOrder.deliveryLatitude,
                                      state.currentOrder.deliveryLongitude),
                                  zoom: 15.5,
                                ),
                              )
                            : mapBox.MapboxMap(
                                accessToken: loginState.user.mapToken,
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: mapBox.CameraPosition(
                                    target: getInitialMapBoxCameraPosition(
                                        state.currentOrder.driverLatitude,
                                        state.currentOrder.driverLongitude,
                                        state.currentOrder.deliveryLatitude,
                                        state.currentOrder.deliveryLongitude),
                                    zoom: 13.0),
                                trackCameraPosition: true,
                                compassEnabled: false,
                                cameraTargetBounds:
                                    mapBox.CameraTargetBounds.unbounded,
                                minMaxZoomPreference:
                                    mapBox.MinMaxZoomPreference.unbounded,
                                styleString: mapBox.MapboxStyles.MAPBOX_STREETS,
                                rotateGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                tiltGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                              ),
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: AppUtil.getDraggableHeight(context) /
                        AppUtil.getScreenHeight(context),
                    minChildSize: AppUtil.getDraggableHeight(context) /
                        AppUtil.getScreenHeight(context),
                    maxChildSize: AppUtil.getDraggableHeight(context) /
                        AppUtil.getScreenHeight(context),
                    builder: (context, controller) {
                      if (state is ErrorState) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(top: 10, bottom: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Connection Error",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, loginState) {
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CurrentOrderBloc>(context)
                                          .add(Retry(loginState.user.token));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: primary3,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "RETRY",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (state is LoadingState) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(top: 10, bottom: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Retrying...",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SpinKitCircle(
                                color: Colors.black38,
                                size: 30,
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.currentOrder.statusOrder == null) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(top: 10, bottom: 32),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Container(
                        height: AppUtil.getDraggableHeight(context),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32),
                                topLeft: Radius.circular(32))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              StatusItemWidget(
                                status: StatusOrder(status: "Order Placed"),
                                isActive:
                                    state.currentOrder.statusOrder.status ==
                                        "Order Placed",
                              ),
                              state.currentOrder.isPickupOrder()
                                  ? StatusItemWidget(
                                      status: StatusOrder(status: "Accepted"),
                                      isActive: state.currentOrder.statusOrder
                                              .status ==
                                          "Accepted",
                                      hasDriver: true,
                                      driverName: state.currentOrder.driverName,
                                      driverPhone:
                                          state.currentOrder.driverPhone,
                                    )
                                  : StatusItemWidget(
                                      status:
                                          StatusOrder(status: "Food Preparing"),
                                      isActive: state.currentOrder.statusOrder
                                              .status ==
                                          "Food Preparing",
                                      hasDriver: true,
                                      driverName: state.currentOrder.driverName,
                                      driverPhone:
                                          state.currentOrder.driverPhone,
                                    ),
                              StatusItemWidget(
                                status: StatusOrder(status: "On the way"),
                                isActive:
                                    state.currentOrder.statusOrder.status ==
                                        "On the way",
                                hasDriver: true,
                                driverName: state.currentOrder.driverName,
                                driverPhone: state.currentOrder.driverPhone,
                              ),
                              StatusItemWidget(
                                status: StatusOrder(status: "Delivered"),
                                isActive:
                                    state.currentOrder.statusOrder.status ==
                                        "Delivered",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _onMapCreated(mapBox.MapboxMapController controller) {
    mapBoxController = controller;
  }

  _animateMapBoxCameraToBounds(
      mapBox.LatLng driverLatLng, mapBox.LatLng deliveryLatLng) async {
    if (mapBoxController != null) {
      mapBoxController.removeSymbols(mapBoxController.symbols);
      mapBoxController.addSymbol(mapBox.SymbolOptions(
        geometry: driverLatLng,
        iconSize: 0.6,
        iconImage: "assets/drivericon.png",
      ));
      mapBoxController.addSymbol(mapBox.SymbolOptions(
        geometry: deliveryLatLng,
        iconSize: 0.5,
        iconImage: "assets/location.png",
      ));
      /*mapController.moveCamera(mapBox.CameraUpdate.newCameraPosition(
        mapBox.CameraPosition(
          target: latLng,
          zoom: 13.0,
        ),
      ));*/
      mapBoxController.animateCamera(mapBox.CameraUpdate.newLatLngBounds(
          getMapBoxCameraBounds(driverLatLng.latitude, driverLatLng.longitude,
              deliveryLatLng.latitude, deliveryLatLng.longitude),
          70));
    }
  }

  Future<void> _animateGoogleMapCameraToBounds(
      LatLngBounds latLngBounds) async {
    final GoogleMapController controller = await googleMapsController.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

  void setPinIcon() async {
    driverLocationIcon =
        await getBitmapDescriptorFromAssetBytes("assets/drivericon.png", 120);
    userLocationIcon =
        await getBitmapDescriptorFromAssetBytes("assets/location.png", 90);
  }

  LatLng getInitialGoogleMapCameraPosition(double driverLat, double driverLng,
      double deliveryLat, double deliveryLng) {
    if (driverLat != null &&
        driverLng != null &&
        deliveryLat != null &&
        deliveryLng != null) {
      return LatLng(
          (driverLat + deliveryLat) / 2, (driverLng + deliveryLng) / 2);
    } else {
      return LatLng(initLat, initLng);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  LatLngBounds getGoogleMapsCameraBounds(
      double driverLatitude,
      double driverLongitude,
      double deliveryLatitude,
      double deliveryLongitude) {
    if (driverLatitude <= deliveryLatitude &&
        driverLongitude <= deliveryLongitude) {
      return LatLngBounds(
          southwest: LatLng(driverLatitude, driverLongitude),
          northeast: LatLng(deliveryLatitude, deliveryLongitude));
    } else if (driverLatitude <= deliveryLatitude &&
        driverLongitude > deliveryLongitude) {
      return LatLngBounds(
          southwest: LatLng(driverLatitude, deliveryLongitude),
          northeast: LatLng(deliveryLatitude, driverLongitude));
    } else if (driverLatitude > deliveryLatitude &&
        driverLongitude <= deliveryLongitude) {
      return LatLngBounds(
          southwest: LatLng(deliveryLatitude, driverLongitude),
          northeast: LatLng(driverLatitude, deliveryLongitude));
    } else {
      return LatLngBounds(
          southwest: LatLng(deliveryLatitude, deliveryLongitude),
          northeast: LatLng(driverLatitude, driverLongitude));
    }
  }

  mapBox.LatLngBounds getMapBoxCameraBounds(
      double driverLatitude,
      double driverLongitude,
      double deliveryLatitude,
      double deliveryLongitude) {
    if (driverLatitude <= deliveryLatitude &&
        driverLongitude <= deliveryLongitude) {
      return mapBox.LatLngBounds(
          southwest: mapBox.LatLng(driverLatitude, driverLongitude),
          northeast: mapBox.LatLng(deliveryLatitude, deliveryLongitude));
    } else if (driverLatitude <= deliveryLatitude &&
        driverLongitude > deliveryLongitude) {
      return mapBox.LatLngBounds(
          southwest: mapBox.LatLng(driverLatitude, deliveryLongitude),
          northeast: mapBox.LatLng(deliveryLatitude, driverLongitude));
    } else if (driverLatitude > deliveryLatitude &&
        driverLongitude <= deliveryLongitude) {
      return mapBox.LatLngBounds(
          southwest: mapBox.LatLng(deliveryLatitude, driverLongitude),
          northeast: mapBox.LatLng(driverLatitude, deliveryLongitude));
    } else {
      return mapBox.LatLngBounds(
          southwest: mapBox.LatLng(deliveryLatitude, deliveryLongitude),
          northeast: mapBox.LatLng(driverLatitude, driverLongitude));
    }
  }

  mapBox.LatLng getInitialMapBoxCameraPosition(
      double driverLatitude,
      double driverLongitude,
      double deliveryLatitude,
      double deliveryLongitude) {
    if (driverLatitude != null &&
        driverLongitude != null &&
        deliveryLatitude != null &&
        deliveryLongitude != null) {
      return mapBox.LatLng((driverLatitude + deliveryLatitude) / 2,
          (driverLongitude + deliveryLongitude) / 2);
    } else {
      return mapBox.LatLng(initLat, initLng);
    }
  }
}

class StatusItemWidget extends StatelessWidget {
  final StatusOrder status;
  final bool isActive;
  final bool hasDriver;
  final String driverName;
  final String driverPhone;

  const StatusItemWidget(
      {Key key,
      this.status,
      this.isActive,
      this.hasDriver = false,
      this.driverName,
      this.driverPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
          vertical: 15, horizontal: horizontalPaddingDraggable),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: primary3,
                    blurRadius: 10,
                    spreadRadius: -3,
                  )
                ]
              : []),
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.3,
        duration: Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  status.getIconAssets(),
                  width: 60,
                  height: 60,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        status.status,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        status.getSubStatus(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                      hasDriver && isActive
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/driver_name_icon.svg",
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(driverName ?? "")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AppUtil.launchInBrowser(driverPhone);
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/phone_driver_icon.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(driverPhone ?? "")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
