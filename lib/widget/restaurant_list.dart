import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/restaurantlist/restaurantlist_bloc.dart';
import 'package:clients/bloc/restaurantlist/restaurantlist_state.dart';
import 'package:clients/bloc/search/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/page/restaurant_detail_page.dart';
import 'package:shimmer/shimmer.dart';

enum RestaurantViewType {
  topRestaurant,
  orderAgainRestaurant,
  dinnerTimeRestaurant,
  detailList,
  detailGrid,
  searchResult,
  offerpage
}

class RestaurantListWidget extends StatefulWidget {
  final List<Restaurant> restaurants;
  final Location location;
  final bool isExpand;
  final double scale;
  final double fade;
  final RestaurantViewType type;

  const RestaurantListWidget({
    Key key,
    this.restaurants,
    this.isExpand = false,
    this.scale = 0.95,
    this.fade = 0.3,
    this.type,
    this.location,
  }) : super(key: key);

  @override
  _RestaurantListWidgetState createState() => _RestaurantListWidgetState();
}

class _RestaurantListWidgetState extends State<RestaurantListWidget> with SingleTickerProviderStateMixin {
  int _selectedTopRestaurant = -1;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case RestaurantViewType.topRestaurant:
        return ListView.builder(
          itemCount: widget.restaurants.length + 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return i == 0
                ? SizedBox(
                    width: horizontalPaddingDraggable,
                  )
                : TopRestaurantHomeWidget(
                    index: i - 1,
                    selectedIndex: _selectedTopRestaurant,
                    scale: _scaleAnimation,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i - 1;
                        if (widget.restaurants[i - 1].isOpen) {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController.reverse().orCancel.whenComplete(() {
                              _navigateToRestaurantDetailPage(widget.restaurants[i - 1]);
                            });
                          });
                        } else {
                          _showAlertDialog();
                        }
                      });
                    },
                    restaurant: widget.restaurants[i - 1],
                  );
          },
        );
      case RestaurantViewType.orderAgainRestaurant:
        return PageView.builder(
          itemBuilder: (context, i) {
            return RestaurantDetailListWidget(
              restaurant: widget.restaurants[i],
              index: i,
              selectedIndex: _selectedTopRestaurant,
              onTap: () {
                setState(() {
                  _selectedTopRestaurant = i;
                  if (widget.restaurants[i].isOpen) {
                    _animationController.forward().orCancel.whenComplete(() {
                      _animationController.reverse().orCancel.whenComplete(() {
                        _navigateToRestaurantDetailPage(widget.restaurants[i]);
                      });
                    });
                  } else {
                    _showAlertDialog();
                  }
                });
              },
              scale: _scaleAnimation,
            );
          },
          itemCount: widget.restaurants.length,
        );
      case RestaurantViewType.dinnerTimeRestaurant:
        return ListView.builder(
          itemCount: widget.restaurants.length + 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return i == 0
                ? SizedBox(
                    width: horizontalPaddingDraggable,
                  )
                : DinnerRestaurantHomeWidget(
                    index: i - 1,
                    selectedIndex: _selectedTopRestaurant,
                    scale: _scaleAnimation,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i - 1;
                        if (widget.restaurants[i - 1].isOpen) {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController.reverse().orCancel.whenComplete(() {
                              _navigateToRestaurantDetailPage(widget.restaurants[i - 1]);
                            });
                          });
                        } else {
                          _showAlertDialog();
                        }
                      });
                    },
                    restaurant: widget.restaurants[i - 1],
                  );
          },
        );
      case RestaurantViewType.detailList:
        return BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            if (state.restaurants.isEmpty && state.isLoading) {
              return SliverToBoxAdapter(
                child: Container(height: AppUtil.getScreenHeight(context), child: LoadingRestaurantListWidget()),
              );
            } else if (state.restaurants.isEmpty && !state.isLoading) {
              return SliverToBoxAdapter(
                child: Container(height: AppUtil.getScreenHeight(context), child: NoRestaurantListWidget()),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.only(
                  top: distanceSectionContent - 10, bottom: distanceSectionContent + kBottomNavigationBarHeight),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (state.isLoading && i == state.restaurants.length) {
                    return Container(
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return RestaurantDetailListWidget(
                    restaurant: widget.restaurants[i],
                    index: i,
                    selectedIndex: _selectedTopRestaurant,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i;
                        if (widget.restaurants[i].isOpen) {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController.reverse().orCancel.whenComplete(() {
                              _navigateToRestaurantDetailPage(widget.restaurants[i]);
                            });
                          });
                        } else {
                          _showAlertDialog();
                        }
                      });
                    },
                    scale: _scaleAnimation,
                  );
                }, childCount: state.isLoading ? widget.restaurants.length + 1 : widget.restaurants.length),
              ),
            );
          },
        );
      case RestaurantViewType.detailGrid:
        return BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            if (state.restaurants.isEmpty && state.isLoading) {
              return SliverToBoxAdapter(
                child: Container(height: AppUtil.getScreenHeight(context), child: LoadingRestaurantListWidget()),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.only(
                  left: horizontalPaddingDraggable,
                  right: horizontalPaddingDraggable,
                  top: distanceSectionContent,
                  bottom: distanceSectionContent + kBottomNavigationBarHeight),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (state.isLoading && i == state.restaurants.length) {
                    return Container(
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return RestaurantDetailGridWidget(
                    restaurant: widget.restaurants[i],
                    index: i,
                    selectedIndex: _selectedTopRestaurant,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i;
                        if (widget.restaurants[i].isOpen) {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController.reverse().orCancel.whenComplete(() {
                              _navigateToRestaurantDetailPage(widget.restaurants[i]);
                            });
                          });
                        } else {
                          _showAlertDialog();
                        }
                      });
                    },
                    scale: _scaleAnimation,
                  );
                }, childCount: state.isLoading ? widget.restaurants.length + 1 : widget.restaurants.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: (AppUtil.getScreenWidth(context) / 2) / 260,
                ),
              ),
            );
          },
        );
      case RestaurantViewType.searchResult:
        return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return SliverPadding(
              padding: EdgeInsets.only(
                  left: horizontalPaddingDraggable,
                  right: horizontalPaddingDraggable,
                  top: distanceSectionContent,
                  bottom: distanceSectionContent + kBottomNavigationBarHeight),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (state is LoadingMore && i == state.restaurants.length) {
                    return Container(
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return RestaurantDetailGridWidget(
                    restaurant: widget.restaurants[i],
                    index: i,
                    selectedIndex: _selectedTopRestaurant,
                    onTap: () {
                      setState(() {
                        _selectedTopRestaurant = i;
                        if (widget.restaurants[i].isOpen) {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController.reverse().orCancel.whenComplete(() {
                              _navigateToRestaurantDetailPage(widget.restaurants[i]);
                            });
                          });
                        } else {
                          _showAlertDialog();
                        }
                      });
                    },
                    scale: _scaleAnimation,
                  );
                }, childCount: (state is LoadingMore) ? widget.restaurants.length + 1 : widget.restaurants.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: (AppUtil.getScreenWidth(context) / 2) / 260,
                ),
              ),
            );
          },
        );
      case RestaurantViewType.offerpage:
        return SliverPadding(
          padding: EdgeInsets.only(
              top: distanceSectionContent - 10, bottom: distanceSectionContent + kBottomNavigationBarHeight),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return RestaurantDetailListWidget(
                restaurant: widget.restaurants[i],
                index: i,
                selectedIndex: _selectedTopRestaurant,
                onTap: () {
                  setState(() {
                    _selectedTopRestaurant = i;
                    if (widget.restaurants[i].isOpen) {
                      _animationController.forward().orCancel.whenComplete(() {
                        _animationController.reverse().orCancel.whenComplete(() {
                          _navigateToRestaurantDetailPage(widget.restaurants[i]);
                        });
                      });
                    } else {
                      _showAlertDialog();
                    }
                  });
                },
                scale: _scaleAnimation,
              );
            }, childCount: widget.restaurants.length),
          ),
        );
      default:
        return Container();
    }
  }

  void _navigateToRestaurantDetailPage(Restaurant restaurant) {
    Navigator.push(context, MaterialPageRoute<RestaurantDetailPage>(builder: (context) {
      return RestaurantDetailPage(
        restaurant: restaurant,
        location: widget.location,
      );
    }));
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              "Closed!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text("Restaurant is closed"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }
}

class RestaurantDetailGridWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const RestaurantDetailGridWidget({Key key, this.restaurant, this.index, this.selectedIndex, this.onTap, this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gridWidth = (AppUtil.getScreenWidth(context) - 50) / 2;
    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: restaurant.isOpen ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 7,
              spreadRadius: -3,
            )
          ]),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.image,
                      height: 100,
                      width: gridWidth,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 7),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              restaurant.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, left: 10, bottom: 7),
                          child: Text(
                            restaurant.cuisine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, color: Colors.black45),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            height: 0.1,
                            color: Colors.black26,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                            right: 10,
                            left: 10,
                            top: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    restaurant.deliveryEstimation,
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: primary3,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    restaurant.rating.rating,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              restaurant.discountTitle != null && restaurant.discountTitle != ""
                  ? Positioned(
                      top: 7,
                      left: -5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 25,
                            decoration: BoxDecoration(
                                color: primary1,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    topRight: Radius.circular(2),
                                    bottomRight: Radius.circular(2))),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(4),
                            child: Text(
                              AppUtil.parseHtmlString(restaurant.discountTitle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          CustomPaint(
                            size: Size(5, 5),
                            painter: RestaurantTrianglePainter(),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
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
      child: Opacity(
        opacity: restaurant.isOpen ? 1.0 : 0.3,
        child: Container(
          height: 150,
          width: 110,
          margin:
              EdgeInsets.only(bottom: 10, top: 10, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 30,
                spreadRadius: -20,
              ),
              BoxShadow(
                color: shadow,
                blurRadius: 8,
                spreadRadius: -4,
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.image,
                        height: 150,
                        width: 110,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                              child: Container(
                                height: 150,
                                width: 110,
                                color: Colors.black,
                              ),
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100]);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      padding: EdgeInsets.only(top: 12, bottom: 12, right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Column(
                                mainAxisAlignment: restaurant.discountDescription != null
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          restaurant.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: Text(
                                      restaurant.cuisine,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Colors.black45),
                                    ),
                                  ),
                                  restaurant.discountDescription != null && restaurant.discountDescription != ""
                                      ? Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              "assets/discount2.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                AppUtil.parseHtmlString(restaurant.discountDescription),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: primary3,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.1,
                            color: Colors.black26,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            child: restaurant.isOpen
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            restaurant.deliveryEstimation != null ? restaurant.deliveryEstimation : "",
                                            style: TextStyle(fontSize: 12, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            size: 12,
                                            color: primary3,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            restaurant.rating.rating,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Not available now",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

class TopRestaurantHomeWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const TopRestaurantHomeWidget({Key key, this.restaurant, this.index, this.selectedIndex, this.onTap, this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gridWidth = 150;

    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: restaurant.isOpen ? 1.0 : 0.3,
        child: Container(
          width: gridWidth,
          height: 160,
          margin: EdgeInsets.only(right: 20, bottom: 5),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 7,
              spreadRadius: -3,
            )
          ]),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.image,
                      height: 100,
                      width: gridWidth,
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        restaurant.name + "\n",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              restaurant.discountTitle != null && restaurant.discountTitle != ""
                  ? Positioned(
                      top: 7,
                      left: -5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 25,
                            decoration: BoxDecoration(
                                color: primary1,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    topRight: Radius.circular(2),
                                    bottomRight: Radius.circular(2))),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(4),
                            child: Text(
                              AppUtil.parseHtmlString(restaurant.discountTitle),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          CustomPaint(
                            size: Size(5, 5),
                            painter: RestaurantTrianglePainter(),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
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

class DinnerRestaurantHomeWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const DinnerRestaurantHomeWidget({
    Key key,
    this.restaurant,
    this.index,
    this.selectedIndex,
    this.onTap,
    this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gridWidth = 150;

    Widget restaurantWidget = GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: restaurant.isOpen ? 1.0 : 0.3,
        child: Container(
          width: gridWidth,
          height: 160,
          margin: EdgeInsets.only(right: 20, bottom: 5),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 7,
              spreadRadius: -3,
            )
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: restaurant.image,
                  height: 100,
                  width: gridWidth,
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 7),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            restaurant.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      restaurant.discountDescription != null
                          ? Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/discount2.svg",
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    restaurant.discountDescription,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: primary3,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class RestaurantTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFFCA9312)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(5, 0);
    path.lineTo(5, 5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class LoadingRestaurantListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: distanceSectionContent - 10, bottom: distanceSectionContent + kBottomNavigationBarHeight),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
          itemBuilder: (context, i) {
            return Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  margin: EdgeInsets.only(
                      bottom: 10, top: 10, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                  height: 150,
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          },
          itemCount: 5),
    );
  }
}

class NoRestaurantListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: AppUtil.getScreenHeight(context) / 3 - AppUtil.getToolbarHeight(context),
          ),
          SvgPicture.asset(
            "assets/no merchant.svg",
            height: AppUtil.getScreenHeight(context) / 5,
            width: AppUtil.getScreenHeight(context) / 5,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "No Merchant Available",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
