import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/restaurant_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/model/banner.dart';
import 'package:shimmer/shimmer.dart';

class BannerListWidget extends StatefulWidget {
  final List<BannerItem> bannerList;
  final Location location;

  const BannerListWidget({Key key, this.bannerList, this.location}) : super(key: key);

  @override
  _BannerListWidgetState createState() => _BannerListWidgetState();
}

class _BannerListWidgetState extends State<BannerListWidget> {
  int _currentIndex = 0;
  PageController _pageController;
  Timer _timer;

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: 4), (t) {
      _currentIndex++;
      _pageController.animateToPage(_currentIndex % widget.bannerList.length,
          duration: Duration(milliseconds: 700), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    /*List<Widget> pageViewIndicators = [];
    for (int i = 0; i < widget.bannerList.length; i++) {
      pageViewIndicators.add(PageViewIndicator(
        currentIndex: _currentIndex,
        index: i,
      ));
    }*/

    return Container(
      width: AppUtil.getScreenWidth(context),
      height: AppUtil.getBannerHeight(context),
      child: Stack(
        children: <Widget>[
          PageView.builder(
              controller: _pageController,
              onPageChanged: (i) {
                setState(() {
                  /*_currentIndex = i;*/
                  _currentIndex = i % widget.bannerList.length;
                });
              },
              itemCount: widget.bannerList.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return RestaurantDetailPage(
                        restaurant: widget.bannerList[i].restaurant,
                        location: widget.location,
                      );
                    }));
                  },
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: CachedNetworkImage(
                        imageUrl: widget.bannerList[i].image,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                              child: Container(
                                height: 80,
                                width: 80,
                                color: Colors.black,
                              ),
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100]);
                        },
                      )),
                );
              }),
          /*Positioned(
            bottom: 0,
            child: Container(
                margin:
                    EdgeInsets.only(bottom: 1.5 * AppUtil.getBannerOffset()),
                height: 20,
                width: AppUtil.getScreenWidth(context),
                child: Row(
                  children: pageViewIndicators,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
          )*/
        ],
      ),
    );
  }
}

class PageViewIndicator extends StatelessWidget {
  final int currentIndex;
  final int index;

  const PageViewIndicator({Key key, this.currentIndex, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
      opacity: index == currentIndex ? 1.0 : 0.8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
        height: index == currentIndex ? 10 : 7,
        width: index == currentIndex ? 10 : 7,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                color: Colors.black,
                spreadRadius: 0,
                blurRadius: 5),
          ],
        ),
      ),
    );
  }
}
