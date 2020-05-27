import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyereats/bloc/food/detail_page_bloc.dart';
import 'package:flyereats/bloc/food/detail_page_event.dart';
import 'package:flyereats/bloc/food/detail_page_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/page/restaurant_place_order_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/food_list.dart';
import 'package:flyereats/widget/place_order_bottom_navbar.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({Key key, this.restaurant}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with TickerProviderStateMixin {
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  PageController _rankPageController;
  Timer _timer;
  FoodCart _foodCart = FoodCart(Map<int, FoodCartItem>());

  bool _isListMode = true;
  bool _isVegOnly = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _rankPageController = PageController();
    int i = 0;
    _timer = Timer.periodic(Duration(seconds: 3), (t) {
      i++;
      _rankPageController.animateToPage(i % 2,
          duration: Duration(milliseconds: 700), curve: Curves.ease);
    });

    BlocProvider.of<DetailPageBloc>(context).add(PageDetailRestaurantOpen());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _rankPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double offset = MediaQuery.of(context).padding.top;

    return BlocBuilder<DetailPageBloc, DetailPageState>(
      builder: (context, state) {
        if (state is CartState) {
          _foodCart = state.cart;
        }

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: AnimatedBuilder(
            animation: _navBarAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: _navBarAnimation.value,
                child: child,
              );
            },
            child: BlocBuilder<DetailPageBloc, DetailPageState>(
              builder: (context, state) {
                return OrderBottomNavBar(
                  isValid: _foodCart.cart.length > 0 ? true : false,
                  description: "Items",
                  showRupee: false,
                  amount: _foodCart.cart.length,
                  buttonText: "CHECK OUT",
                  onButtonTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RestaurantPlaceOrderPage(
                        foodCart: _foodCart,
                        restaurant: widget.restaurant,
                      );
                    }));
                  },
                );
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: AppUtil.getScreenWidth(context),
                    height: AppUtil.getBannerHeight(context),
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: CachedNetworkImage(
                          imageUrl: widget.restaurant.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        )),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.black54),
                width: AppUtil.getScreenWidth(context),
                height: AppUtil.getBannerHeight(context),
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: CustomAppBar(
                      leading: "assets/back.svg",
                      drawer: "assets/drawer.svg",
                      title: "Vascon Venus",
                      onTapLeading: () {
                        Navigator.pop(context);
                      },
                      onTapDrawer: () {},
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                initialChildSize: (AppUtil.getScreenHeight(context) -
                        AppUtil.getToolbarHeight(context)) /
                    AppUtil.getScreenHeight(context),
                minChildSize: (AppUtil.getScreenHeight(context) -
                        AppUtil.getToolbarHeight(context)) /
                    AppUtil.getScreenHeight(context),
                maxChildSize: 1.0,
                builder: (context, controller) {
                  controller.addListener(() {
                    if (controller.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                      if (!_isScrollingDown) {
                        _isScrollingDown = true;
                        setState(() {
                          _animationController.forward().orCancel;
                        });
                      }
                    }
                    if ((controller.position.userScrollDirection ==
                            ScrollDirection.forward) |
                        (controller.offset >=
                                controller.position.maxScrollExtent -
                                    kBottomNavigationBarHeight &&
                            !controller.position.outOfRange)) {
                      if (_isScrollingDown) {
                        _isScrollingDown = false;
                        setState(() {
                          _animationController.reverse().orCancel;
                        });
                      }
                    }
                  });
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            topLeft: Radius.circular(32))),
                    child: CustomScrollView(
                      controller: controller,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Transform.translate(
                            offset: Offset(0, 20),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                      bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.restaurant.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(1, 1),
                                                  spreadRadius: -1,
                                                  blurRadius: 4)
                                            ],
                                            border: Border.all(
                                                color: Colors.orange)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                              widget.restaurant.review,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(32),
                                          topRight: Radius.circular(32))),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: horizontalPaddingDraggable),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget.restaurant.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                      Container(
                                        height: 15,
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: PageView(
                                          controller: _rankPageController,
                                          scrollDirection: Axis.vertical,
                                          children: <Widget>[
                                            Text(
                                              "100+ ratings",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "#1 Rank",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: horizontalPaddingDraggable),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget.restaurant.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        widget.restaurant.location,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                widget.restaurant.discountDescription != null
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600]),
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.restaurant.discountDescription,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  height: 20,
                                  color: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable,
                                        top: distanceSectionContent),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: DetailRestaurantFilterTabs(
                            onTabTap: (index) {
                              /*_bloc
                                  .add(ChangeQuantity(0, Food("title", "description", "price", "image", true), 5));*/
                            },
                            offset: offset,
                            isListSelected: _isListMode,
                            onListButtonTap: () {
                              setState(
                                () {
                                  if (!_isListMode) {
                                    _isListMode = true;
                                  }
                                },
                              );
                            },
                            onGridButtonTap: () {
                              setState(
                                () {
                                  if (_isListMode) {
                                    _isListMode = false;
                                  }
                                },
                              );
                            },
                            onSwitchChanged: (value) {
                              BlocProvider.of<DetailPageBloc>(context)
                                  .add(SwitchVegOnly(value));
                              setState(() {
                                _isVegOnly = value;
                              });
                            },
                            isVegOnly: _isVegOnly,
                            size: 27,
                            tabController: TabController(
                                length: 5, vsync: this, initialIndex: 0),
                          ),
                        ),
                        FoodListWidget(
                          padding: _isListMode
                              ? EdgeInsets.only(
                                  left: horizontalPaddingDraggable - 5,
                                  right: horizontalPaddingDraggable - 5,
                                  top: 10,
                                  bottom: kBottomNavigationBarHeight)
                              : EdgeInsets.only(
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable,
                                  top: 10,
                                  bottom: 10 + kBottomNavigationBarHeight),
                          cart: _foodCart,
                          listFood: ExampleModel.getFoods(),
                          type: _isListMode
                              ? FoodListViewType.list
                              : FoodListViewType.grid,
                          scale: 0.90,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailRestaurantFilterTabs extends SliverPersistentHeaderDelegate {
  final Function onListButtonTap;
  final Function onGridButtonTap;
  final bool isListSelected;
  final double size;
  final bool isVegOnly;
  final Function(bool) onSwitchChanged;
  final TabController tabController;
  final double offset;
  final Function(int) onTabTap;

  DetailRestaurantFilterTabs({
    this.onListButtonTap,
    this.onGridButtonTap,
    this.isListSelected,
    this.size,
    this.isVegOnly,
    this.onSwitchChanged,
    this.tabController,
    this.offset,
    this.onTabTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
            left: horizontalPaddingDraggable,
            right: horizontalPaddingDraggable,
            top: offset),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Veg Only",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: CupertinoSwitch(
                      value: isVegOnly,
                      onChanged: onSwitchChanged,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                /*Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.filter_list,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Filter",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),*/
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    "assets/search.svg",
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: size,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: onListButtonTap,
                        child: AnimatedContainer(
                          width: size,
                          height: size,
                          padding: EdgeInsets.all(7),
                          child: SvgPicture.asset(
                            "assets/list.svg",
                            color: isListSelected ? Colors.white : Colors.grey,
                          ),
                          decoration: BoxDecoration(
                              color: isListSelected
                                  ? Colors.green
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6)),
                          duration: Duration(milliseconds: 300),
                        ),
                      ),
                      GestureDetector(
                        onTap: onGridButtonTap,
                        child: AnimatedContainer(
                          width: size,
                          height: size,
                          padding: EdgeInsets.all(7),
                          child: SvgPicture.asset(
                            "assets/grid.svg",
                            color: !isListSelected ? Colors.white : Colors.grey,
                          ),
                          decoration: BoxDecoration(
                              color: !isListSelected
                                  ? Colors.green
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6)),
                          duration: Duration(milliseconds: 300),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                onTap: onTabTap,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black26,
                indicatorColor: Colors.yellow[600],
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorPadding:
                    EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
                labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
                tabs: <Widget>[
                  Tab(
                    text: "Best Selling",
                  ),
                  Tab(
                    text: "Breakfast",
                  ),
                  Tab(
                    text: "Dinner",
                  ),
                  Tab(
                    text: "Lunch",
                  ),
                  Tab(
                    text: "Snacks Time",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
