import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:html/parser.dart';
import 'package:share/share.dart';

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

  static String getAppLogo() {
    return "assets/flyereatslogo2.png";
  }

  static Future<void> checkLocationServiceAndPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    Location location = new Location();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
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
    return double.parse(value.toStringAsFixed(2)).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    //return value.toStringAsFixed(2).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  static String getCurrencyIcon(String currencyCode) {
    if (currencyCode == "INR") {
      return "assets/rupee.svg";
    } else if (currencyCode == "SGD") {
      return "assets/sg dollar.svg";
    } else {
      return "";
    }
  }

  static share(BuildContext context, String referralCode, String referralAmount) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Install the FLYER EATS app now http://flyereats.app.link/mOvNgVSbm7 Use Referral code in Signup page - $referralCode We will give you $referralAmount & your buddy $referralAmount in your wallet after your orders above ₹99',
        subject: 'Flyer Eats',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
