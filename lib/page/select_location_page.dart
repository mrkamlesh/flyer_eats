import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/location/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/page/select_current_location_page.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  int _selectedCountry = 101;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController;
  double _offsetController = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationBloc>(context)
        .add(GetPredefinedLocations(_selectedCountry.toString()));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 &&
        _scrollController.hasClients) {
      _offsetController = 200;
      _scrollController.animateTo(_offsetController,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

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
            CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppUtil.getToolbarHeight(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            topLeft: Radius.circular(32))),
                    padding: EdgeInsets.only(
                      top: horizontalPaddingDraggable,
                    ),
                    height: AppUtil.getScreenHeight(context) +
                        _offsetController -
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, loginState) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SelectCurrentLocationPage(
                                    token: loginState.user.token,
                                  );
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
                                      style: TextStyle(
                                          color: primary3, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.black12, width: 1.0)),
                          margin: EdgeInsets.only(
                              bottom: 20,
                              left: horizontalPaddingDraggable,
                              right: horizontalPaddingDraggable),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<int>(
                                  underline: Container(),
                                  isExpanded: false,
                                  isDense: true,
                                  iconSize: 0,
                                  value: _selectedCountry,
                                  items: [
                                    DropdownMenuItem(
                                      value: 101,
                                      child: Container(
                                        width: 80,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                height: 20,
                                                child: SvgPicture.asset(
                                                    "assets/india_flag.svg"),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "IND",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 196,
                                      child: Container(
                                        width: 80,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                height: 20,
                                                child: SvgPicture.asset(
                                                    "assets/singapore_flag.svg"),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "SNG",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (i) {
                                    setState(() {
                                      _selectedCountry = i;
                                    });
                                    BlocProvider.of<LocationBloc>(context).add(
                                        GetPredefinedLocations(
                                            _selectedCountry.toString()));
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.black12,
                                              width: 1.0))),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: _controller,
                                    onChanged: (filter) {
                                      BlocProvider.of<LocationBloc>(context)
                                          .add(FilterLocations(filter));
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                      hintText: "SELECT LOCATIONS",
                                      hintStyle: TextStyle(
                                          fontSize: 16, color: Colors.black38),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                  state is PredefinedLocationsFiltered)
                                return true;
                              return false;
                            },
                            builder: (context, state) {
                              if (state is LoadingPredefinedLocations) {
                                return Center(
                                    child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                ));
                              } else if (state
                                  is LoadingPredefinedLocationsError) {
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: horizontalPaddingDraggable,
                                        horizontal: horizontalPaddingDraggable),
                                    child: Text("${state.message}"));
                              } else if (state is NoLocationsAvailable) {
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: horizontalPaddingDraggable,
                                        horizontal: horizontalPaddingDraggable),
                                    child: Text("${state.message}"));
                              } else if (state
                                      is LoadingPredefinedLocationsSuccess ||
                                  state is PredefinedLocationsFiltered) {
                                List<Location> list = List();
                                if (state
                                    is LoadingPredefinedLocationsSuccess) {
                                  list = state.locations;
                                } else if (state
                                    is PredefinedLocationsFiltered) {
                                  list = state.locations;
                                }

                                return BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, loginState) {
                                    return Container(
                                      child: CustomScrollView(
                                        slivers: <Widget>[
                                          SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                      (context, i) {
                                            return GestureDetector(
                                              onTap: () {
                                                _onTap(
                                                  i,
                                                  loginState.user.token,
                                                  list[i],
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        horizontalPaddingDraggable,
                                                    right:
                                                        horizontalPaddingDraggable,
                                                    bottom: 5),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(
                                                            list[i].address,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 18,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Divider(
                                                      color: Colors.black12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }, childCount: list.length))
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(i, String token, Location location) {
    setState(() {
      BlocProvider.of<LocationBloc>(context)
          .add(GetHomeDataByLocation(location, token));
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);

    return true;
  }
}
