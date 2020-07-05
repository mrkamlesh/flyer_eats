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
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/page/restaurant_place_order_page.dart';
import 'package:flyereats/page/review_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:flyereats/widget/food_list.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;
  final Location location;

  const RestaurantDetailPage({Key key, this.restaurant, this.location}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> with TickerProviderStateMixin {
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  PageController _rankPageController;
  Timer _timer;

  bool _isListMode = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _rankPageController = PageController();
    int i = 0;
    _timer = Timer.periodic(Duration(seconds: 3), (t) {
      i++;
      _rankPageController.animateToPage(i % 2, duration: Duration(milliseconds: 700), curve: Curves.ease);
    });
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

    return BlocProvider<DetailPageBloc>(
      create: (context) {
        return DetailPageBloc()..add(PageDetailRestaurantOpen(widget.restaurant.id));
      },
      child: BlocBuilder<DetailPageBloc, DetailPageState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              _onBackPressed(state.foodCart.cartItemNumber());
              return true;
            },
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              endDrawer: EndDrawer(),
              bottomNavigationBar: AnimatedBuilder(
                animation: _navBarAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _navBarAnimation.value,
                    child: child,
                  );
                },
                child: RestaurantDetailBottomNavBar(
                  isValid: state.foodCart.cartItemNumber() > 0 ? true : false,
                  totalAmount: state.foodCart.getAmount(),
                  totalItem: state.foodCart.cartItemNumber(),
                  buttonText: "CHECK OUT",
                  onButtonTap: () async {
                    FoodCart newCart = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RestaurantPlaceOrderPage(
                        foodCart: state.foodCart,
                        restaurant: widget.restaurant,
                        location: widget.location,
                      );
                    }));

                    BlocProvider.of<DetailPageBloc>(context).add(UpdateCart(newCart));
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
                        child: Builder(
                          builder: (context) {
                            return CustomAppBar(
                              leading: "assets/back.svg",
                              drawer: "assets/drawer.svg",
                              title: widget.location.address,
                              onTapLeading: () {
                                _onBackPressed(state.foodCart.cartItemNumber());
                              },
                              onTapDrawer: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                        AppUtil.getScreenHeight(context),
                    minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                        AppUtil.getScreenHeight(context),
                    maxChildSize: 1.0,
                    builder: (context, controller) {
                      controller.addListener(() {
                        if (controller.position.userScrollDirection == ScrollDirection.reverse) {
                          if (!_isScrollingDown) {
                            _isScrollingDown = true;
                            setState(() {
                              _animationController.forward().orCancel;
                            });
                          }
                        }
                        if ((controller.position.userScrollDirection == ScrollDirection.forward) |
                            (controller.offset >= controller.position.maxScrollExtent - kBottomNavigationBarHeight &&
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
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              widget.restaurant.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return ReviewPage(
                                                  restaurant: widget.restaurant,
                                                );
                                              }));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black38,
                                                        offset: Offset(1, 1),
                                                        spreadRadius: -1,
                                                        blurRadius: 4)
                                                  ],
                                                  border: Border.all(color: Colors.orange)),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: horizontalPaddingDraggable),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              widget.restaurant.cuisine,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12, color: Colors.black54),
                                            ),
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
                                      decoration: BoxDecoration(color: Colors.white),
                                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: horizontalPaddingDraggable),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              widget.restaurant.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12, color: Colors.black54),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            widget.restaurant.deliveryEstimation,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    widget.restaurant.discountDescription != null &&
                                            widget.restaurant.discountDescription != ""
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                              left: horizontalPaddingDraggable,
                                              right: horizontalPaddingDraggable,
                                            ),
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: Colors.yellow[600]),
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            child: Text(
                                              AppUtil.parseHtmlString(widget.restaurant.discountDescription),
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                                widget.restaurant.id,
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
                                  BlocProvider.of<DetailPageBloc>(context).add(SwitchVegOnly(value));
                                },
                                isVegOnly: state.isVegOnly,
                                size: 27,
                              ),
                            ),
                            BlocConsumer<DetailPageBloc, DetailPageState>(
                              listener: (context, state) {
                                if (state is CartState) {
                                  _isScrollingDown = false;
                                  _animationController.reverse().orCancel;
                                }
                              },
                              builder: (context, state) {
                                if (state is OnDataLoading) {
                                  return _isListMode ? FoodListLoadingWidget() : FoodGridLoadingWidget();
                                } else if (state is NoFoodAvailable) {
                                  return SliverToBoxAdapter(
                                    child: Container(
                                        padding: EdgeInsets.all(horizontalPaddingDraggable),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SvgPicture.asset(
                                              "assets/no food.svg",
                                              height: AppUtil.getScreenHeight(context) / 5,
                                              width: AppUtil.getScreenHeight(context) / 5,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "No Food Available",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                  );
                                }
                                return FoodListWidget(
                                  onAdd: (i) {
                                    BlocProvider.of<DetailPageBloc>(context).add(ChangeQuantity(state.foodList[i].id,
                                        state.foodList[i], (state.foodCart.getQuantity(state.foodList[i].id) + 1)));
                                  },
                                  onRemove: (i) {
                                    BlocProvider.of<DetailPageBloc>(context).add(ChangeQuantity(state.foodList[i].id,
                                        state.foodList[i], (state.foodCart.getQuantity(state.foodList[i].id) - 1)));
                                  },
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
                                          bottom: 20 + kBottomNavigationBarHeight),
                                  cart: state.foodCart,
                                  listFood: state.foodList,
                                  type: _isListMode ? FoodListViewType.list : FoodListViewType.grid,
                                  scale: 0.90,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _onBackPressed(int cartItemNumber) {
    if (cartItemNumber > 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                "Cancel Order?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Would you like to cancel order?",
                style: TextStyle(color: Colors.black54),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("YES")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("NO")),
              ],
            );
          },
          barrierDismissible: true);
    } else {
      Navigator.pop(context);
    }
  }
}

class RestaurantDetailBottomNavBar extends StatelessWidget {
  final int totalItem;
  final String buttonText;
  final Function onButtonTap;
  final bool isValid;
  final double totalAmount;

  const RestaurantDetailBottomNavBar({
    Key key,
    this.totalItem,
    this.buttonText,
    this.onButtonTap,
    this.isValid,
    this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: AppUtil.getScreenWidth(context),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.yellow[600]))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Items",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$totalItem",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: VerticalDivider(
                    color: Colors.black38,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: SvgPicture.asset(
                        "assets/rupee.svg",
                        width: 13,
                        height: 13,
                      ),
                    ),
                    Text(
                      "${AppUtil.doubleRemoveZeroTrailing(totalAmount)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
            onTap: isValid ? onButtonTap : () {},
            child: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellow[600], borderRadius: BorderRadius.only(topLeft: Radius.circular(18))),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isValid ? 0.0 : 0.65,
                    child: Container(
                      color: Colors.white,
                    ),
                    duration: Duration(milliseconds: 300),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class DetailRestaurantFilterTabs extends SliverPersistentHeaderDelegate {
  final String restaurantId;
  final Function onListButtonTap;
  final Function onGridButtonTap;
  final bool isListSelected;
  final double size;
  final bool isVegOnly;
  final Function(bool) onSwitchChanged;
  final double offset;

  DetailRestaurantFilterTabs(
    this.restaurantId, {
    this.onListButtonTap,
    this.onGridButtonTap,
    this.isListSelected,
    this.size,
    this.isVegOnly,
    this.onSwitchChanged,
    this.offset,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.only(left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, top: offset),
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
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
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
                              color: isListSelected ? Colors.green : Colors.grey[100],
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
                              color: !isListSelected ? Colors.green : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6)),
                          duration: Duration(milliseconds: 300),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            BlocBuilder<DetailPageBloc, DetailPageState>(
              builder: (context, state) {
                List<Tab> tabs = List();
                for (int i = 0; i < state.menuCategories.length; i++) {
                  tabs.add(Tab(
                    text: state.menuCategories[i].name,
                  ));
                }

                return DefaultTabController(
                  length: state.menuCategories.length,
                  initialIndex: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      onTap: (i) {
                        BlocProvider.of<DetailPageBloc>(context)
                            .add(RestaurantMenuChange(restaurantId, state.menuCategories[i].id));
                      },
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black26,
                      indicatorColor: Colors.yellow[600],
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      indicatorPadding: EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
                      labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
                      tabs: tabs,
                    ),
                  ),
                );
              },
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
