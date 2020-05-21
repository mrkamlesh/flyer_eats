import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/page/restaurant_detail_page.dart';
import 'package:shimmer/shimmer.dart';

enum RestaurantViewType { home, detailList, detailGrid }

class RestaurantListWidget extends StatefulWidget {
  final List<Restaurant> restaurants;
  final bool isExpand;
  final double scale;
  final double fade;
  final RestaurantViewType type;

  const RestaurantListWidget({
    Key key,
    this.restaurants,
    this.isExpand = false,
    this.scale = 0.95,
    this.fade = 0.4,
    this.type,
  }) : super(key: key);

  @override
  _RestaurantListWidgetState createState() => _RestaurantListWidgetState();
}

class _RestaurantListWidgetState extends State<RestaurantListWidget>
    with SingleTickerProviderStateMixin {
  int _selectedTopRestaurant = -1;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _fadeAnimation = Tween<double>(begin: 0.0, end: widget.fade).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case RestaurantViewType.home:
        return ListView.builder(
          itemCount: widget.restaurants.length + 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return i == 0
                ? SizedBox(
                    width: horizontalPaddingDraggable,
                  )
                : RestaurantHomeWidget(
                    index: i - 1,
                    selectedIndex: _selectedTopRestaurant,
                    scale: _scaleAnimation,
                    fade: _fadeAnimation,
                    isExpand: widget.isExpand,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i - 1;
                        _animationController
                            .forward()
                            .orCancel
                            .whenComplete(() {
                          _animationController
                              .reverse()
                              .orCancel
                              .whenComplete(() {
                            _navigateToRestaurantDetailPage(
                                widget.restaurants[i - 1]);
                          });
                        });
                      });
                    },
                    restaurant: widget.restaurants[i - 1],
                  );
          },
        );
      case RestaurantViewType.detailList:
        return SliverPadding(
          padding: EdgeInsets.only(
              left: horizontalPaddingDraggable,
              right: horizontalPaddingDraggable,
              top: distanceSectionContent,
              bottom: distanceSectionContent + kBottomNavigationBarHeight),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return RestaurantDetailListWidget(
                restaurant: widget.restaurants[i],
                index: i,
                selectedIndex: _selectedTopRestaurant,
                onTap: () {
                  setState(() {
                    _selectedTopRestaurant = i;
                    _animationController.forward().orCancel.whenComplete(() {
                      _animationController.reverse().orCancel.whenComplete(() {
                        _navigateToRestaurantDetailPage(widget.restaurants[i]);
                      });
                    });
                  });
                },
                scale: _scaleAnimation,
              );
            }, childCount: widget.restaurants.length),
          ),
        );
      case RestaurantViewType.detailGrid:
        return SliverPadding(
          padding: EdgeInsets.only(
              left: horizontalPaddingDraggable,
              right: horizontalPaddingDraggable,
              top: distanceSectionContent,
              bottom: distanceSectionContent + kBottomNavigationBarHeight),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, i) {
              return RestaurantDetailGridWidget(
                restaurant: widget.restaurants[i],
                index: i,
                selectedIndex: _selectedTopRestaurant,
                onTap: () {
                  setState(() {
                    _selectedTopRestaurant = i;
                    _animationController.forward().orCancel.whenComplete(() {
                      _animationController.reverse().orCancel.whenComplete(() {
                        _navigateToRestaurantDetailPage(widget.restaurants[i]);
                      });
                    });
                  });
                },
                scale: _scaleAnimation,
              );
            }, childCount: widget.restaurants.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (AppUtil.getScreenWidth(context) / 2) / 220,
            ),
          ),
        );
      default:
        return Container();
    }
  }

  void _navigateToRestaurantDetailPage(Restaurant restaurant) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RestaurantDetailPage(
        restaurant: restaurant,
      );
    }));
  }
}

class RestaurantDetailGridWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const RestaurantDetailGridWidget(
      {Key key,
      this.restaurant,
      this.index,
      this.selectedIndex,
      this.onTap,
      this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gridWidth = (AppUtil.getScreenWidth(context) - 50) / 2;
    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(2, 3))
            ]),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.image,
                    height: 100,
                    width: (AppUtil.getScreenWidth(context) - 50) / 2,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                          child: Container(
                            height: 100,
                            width: gridWidth,
                            color: Colors.black,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100]);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    restaurant.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        restaurant.location,
                        style: TextStyle(fontSize: 11, color: Colors.black),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          Text(
                            restaurant.review,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            restaurant.discountTitle != null
                ? Positioned(
                    top: 10,
                    left: -22,
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.yellow),
                        width: 90,
                        height: 25,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "30 % OFF",
                              style: TextStyle(fontSize: 12),
                            )),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
    return selectedIndex == index
        ? AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform.scale(
                scale: scale.value,
                child: child,
              );
            },
            child: restaurantWidget,
          )
        : restaurantWidget;
  }
}

class RestaurantDetailListWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const RestaurantDetailListWidget({
    Key key,
    this.restaurant,
    this.index,
    this.selectedIndex,
    this.onTap,
    this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(2, 3))
            ]),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.image,
                      height: 80,
                      width: 80,
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
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                restaurant.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    size: 8,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    restaurant.review,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            restaurant.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                restaurant.location,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black),
                              ),
                              restaurant.discountDescription != null
                                  ? Expanded(
                                      child: Text(
                                        restaurant.discountDescription,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            restaurant.discountTitle != null
                ? Positioned(
                    top: 10,
                    left: -22,
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.yellow),
                        width: 90,
                        height: 25,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "30 % OFF",
                              style: TextStyle(fontSize: 12),
                            )),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
    return selectedIndex == index
        ? AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform.scale(
                scale: scale.value,
                child: child,
              );
            },
            child: restaurantWidget,
          )
        : restaurantWidget;
  }
}

class RestaurantHomeWidget extends StatelessWidget {
  final Restaurant restaurant;
  final bool isExpand;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;
  final Animation<double> fade;

  const RestaurantHomeWidget(
      {Key key,
      this.restaurant,
      this.isExpand = false,
      this.index,
      this.selectedIndex,
      this.onTap,
      this.scale,
      this.fade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.image,
                    height: isExpand ? 160 : 80,
                    width: isExpand ? 160 : 80,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                          child: Container(
                            height: isExpand ? 160 : 80,
                            width: isExpand ? 160 : 80,
                            color: Colors.black,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100]);
                    },
                  ),
                ),
              ),
              selectedIndex == index
                  ? Align(
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: fade,
                        builder: (context, child) {
                          return Opacity(
                            opacity: fade.value,
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16)),
                          height: isExpand ? 160 : 80,
                          width: isExpand ? 160 : 80,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            restaurant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isExpand ? 16 : 14),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                restaurant.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: isExpand ? 13 : 12, color: Colors.black54),
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: isExpand ? 13 : 12,
                    color: Colors.black54,
                  ),
                  Text(
                    restaurant.review,
                    style: TextStyle(
                      fontSize: isExpand ? 13 : 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );

    return selectedIndex == index
        ? AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform.scale(
                scale: scale.value,
                child: child,
              );
            },
            child: Container(
              width: isExpand ? 160 : 80,
              height: 150,
              margin: EdgeInsets.only(right: distanceBetweenItem),
              child: restaurantWidget,
            ),
          )
        : Container(
            width: isExpand ? 160 : 80,
            height: 150,
            margin: EdgeInsets.only(right: distanceBetweenItem),
            child: restaurantWidget,
          );
  }
}
