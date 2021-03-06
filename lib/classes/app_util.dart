import 'package:clients/model/restaurant.dart';
import 'package:clients/model/shop_category.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        //headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> checkLocationServiceAndPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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

    await location.getLocation().timeout(Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }

  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static String doubleRemoveZeroTrailing(double value) {
    return double.parse(value.toStringAsFixed(2))
        .toString()
        .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
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

  static String formattedPhoneNumber(String phoneNumber) {
    return phoneNumber.substring(0, 3) + " " + phoneNumber.substring(3);
  }

  static String getCurrencyString(String currencyCode) {
    if (currencyCode == "INR") {
      return "\u20b9";
    } else if (currencyCode == "SGD") {
      return "S\$";
    } else {
      return "";
    }
  }

  static share(BuildContext context, String referralCode, String referralAmount,
      String minOrderAmount) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Install the FLYER EATS app now http://flyereats.app.link/mOvNgVSbm7 Use Referral code in Signup page - $referralCode We will give you $referralAmount & your buddy $referralAmount in your wallet after your orders above $minOrderAmount',
        subject: 'Flyer Eats',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  static List<Restaurant> restaurantListSort(List<Restaurant> list) {
    int n = list.length;
    int i, step;
    for (step = 0; step < n; step++) {
      for (i = 0; i < n - step - 1; i++) {
        if (!(list[i].isOpen) && list[i + 1].isOpen) {
          Restaurant temp = list[i];
          list[i] = list[i + 1];
          list[i + 1] = temp;
        }
      }
    }

    return list;
  }

  static List<ShopCategory> getShopCategories() {
    List<ShopCategory> _listShopCategory = [];
    _listShopCategory
        .add(ShopCategory("Restaurants", "assets/restaurants.svg"));
    _listShopCategory.add(ShopCategory("Grocery", "assets/groceries.svg"));
    _listShopCategory.add(ShopCategory("Veg & Fruits", "assets/vegfruits.svg"));
    _listShopCategory.add(ShopCategory("Meat", "assets/meat.svg"));

    return _listShopCategory;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
