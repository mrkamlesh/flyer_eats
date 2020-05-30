import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyereats/bloc/address/address_bloc.dart';
import 'package:flyereats/bloc/address/address_event.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/address_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<bool> _selections = [true, false, false];

  Completer<GoogleMapController> _controller = Completer();

  final double initLat = 28.620446;
  final double initLng = 77.227515;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
      create: (context) {
        return AddressBloc(AddressRepository())..add(AddressPageOpen());
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<AddressBloc, AddressState>(
                    condition: (oldState, state) {
                      if (state is UpdatingMapAddressSuccess) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      Marker marker;
                      if (state is UpdatingMapAddressSuccess) {
                        marker = Marker(
                            markerId: MarkerId("location"),
                            position: LatLng(
                                double.parse(state.address.latitude),
                                double.parse(state.address.longitude)),
                            icon: BitmapDescriptor.defaultMarker);
                        _animateCameraToPosition(LatLng(
                            double.parse(state.address.latitude),
                            double.parse(state.address.longitude)));
                      }

                      return GoogleMap(
                        markers: Set.of((marker != null) ? [marker] : []),
                        mapType: MapType.normal,
                        onTap: (latLng) {
                          BlocProvider.of(context)
                              .add(UpdateMapAddress(latLng));
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
                      width: AppUtil.getScreenWidth(context),
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
                      child: BlocBuilder<AddressBloc, AddressState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomTextField(
                                hint: "Enter Address",
                                onChange: (title) {
                                  BlocProvider.of<AddressBloc>(context).add(
                                      UpdateAddressInformation(title: title));
                                },
                              ),
                              CustomTextField(
                                lines: 3,
                                hint: "Address",
                                onChange: (address) {
                                  BlocProvider.of<AddressBloc>(context).add(
                                      UpdateAddressInformation(
                                          address: address));
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ToggleButton(
                                      isSelected: _selections[0],
                                      title: "HOME",
                                      onTap: () {
                                        _toggle(0);
                                        BlocProvider.of<AddressBloc>(context)
                                            .add(UpdateAddressInformation(
                                                type: AddressType.home));
                                      },
                                    ),
                                    ToggleButton(
                                        isSelected: _selections[1],
                                        title: "OFFICE",
                                        onTap: () {
                                          _toggle(1);
                                          BlocProvider.of<AddressBloc>(context)
                                              .add(UpdateAddressInformation(
                                                  type: AddressType.office));
                                        }),
                                    ToggleButton(
                                        isSelected: _selections[2],
                                        title: "OTHER",
                                        onTap: () {
                                          _toggle(2);
                                          BlocProvider.of<AddressBloc>(context)
                                              .add(UpdateAddressInformation(
                                                  type: AddressType.other));
                                        })
                                  ],
                                ),
                              ),
                              BlocBuilder<AddressBloc, AddressState>(
                                /*condition: (oldState, state){
                                  if (state is UpdatingMapAddressSuccess){
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },*/
                                builder: (context, state) {
                                  Address address =
                                      Address(null, null, null, null);
                                  if (state is UpdatingMapAddressSuccess) {
                                    address = state.address;
                                  }

                                  return GestureDetector(
                                    onTap: address.isValid()
                                        ? () {
                                            BlocProvider.of<AddressBloc>(
                                                    context)
                                                .add(AddAddress(address));
                                            Navigator.pop(context);
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
                                          opacity:
                                              address.isValid() ? 0.0 : 0.5,
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
                          );
                        },
                      ),
                    ),
                    BlocBuilder<AddressBloc, AddressState>(
                        builder: (context, state) {
                      if (state is UpdateMapAddress ||
                          state is LoadingCurrentAddress) {
                        return LinearProgressIndicator();
                      } else {
                        return SizedBox();
                      }
                    })
                  ],
                )
              ],
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
      ),
    );
  }

  void _toggle(int index) {
    setState(() {
      for (int i = 0; i < _selections.length; i++) {
        if (i == index) {
          _selections[i] = true;
        } else {
          _selections[i] = false;
        }
      }
    });
  }

  Future<void> _animateCameraToPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.5)));
  }
}

class ToggleButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onTap;

  const ToggleButton({Key key, this.isSelected, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 35,
        width: (AppUtil.getScreenWidth(context) - 80) / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isSelected ? primary1 : Colors.white,
            border: Border.all(
              color: Colors.black12,
            )),
        duration: Duration(milliseconds: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.home),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Function(String) onChange;

  const CustomTextField(
      {Key key, this.hint, this.controller, this.lines, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: lines,
        onChanged: (text) {
          onChange(text);
        },
        decoration: InputDecoration(
          hintText: hint != null ? hint : "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
