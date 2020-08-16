import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/bloc/location/predefinedlocations/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/select_current_location_page.dart';

class SelectLocationPage extends StatefulWidget {
  final bool isRedirectToHomePage;

  const SelectLocationPage({Key key, this.isRedirectToHomePage = true})
      : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController;
  double _offsetController = 0;

  PredefinedLocationsBloc _bloc = PredefinedLocationsBloc();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0 &&
        _scrollController.hasClients) {
      _offsetController = 0;
      _scrollController.animateTo(_offsetController,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<PredefinedLocationsBloc>(
          create: (context) {
            return _bloc..add(InitGetPredefinedLocation());
          },
          child: WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocBuilder<PredefinedLocationsBloc,
                  PredefinedLocationsState>(
                builder: (context, state) {
                  return Stack(
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
                                  widget.isRedirectToHomePage
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "Search Location",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          //BlocProvider.of<LocationBloc>(context).add(GetPreviousLocation());
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                            child: Icon(
                                                                Icons.clear)))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return SelectCurrentLocationPage(
                                                    token:
                                                        loginState.user.token,
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable,
                                                ),
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
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
                                                      "Current Location",
                                                      style: TextStyle(
                                                          color: primary3,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPaddingDraggable,
                                    ),
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      "Locations",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: DropdownButton<String>(
                                            underline: Container(),
                                            isExpanded: false,
                                            isDense: true,
                                            iconSize: 0,
                                            value: state.selectedCountry,
                                            items: [
                                              DropdownMenuItem(
                                                value: "101",
                                                child: Container(
                                                  width: 80,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: "196",
                                                child: Container(
                                                  width: 80,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                            onChanged: (i) {
                                              _bloc.add(ChangeCountry(i));
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: TextField(
                                              controller: _controller,
                                              autofocus: true,
                                              onChanged: (filter) {
                                                _bloc.add(
                                                    FilterLocations(filter));
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15),
                                                border: InputBorder.none,
                                                hintText: "SELECT LOCATIONS",
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black38),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*Container(
                                margin: EdgeInsets.only(
                                    left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, bottom: 20),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(4)),
                                child: Text("Select your town or city here"),
                              ),*/
                                  Expanded(
                                    child: BlocBuilder<PredefinedLocationsBloc,
                                        PredefinedLocationsState>(
                                      builder: (context, state) {
                                        if (state
                                            is LoadingPredefinedLocations) {
                                          return Center(
                                              child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(),
                                          ));
                                        } else if (state
                                            is ErrorPredefinedLocations) {
                                          return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      horizontalPaddingDraggable,
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Text("${state.message}"));
                                        } else if (state
                                            is NoAvailablePredefinedLocations) {
                                          return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      horizontalPaddingDraggable,
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Text(
                                                  "No Available Locations"));
                                        }
                                        return Container(
                                          child: CustomScrollView(
                                            slivers: <Widget>[
                                              SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                          (context, i) {
                                                return InkWell(
                                                  onTap: widget
                                                          .isRedirectToHomePage
                                                      ? () {
                                                          _onTapRedirectToHomePage(
                                                            i,
                                                            loginState
                                                                .user.token,
                                                            state.filteredLocations[
                                                                i],
                                                          );
                                                        }
                                                      : () {
                                                          _onTap(state
                                                              .filteredLocations[i]);
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
                                                                state
                                                                    .filteredLocations[
                                                                        i]
                                                                    .address,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
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
                                              },
                                                          childCount: state
                                                              .filteredLocations
                                                              .length))
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      state is InitialPredefinedLocationsState
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                              child: Center(
                                child: SpinKitCircle(
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          : IgnorePointer(child: Container()),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapRedirectToHomePage(i, String token, Location location) {
    BlocProvider.of<HomeBloc>(context)
        .add(GetHomeDataByLocation(location, token));
    Navigator.pushReplacementNamed(context, "/home");
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    //BlocProvider.of<LocationBloc>(context).add(GetPreviousLocation());

    return true;
  }

  void _onTap(Location location) {
    Navigator.pop(context, location);
  }
}
