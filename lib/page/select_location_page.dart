import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/page/select_current_location_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  int _groupValue = -1;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<LocationBloc>(context).add(GetCurrentLocation());
    /*BlocProvider.of<LocationBloc>(context)
        .add(GetPredefinedLocations(LatLng(10.69, 77.004)));*/
    //_bloc.add(GetPredefinedLocations(LatLng(10.69, 77.004)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                        "assets/allrestaurant.png",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: AppUtil.getScreenWidth(context),
                  height: AppUtil.getBannerHeight(context),
                  decoration: BoxDecoration(color: Colors.black87),
                ),
              ),
            ),
            Positioned(
              top: AppUtil.getToolbarHeight(context),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(
                  top: horizontalPaddingDraggable,
                ),
                child: Container(
                  height: AppUtil.getScreenHeight(context) -
                      AppUtil.getToolbarHeight(context) -
                      MediaQuery.of(context).padding.top,
                  width: AppUtil.getScreenWidth(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingDraggable),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "SELECT LOCATION",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                  onTap: () {
                                    BlocProvider.of<LocationBloc>(context)
                                        .add(GetPreviousLocation());
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(child: Icon(Icons.clear)))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SelectCurrentLocationPage();
                          }));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingDraggable,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: SvgPicture.asset(
                                    "assets/currentloc.svg",
                                    color: primary3,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "CURRENT LOCATION",
                                style: TextStyle(color: primary3, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingDraggable,
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Locations",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: AppUtil.getScreenWidth(context),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.only(
                            bottom: 20,
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12)),
                        child: TextField(
                          controller: _controller,
                          onChanged: (filter) {
                            BlocProvider.of<LocationBloc>(context)
                                .add(FilterLocations(filter));
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: InputBorder.none,
                            hintText: "SELECT LOCATIONS",
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text("Select your town or city here"),
                      ),
                      Expanded(
                        child: BlocBuilder<LocationBloc, LocationState>(
                          condition: (oldState, state) {
                            if (state is LoadingPredefinedLocations ||
                                state is LoadingPredefinedLocationsSuccess ||
                                state is LoadingPredefinedLocationsError ||
                                state is NoLocationsAvailable ||
                                state is LoadingLocation ||
                                state is LoadingLocationSuccess ||
                                state is LoadingLocationError ||
                                state is PredefinedLocationsFiltered)
                              return true;
                            return false;
                          },
                          builder: (context, state) {
                            if (state is LoadingPredefinedLocations ||
                                state is LoadingLocation) {
                              return Center(
                                  child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ));
                            } else if (state
                                is LoadingPredefinedLocationsError) {
                              return Center(child: Text("${state.message}"));
                            } else if (state is LoadingLocationError) {
                              return Center(child: Text("${state.message}"));
                            } else if (state is LoadingLocationSuccess) {
                              BlocProvider.of<LocationBloc>(context).add(
                                  GetPredefinedLocations(LatLng(
                                      state.location.latitude,
                                      state.location.longitude)));
                              return Center(
                                  child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ));
                            } else if (state is NoLocationsAvailable) {
                              return Center(child: Text(state.message));
                            } else if (state
                                    is LoadingPredefinedLocationsSuccess ||
                                state is PredefinedLocationsFiltered) {
                              List<Location> list = List();

                              if (state is LoadingPredefinedLocationsSuccess) {
                                list = state.locations;
                              } else if (state is PredefinedLocationsFiltered) {
                                list = state.locations;
                              }

                              return Container(
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, i) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                horizontalPaddingDraggable),
                                        child: GestureDetector(
                                          onTap: () {
                                            _onTap(i, list[i]);
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Radio(
                                                activeColor: Colors.green,
                                                value: i,
                                                groupValue: _groupValue,
                                                onChanged: (i) {
                                                  _onTap(i, list[i]);
                                                },
                                              ),
                                              Expanded(
                                                child: Text(
                                                  list[i].address,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }, childCount: list.length))
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTap(i, Location list) {
    setState(() {
      _groupValue = i;
      BlocProvider.of<LocationBloc>(context).add(SelectLocation(list));
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);


    return true;
  }
}
