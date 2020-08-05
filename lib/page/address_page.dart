import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clients/bloc/address/address_bloc.dart';
import 'package:clients/bloc/address/address_event.dart';
import 'package:clients/bloc/address/address_repository.dart';
import 'package:clients/bloc/address/address_state.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPage extends StatefulWidget {
  final Address address;
  final forcedDefault;

  const AddressPage({Key key, this.address, this.forcedDefault = false}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<bool> _selections = [false, false, false];

  Completer<GoogleMapController> _controller = Completer();

  final double initLat = 28.620446;
  final double initLng = 77.227515;

  TextEditingController _titleController = TextEditingController();

  /*TextEditingController _addressController = TextEditingController();*/
  String _addressString = "";

  @override
  void initState() {
    super.initState();

    AppUtil.checkLocationServiceAndPermission();

    if (widget.address != null) {
      switch (widget.address.type) {
        case AddressType.home:
          _toggle(0);
          break;
        case AddressType.office:
          _toggle(1);
          break;
        default:
          _toggle(2);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
      create: (context) {
        if (widget.address != null) {
          return AddressBloc(AddressRepository())..add(AddressUpdatePageOpen(widget.address));
        } else {
          return AddressBloc(AddressRepository())
            ..add(AddressAddPageOpen())
            ..add(UpdateAddressInformation(isDefault: widget.forcedDefault));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: AppUtil.getScreenHeight(context),
            width: AppUtil.getScreenWidth(context),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: BlocBuilder<AddressBloc, AddressState>(
                        condition: (oldState, state) {
                          if (state is LoadingTemporaryAddressSuccess) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          Marker marker;
                          if (state is LoadingTemporaryAddressSuccess) {
                            if (state.address.latitude != null && state.address.longitude != null) {
                              marker = Marker(
                                  markerId: MarkerId("location"),
                                  position: LatLng(
                                      double.parse(state.address.latitude), double.parse(state.address.longitude)),
                                  icon: BitmapDescriptor.defaultMarker);
                              _animateCameraToPosition(
                                  LatLng(double.parse(state.address.latitude), double.parse(state.address.longitude)));
                            }
                          }

                          return GoogleMap(
                            markers: Set.of((marker != null) ? [marker] : []),
                            mapType: MapType.normal,
                            onTap: (latLng) {
                              BlocProvider.of<AddressBloc>(context).add(UpdateAddressLocation(latLng));
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
                          height: AppUtil.getScreenHeight(context) * 0.6,
                          width: AppUtil.getScreenWidth(context),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 0)]),
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable, vertical: distanceBetweenSection),
                          child: BlocConsumer<AddressBloc, AddressState>(
                            listener: (oldState, state) {
                              if (state is LoadingTemporaryAddressSuccess) {
                                if (state.isFromMap != null) {
                                  _addressString = state.address.address;
                                  /*_addressController.text = state.address.address;*/
                                  _titleController.text = state.address.title;
                                }
                              } else if (state is AddressUpdated) {
                                if (state.isUpdated) {
                                  if (state.address.isDefault) {
                                    BlocProvider.of<LoginBloc>(context).add(UpdateDefaultAddress(state.address));
                                  }
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          title: Text(
                                            "Success",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Text("successfully updated"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          title: Text(
                                            "Error",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Text("Something went wrong during processing your request"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        );
                                      });
                                }
                              } else if (state is AddressAdded) {
                                if (state.isAdded) {
                                  if (state.address.isDefault) {
                                    BlocProvider.of<LoginBloc>(context).add(UpdateDefaultAddress(state.address));
                                  }
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          title: Text(
                                            "Success",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Text("successfully added"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context, state.address);
                                                  Navigator.pop(context, state.address);
                                                },
                                                child: Text("OK"))
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          title: Text(
                                            "Error",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Text("Something went wrong during processing your request"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                            builder: (context, state) {
                              Address address = Address(null, null, null, null, isDefault: false);
                              if (state is LoadingTemporaryAddressSuccess) {
                                address = state.address;
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  CustomTextField(
                                    controller: _titleController,
                                    hint: "Enter Address",
                                    lines: 1,
                                    onChange: (title) {
                                      BlocProvider.of<AddressBloc>(context).add(UpdateAddressInformation(title: title));
                                    },
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, top: 15),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      child: Text(
                                        _addressString,
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                          value: address.isDefault,
                                          onChanged: (value) {
                                            BlocProvider.of<AddressBloc>(context)
                                                .add(UpdateAddressInformation(isDefault: value));
                                          },
                                        ),
                                        Text("Set as default address"),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        ToggleButton(
                                          isSelected: _selections[0],
                                          title: "HOME",
                                          onTap: () {
                                            _toggle(0);
                                            BlocProvider.of<AddressBloc>(context)
                                                .add(UpdateAddressInformation(type: AddressType.home));
                                          },
                                        ),
                                        ToggleButton(
                                            isSelected: _selections[1],
                                            title: "OFFICE",
                                            onTap: () {
                                              _toggle(1);
                                              BlocProvider.of<AddressBloc>(context)
                                                  .add(UpdateAddressInformation(type: AddressType.office));
                                            }),
                                        ToggleButton(
                                            isSelected: _selections[2],
                                            title: "OTHER",
                                            onTap: () {
                                              _toggle(2);
                                              BlocProvider.of<AddressBloc>(context)
                                                  .add(UpdateAddressInformation(type: AddressType.other));
                                            })
                                      ],
                                    ),
                                  ),
                                  BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, loginState) {
                                      return GestureDetector(
                                        onTap: address.isValid()
                                            ? () {
                                                widget.address == null
                                                    ? BlocProvider.of<AddressBloc>(context)
                                                        .add(AddAddress(address, loginState.user.token))
                                                    : BlocProvider.of<AddressBloc>(context)
                                                        .add(UpdateAddress(address, loginState.user.token));
                                                //Navigator.pop(context);
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
                                                widget.address == null ? "DONE" : "UPDATE",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              opacity: address.isValid() ? 0.0 : 0.5,
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
                              );
                            },
                          ),
                        ),
                        BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
                          if (state is LoadingTemporaryAddress) {
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
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
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
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 15.5)));
  }
}

class ToggleButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onTap;

  const ToggleButton({Key key, this.isSelected, this.title, this.onTap}) : super(key: key);

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

  const CustomTextField({Key key, this.hint, this.controller, this.lines, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
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
