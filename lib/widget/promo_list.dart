import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/promo.dart';
import 'package:shimmer/shimmer.dart';

class PromoListWidget extends StatefulWidget {
  final List<Promo> promoList;

  const PromoListWidget({Key key, this.promoList}) : super(key: key);

  @override
  _PromoListWidgetState createState() => _PromoListWidgetState();
}

class _PromoListWidgetState extends State<PromoListWidget> {
  PageController _pageController;
  double _promoOffset;
  Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, viewportFraction: viewport);

    _timer = Timer.periodic(Duration(seconds: 4), (t) {
      _currentIndex++;
      _pageController.animateToPage(_currentIndex % widget.promoList.length,
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
    _promoOffset = -((1 - viewport) * MediaQuery.of(context).size.width / 2 -
        horizontalPaddingDraggable);
    return PageView.builder(
        controller: _pageController,
        onPageChanged: (i) {
          _currentIndex = i % widget.promoList.length;
        },
        pageSnapping: true,
        itemCount: widget.promoList.length,
        itemBuilder: (context, i) {
          return Transform.translate(
            offset: Offset(_promoOffset, 0),
            child: PromoWidget(
              promo: widget.promoList[i],
            ),
          );
        });
  }
}

class PromoWidget extends StatelessWidget {
  final Promo promo;

  const PromoWidget({Key key, this.promo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      height: 60,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(2, 2),
            color: Colors.black26,
            spreadRadius: 0,
            blurRadius: 5)
      ], borderRadius: BorderRadius.circular(20), color: Colors.red[700]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: promo.image,
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
    );
  }
}
