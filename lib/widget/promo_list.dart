import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class AdsListWidget extends StatefulWidget {
  final List<Ads> adsList;

  const AdsListWidget({Key key, this.adsList}) : super(key: key);

  @override
  _AdsListWidgetState createState() => _AdsListWidgetState();
}

class _AdsListWidgetState extends State<AdsListWidget> {
  PageController _pageController;
  double _adsOffset;
  Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: viewport);

    _timer = Timer.periodic(Duration(seconds: 4), (t) {
      _currentIndex++;
      _pageController.animateToPage(_currentIndex % widget.adsList.length,
          duration: Duration(milliseconds: 700), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adsOffset = -((1 - viewport) * MediaQuery.of(context).size.width / 2 - horizontalPaddingDraggable);
    return PageView.builder(
        controller: _pageController,
        onPageChanged: (i) {
          _currentIndex = i % widget.adsList.length;
        },
        pageSnapping: true,
        itemCount: widget.adsList.length,
        itemBuilder: (context, i) {
          return Transform.translate(
            offset: Offset(_adsOffset, 0),
            child: AdsWidget(
              ads: widget.adsList[i],
            ),
          );
        });
  }
}

class AdsWidget extends StatelessWidget {
  final Ads ads;

  const AdsWidget({Key key, this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showMaterialModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
            context: context,
            builder: (context, controller) {
              return Container(
                padding:
                    EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable, vertical: horizontalPaddingDraggable),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: CachedNetworkImage(
                    imageUrl: ads.thumbnail,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                          child: Container(
                            height: 60,
                            color: Colors.black,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100]);
                    },
                  ),
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        height: 60,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.black26, spreadRadius: 0, blurRadius: 5)],
            borderRadius: BorderRadius.circular(20),
            color: Colors.red[700]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: ads.thumbnail,
            height: 60,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            placeholder: (context, url) {
              return Shimmer.fromColors(
                  child: Container(
                    height: 60,
                    color: Colors.black,
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100]);
            },
          ),
        ),
      ),
    );
  }
}
