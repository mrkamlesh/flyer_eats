import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/currentorder/bloc.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/status_order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({Key key}) : super(key: key);

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final double initLat = 28.620446;
  final double initLng = 77.227515;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentOrderBloc, CurrentOrderState>(
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
                    child: GoogleMap(
                      mapType: MapType.normal,
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
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: AppUtil.getDraggableHeight(context) / AppUtil.getScreenHeight(context),
                minChildSize: AppUtil.getDraggableHeight(context) / AppUtil.getScreenHeight(context),
                maxChildSize: AppUtil.getDraggableHeight(context) / AppUtil.getScreenHeight(context),
                builder: (context, controller) {
                  if (state is ErrorState) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                                  BlocProvider.of<CurrentOrderBloc>(context).add(Retry(loginState.user.token));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(color: primary3, borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "RETRY",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                        borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: StatusItemWidget(
                            status: StatusOrder(status: "Order Placed"),
                            isActive: state.currentOrder.statusOrder.status == "Order Placed",
                          ),
                        ),
                        state.currentOrder.isPickupOrder()
                            ? Expanded(
                                child: StatusItemWidget(
                                  status: StatusOrder(status: "Accepted"),
                                  isActive: state.currentOrder.statusOrder.status == "Accepted",
                                ),
                              )
                            : Expanded(
                                child: StatusItemWidget(
                                  status: StatusOrder(status: "Food Preparing"),
                                  isActive: state.currentOrder.statusOrder.status == "Food Preparing",
                                ),
                              ),
                        Expanded(
                          child: StatusItemWidget(
                            status: StatusOrder(status: "On the way"),
                            isActive: state.currentOrder.statusOrder.status == "On the way",
                          ),
                        ),
                        Expanded(
                          child: StatusItemWidget(
                            status: StatusOrder(status: "Delivered"),
                            isActive: state.currentOrder.statusOrder.status == "Delivered",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatusItemWidget extends StatelessWidget {
  final StatusOrder status;
  final bool isActive;

  const StatusItemWidget({Key key, this.status, this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: horizontalPaddingDraggable),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        status.getSubStatus(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      )
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
