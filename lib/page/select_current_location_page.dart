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

class SelectCurrentLocationPage extends StatefulWidget {
  final String token;

  const SelectCurrentLocationPage({Key key, this.token}) : super(key: key);

  @override
  _SelectCurrentLocationPageState createState() =>
      _SelectCurrentLocationPageState();
}

class _SelectCurrentLocationPageState extends State<SelectCurrentLocationPage> {
  CurrentLocationBloc _bloc = CurrentLocationBloc();

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
          child: BlocBuilder<CurrentLocationBloc, CurrentLocationState>(
            builder: (context, state) {
              if (state.lat != null && state.lng != null) {
                marker = Marker(
                    markerId: MarkerId("location"),
                    position: LatLng(state.lat, state.lng),
                    icon: BitmapDescriptor.defaultMarker);
              }
              _animateCameraToPosition(LatLng(state.lat, state.lng));

              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      width: AppUtil.getScreenWidth(context),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: GoogleMap(
                              onCameraMove: (position) {
                                // _bloc.add(UpdateLocation(position.target));
                              },
                              markers: Set.of((marker != null) ? [marker] : []),
                              mapType: MapType.normal,
                              onTap: (latLng) {
                                _bloc.add(UpdateAddress(
                                    latLng.latitude, latLng.longitude));
                              },
                              zoomControlsEnabled: true,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomGesturesEnabled: true,
                              padding: EdgeInsets.all(32),
                              compassEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(state.lat, state.lng),
                                zoom: 15.5,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                          Stack(
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
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "/home",
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
                              state is LoadingCurrentLocationState
                                  ? LinearProgressIndicator()
                                  : SizedBox(),
                            ],
                          )
                        ],
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
                                shape: BoxShape.circle, color: Colors.black45),
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
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _animateCameraToPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.5)));
  }
}
