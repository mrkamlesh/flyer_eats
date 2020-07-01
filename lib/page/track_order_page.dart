import 'package:flutter/material.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOrderPage extends StatefulWidget {
  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final double initLat = 28.620446;
  final double initLng = 77.227515;

  @override
  Widget build(BuildContext context) {
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
            maxChildSize: 1.0,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(top: 10, bottom: 32),
                child: Column(
                  children: <Widget>[Text("test"), Expanded(child: Text("test"))],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
