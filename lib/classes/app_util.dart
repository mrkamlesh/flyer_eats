import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:html/parser.dart';

class AppUtil {
  static double getScreenHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDraggableHeight(context) {
    return getScreenHeight(context) * 0.65;
  }

  static double getBannerOffset() {
    return 35;
  }

  static double getBannerHeight(context) {
    return getScreenHeight(context) * 0.35 + getBannerOffset();
  }

  static double getToolbarHeight(context) {
    return kToolbarHeight + MediaQuery.of(context).padding.top;
  }

  static Future<void> checkLocationServiceAndPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static String doubleRemoveZeroTrailing(double value) {
    return value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }
}
