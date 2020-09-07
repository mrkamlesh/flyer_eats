import 'dart:async';

import 'package:clients/bloc/location/currentlocation/bloc.dart';
import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clients/page/home.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapBox;

class SelectCurrentLocationPage extends StatefulWidget {
  final String token;

  const SelectCurrentLocationPage({Key key, this.token}) : super(key: key);

  @override
  _SelectCurrentLocationPageState createState() =>
      _SelectCurrentLocationPageState();
}

class _SelectCurrentLocationPageState extends State<SelectCurrentLocationPage> {
  final double initLat = 28.620446;
  final double initLng = 77.227515;

  CurrentLocationBloc _bloc = CurrentLocationBloc();

  mapBox.MapboxMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  Marker marker;

  @override
  void initState() {
    super.initState();
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
        return BlocProvider<CurrentLocationBloc>(
          create: (context) {
            return _bloc..add(GetCurrentLocationEvent());
          },
          child: BlocConsumer<CurrentLocationBloc, CurrentLocationState>(
            listener: (context, state) {
              if (state is SuccessCurrentLocationState) {
                if (!(loginState.user.isGoogleMapsUsed())) {
                  _animateMapBoxCameraToPosition(
                      mapBox.LatLng(state.lat, state.lng));
                }
              }
            },
            builder: (context, state) {
              if (loginState.user.isGoogleMapsUsed()) {
                if (state.lat != null && state.lng != null) {
                  marker = Marker(
                      markerId: MarkerId("location"),
                      position: LatLng(state.lat, state.lng),
                      icon: BitmapDescriptor.defaultMarker);
                  _animateGoogleMapCameraToPosition(
                      LatLng(state.lat, state.lng));
                }
              }
              return Scaffold(
                body: Container(
                  width: AppUtil.getScreenWidth(context),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: AppUtil.getScreenHeight(context) * 0.7,
                        child: Stack(
                          children: [
                            loginState.user.isGoogleMapsUsed()
                                ? GoogleMap(
                                    onCameraMove: (position) {
                                      // _bloc.add(UpdateLocation(position.target));
                                    },
                                    markers: Set.of(
                                        (marker != null) ? [marker] : []),
                                    mapType: MapType.normal,
                                    onTap: (latLng) {
                                      _bloc.add(UpdateAddress(
                                          latLng.latitude, latLng.longitude));
                                    },
                                    zoomGesturesEnabled: true,
                                    zoomControlsEnabled: false,
                                    padding: EdgeInsets.all(32),
                                    compassEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(state.lat ?? initLat,
                                          state.lng ?? initLng),
                                      zoom: 15.5,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  )
                                : mapBox.MapboxMap(
                                    accessToken: loginState.user.mapToken,
                                    onMapCreated: _onMapBoxCreated,
                                    initialCameraPosition:
                                        mapBox.CameraPosition(
                                      target: mapBox.LatLng(initLat ?? initLat,
                                          initLng ?? initLng),
                                      zoom: 13.0,
                                    ),
                                    trackCameraPosition: true,
                                    compassEnabled: false,
                                    cameraTargetBounds:
                                        mapBox.CameraTargetBounds.unbounded,
                                    minMaxZoomPreference:
                                        mapBox.MinMaxZoomPreference.unbounded,
                                    styleString:
                                        mapBox.MapboxStyles.MAPBOX_STREETS,
                                    rotateGesturesEnabled: true,
                                    scrollGesturesEnabled: true,
                                    tiltGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                    //myLocationEnabled: true,
                                    /*myLocationTrackingMode:
                          mapBox.MyLocationTrackingMode.None,
                      myLocationRenderMode: mapBox.MyLocationRenderMode.GPS,*/
                                    onMapClick: (point, latLng) async {
                                      _bloc.add(UpdateAddress(
                                          latLng.latitude, latLng.longitude));
                                      mapController
                                          .removeSymbols(mapController.symbols);
                                      mapController
                                          .addSymbol(mapBox.SymbolOptions(
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
                                      _bloc.add(GetCurrentLocationEvent());
                                    }),
                              ),
                            ),
                            Positioned(
                              top: AppUtil.getToolbarHeight(context) / 2,
                              left: 0,
                              child: GestureDetector(
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
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
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
                                  vertical: horizontalPaddingDraggable),
                              child: Container(
                                height: 0.3 * AppUtil.getScreenHeight(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: distanceSectionContent),
                                      child: Text(
                                        "Your Location",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 18),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.location_on),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                state.address + "\n",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: state
                                                  is LoadingCurrentLocationState ||
                                              state is ErrorCurrentLocationState
                                          ? () {}
                                          : () {
                                              //implement get home page data here
                                              BlocProvider.of<HomeBloc>(context)
                                                  .add(GetHomeDataByLatLng(
                                                      loginState.user.token,
                                                      state.lat,
                                                      state.lng));
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return Home();
                                              }),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            },
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
                                              "CONFIRM LOCATION",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          AnimatedOpacity(
                                            opacity: state
                                                        is LoadingCurrentLocationState ||
                                                    state
                                                        is ErrorCurrentLocationState
                                                ? 0.5
                                                : 0.0,
                                            child: Container(
                                              height: 50,
                                              color: Colors.white,
                                            ),
                                            duration:
                                                Duration(milliseconds: 300),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            state is LoadingCurrentLocationState
                                ? LinearProgressIndicator()
                                : SizedBox(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _onMapBoxCreated(mapBox.MapboxMapController controller) {
    mapController = controller;
  }

  _animateMapBoxCameraToPosition(mapBox.LatLng latLng) async {
    if (mapController != null) {
      mapController.removeSymbols(mapController.symbols);
      mapController.addSymbol(mapBox.SymbolOptions(
        geometry: latLng,
        iconSize: 0.6,
        iconImage: "assets/location.png",
      ));
      mapController.moveCamera(mapBox.CameraUpdate.newCameraPosition(
        mapBox.CameraPosition(
          target: latLng,
          zoom: 13.0,
        ),
      ));
    }
  }

  Future<void> _animateGoogleMapCameraToPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.5)));
  }
}
