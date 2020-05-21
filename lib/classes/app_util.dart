import 'package:flutter/material.dart';

class AppUtil {
  static double getScreenHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDraggableHeight(context) {
    return getScreenHeight(context) * 0.7;
  }

  static double getBannerOffset() {
    return 35;
  }

  static double getBannerHeight(context) {
    return getScreenHeight(context) * 0.3 + getBannerOffset();
  }


  static double getToolbarHeight(context) {
    return kToolbarHeight + MediaQuery.of(context).padding.top;
  }
}
