import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/bloc/location/location_bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectCurrentLocationPage extends StatefulWidget {
  @override
  _SelectCurrentLocationPageState createState() =>
      _SelectCurrentLocationPageState();
}

class _SelectCurrentLocationPageState extends State<SelectCurrentLocationPage> {
  Completer<GoogleMapController> _controller = Completer();

  final double initLat = 28.620446;
  final double initLng = 77.227515;

  Marker marker;

  @override
  void initState() {
    super.initState();
    AppUtil.checkLocationServiceAndPermission();
    BlocProvider.of<LocationBloc>(context).add(GetCurrentLocation());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: AppUtil.getScreenWidth(context),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: BlocConsumer<LocationBloc, LocationState>(
                    buildWhen: (oldState, state) {
                      if (state is LoadingLocationSuccess ||
                          state is LoadingLocationError ||
                          state is UpdatingLocationSuccess ||
                          state is LocationMoved) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    listenWhen: (oldState, state) {
                      if (state is LoadingLocationError) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    listener: (context, state) {
                      if (state is LoadingLocationError) {
                        final snackBar = SnackBar(
                          content: Text(state.message),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    builder: (context, state) {
                      LatLng loc;
                      if (state is LoadingLocationSuccess) {
                        loc = LatLng(
                            state.location.latitude, state.location.longitude);
                        _animateCameraToPosition(loc);
                        BlocProvider.of<LocationBloc>(context)
                            .add(UpdateLocation(loc));
                      } else if (state is UpdatingLocationSuccess) {
                        loc = LatLng(
                            state.location.latitude, state.location.longitude);
                      } else if (state is LocationMoved) {
                        loc = state.latLng;
                        BlocProvider.of<LocationBloc>(context)
                            .add(UpdateLocation(loc));
                      }

                      if (loc != null) {
                        marker = Marker(
                            markerId: MarkerId("location"),
                            position: LatLng(loc.latitude, loc.longitude),
                            icon: BitmapDescriptor.defaultMarker);
                      }

                      return GoogleMap(
                        onCameraMove: (position) {
                          // _bloc.add(UpdateLocation(position.target));
                        },
                        markers: Set.of((marker != null) ? [marker] : []),
                        mapType: MapType.normal,
                        onTap: (latLng) {
                          BlocProvider.of<LocationBloc>(context)
                              .add(MoveLocation(latLng));
                        },
                        zoomControlsEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomGesturesEnabled: true,
                        padding: EdgeInsets.all(32),
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
                            margin:
                                EdgeInsets.only(bottom: distanceSectionContent),
                            child: Text(
                              "Your Location",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black38),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.location_on),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child:
                                      BlocBuilder<LocationBloc, LocationState>(
                                    condition: (oldState, state) {
                                      if (state is UpdatingLocationSuccess)
                                        return true;
                                      return false;
                                    },
                                    builder: (context, state) {
                                      String address = "...";
                                      if (state is UpdatingLocationSuccess) {
                                        address = state.location.address;
                                      }
                                      return Container(
                                        child: Text(
                                          address + "\n",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          BlocBuilder<LocationBloc, LocationState>(
                            condition: (oldState, state) {
                              if (state is LoadingLocationSuccess ||
                                  state is LoadingLocationError ||
                                  state is UpdatingLocationSuccess ||
                                  state is LocationMoved) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: state is UpdatingLocationSuccess
                                    ? () {
                                        //Navigator pop
                                        BlocProvider.of<LocationBloc>(context)
                                            .add(GetLocationByLatLng(
                                                state.location.latitude,
                                                state.location.longitude));
                                        Navigator.pushReplacementNamed(
                                            context, "/home");
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
                                        "CONFIRM LOCATION",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: state is UpdatingLocationSuccess
                                          ? 0.0
                                          : 0.5,
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
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        if (state is LoadingLocation ||
                            state is UpdatingLocation) {
                          return LinearProgressIndicator();
                        }
                        return SizedBox();
                      },
                    ),
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
  }

  Future<void> _animateCameraToPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.5)));
  }
}
