import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/model/add_on.dart';
import 'package:clients/model/add_ons_type.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clients/bloc/food/detail_page_bloc.dart';
import 'package:clients/bloc/food/detail_page_event.dart';
import 'package:clients/bloc/food/detail_page_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/page/restaurant_place_order_page.dart';
import 'package:clients/page/review_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/food_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;
  final Location location;

  const RestaurantDetailPage({Key key, this.restaurant, this.location})
      : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with TickerProviderStateMixin {
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  PageController _ratingPageController = PageController();
  PageController _offersPageController = PageController();

  Timer _timer;

  bool _isListMode = true;

  DetailPageBloc _bloc;

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

    int i = 0;
    _timer = Timer.periodic(Duration(seconds: 5), (t) {
      i++;
      _ratingPageController.animateToPage(
          i % widget.restaurant.rating.getRollingText().length,
          duration: Duration(milliseconds: 700),
          curve: Curves.ease);

      _offersPageController.animateToPage(i % widget.restaurant.offers.length,
          duration: Duration(milliseconds: 700), curve: Curves.ease);
    });

    _bloc = DetailPageBloc();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _ratingPageController.dispose();
    _offersPageController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double offset = MediaQuery.of(context).padding.top;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocConsumer<FoodOrderBloc, FoodOrderState>(
          listener: (context, cartState) {
            if (cartState is ConfirmCartState) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        "Replace Cart Item?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        "Your cart contain dishes from " +
                            cartState.placeOrder.restaurant.name +
                            "  Do You want to discard the selection and add dishes from " +
                            cartState.tempSelectedRestaurant.name +
                            "?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              BlocProvider.of<FoodOrderBloc>(context)
                                ..add(ClearCart())
                                ..add(ChangeQuantityNoPayment(
                                    cartState.tempSelectedRestaurant,
                                    cartState.tempId,
                                    cartState.tempFood,
                                    cartState.tempQuantity,
                                    cartState.tempPrice,
                                    cartState.tempAddOns,
                                    true));

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
            }
          },
          builder: (context, cartState) {
            return BlocProvider<DetailPageBloc>(
              create: (context) {
                return _bloc
                  ..add(PageDetailRestaurantOpen(
                      widget.restaurant.id, widget.location.address));
              },
              child: BlocBuilder<DetailPageBloc, DetailPageState>(
                builder: (context, state) {
                  return WillPopScope(
                    onWillPop: () async {
                      //_onBackPressed(state.foodCart.cartItemNumber());
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
                        child: AnimatedCrossFade(
                          crossFadeState: widget.restaurant.id ==
                                  cartState.placeOrder.restaurant.id
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: Duration(milliseconds: 300),
                          secondChild: SizedBox(),
                          firstChild: RestaurantDetailBottomNavBar(
                            currencyIcon: AppUtil.getCurrencyIcon(
                                widget.restaurant.currencyCode),
                            isValid:
                                cartState.placeOrder.foodCart.cartItemTotal() >
                                        0
                                    ? true
                                    : false,
                            totalAmount: cartState.placeOrder.foodCart
                                .getCartTotalAmount(),
                            totalItem:
                                cartState.placeOrder.foodCart.cartItemTotal(),
                            buttonText: "CHECK OUT",
                            onButtonTap: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RestaurantPlaceOrderPage(
                                  location: widget.location,
                                  user: loginState.user,
                                );
                              }));
                            },
                          ),
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
                                        Navigator.pop(context);
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
                            initialChildSize:
                                (AppUtil.getScreenHeight(context) -
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
                                            controller
                                                    .position.maxScrollExtent -
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
                                                  left:
                                                      horizontalPaddingDraggable,
                                                  right:
                                                      horizontalPaddingDraggable,
                                                  bottom: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      widget.restaurant.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ReviewPage(
                                                          restaurant:
                                                              widget.restaurant,
                                                        );
                                                      }));
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 3),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black38,
                                                                        offset: Offset(
                                                                            1,
                                                                            1),
                                                                        spreadRadius:
                                                                            -1,
                                                                        blurRadius:
                                                                            4)
                                                                  ],
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .orange)),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.star,
                                                                size: 14,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              Text(
                                                                widget
                                                                    .restaurant
                                                                    .rating
                                                                    .rating,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .orange,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        /*SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 18,
                                                        color: Colors.black38,
                                                      )*/
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  32),
                                                          topRight:
                                                              Radius.circular(
                                                                  32))),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      widget.restaurant.cuisine,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 100,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: PageView.builder(
                                                      controller:
                                                          _ratingPageController,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: widget
                                                          .restaurant.rating
                                                          .getRollingText()
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Text(
                                                          widget
                                                              .restaurant.rating
                                                              .getRollingText()[i],
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      widget.restaurant.address,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    widget.restaurant
                                                        .deliveryEstimation,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            widget.restaurant.offers.length > 0
                                                ? Container(
                                                    height: 55,
                                                    width:
                                                        AppUtil.getScreenWidth(
                                                            context),
                                                    child: PageView.builder(
                                                      controller:
                                                          _offersPageController,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 5,
                                                            left:
                                                                horizontalPaddingDraggable,
                                                            right:
                                                                horizontalPaddingDraggable,
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                          .yellow[
                                                                      600]),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Center(
                                                            child: Text(
                                                              AppUtil.parseHtmlString(
                                                                  widget
                                                                      .restaurant
                                                                      .offers[i]),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemCount: widget
                                                          .restaurant
                                                          .offers
                                                          .length,
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              height: 20,
                                              color: Colors.white,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left:
                                                        horizontalPaddingDraggable,
                                                    right:
                                                        horizontalPaddingDraggable,
                                                    top:
                                                        distanceSectionContent),
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
                                        address: widget.location.address,
                                        onSearchTap: _onSearchTap,
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
                                          _bloc.add(SwitchVegOnly(
                                              widget.restaurant.id,
                                              value,
                                              widget.location.address));
                                        },
                                        isVegOnly: state.isVegOnly,
                                        size: 27,
                                      ),
                                    ),
                                    BlocConsumer<DetailPageBloc,
                                        DetailPageState>(
                                      listener: (context, state) {
                                        if (state is CartState) {
                                          _isScrollingDown = false;
                                          _animationController
                                              .reverse()
                                              .orCancel;
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is OnDataLoading) {
                                          return _isListMode
                                              ? FoodListLoadingWidget()
                                              : FoodGridLoadingWidget();
                                        } else if (state is NoFoodAvailable) {
                                          return SliverToBoxAdapter(
                                            child: Container(
                                                padding: EdgeInsets.all(
                                                    horizontalPaddingDraggable),
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    SvgPicture.asset(
                                                      "assets/no food.svg",
                                                      height: AppUtil
                                                              .getScreenHeight(
                                                                  context) /
                                                          5,
                                                      width: AppUtil
                                                              .getScreenHeight(
                                                                  context) /
                                                          5,
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "No Food Available",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                )),
                                          );
                                        } else if (state is OnDataError) {
                                          return SliverToBoxAdapter(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              child: Center(
                                                child: Text(
                                                  state.error,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return FoodListWidget(
                                          onAdd: (i) {
                                            _animationController
                                                .reverse()
                                                .orCancel;

                                            if (widget
                                                .restaurant.isOrderDisabled) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      title: Text(
                                                        "Disabled Ordering",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: Text(
                                                          "Order disabled by restaurant"),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("OK"))
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              if (widget.restaurant.isBusy &&
                                                  !(cartState.placeOrder
                                                      .hasShownBusyDialog(widget
                                                          .restaurant.id))) {
                                                BlocProvider.of<FoodOrderBloc>(
                                                        context)
                                                    .add(
                                                        MarkRestaurantHasShownBusyDialog(
                                                            widget.restaurant
                                                                .id));
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        title: Text(
                                                          "Add Item",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: Text(widget
                                                            .restaurant
                                                            .isBusyMessage),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("OK"))
                                                        ],
                                                      );
                                                    });
                                              }
                                              if (state
                                                  .foodList[i].isSingleItem) {
                                                BlocProvider.of<FoodOrderBloc>(
                                                        context)
                                                    .add(ChangeQuantityNoPayment(
                                                        widget.restaurant,
                                                        state.foodList[i].id,
                                                        state.foodList[i],
                                                        (cartState.placeOrder
                                                                .foodCart
                                                                .getFoodQuantity(
                                                                    state.foodList[
                                                                        i]) +
                                                            1),
                                                        state.foodList[i].price,
                                                        [],
                                                        true));
                                              } else {
                                                _showAddOnsSheet(
                                                    state.foodList[i]);
                                              }
                                            }
                                          },
                                          onRemove: (i) {
                                            _animationController
                                                .reverse()
                                                .orCancel;
                                            BlocProvider.of<FoodOrderBloc>(
                                                    context)
                                                .add(ChangeQuantityNoPayment(
                                                    widget.restaurant,
                                                    state.foodList[i].id,
                                                    state.foodList[i],
                                                    (cartState
                                                            .placeOrder.foodCart
                                                            .getFoodQuantity(
                                                                state.foodList[
                                                                    i]) -
                                                        1),
                                                    state.foodList[i].price,
                                                    [],
                                                    false));
                                          },
                                          padding: _isListMode
                                              ? EdgeInsets.only(
                                                  left:
                                                      horizontalPaddingDraggable -
                                                          5,
                                                  right:
                                                      horizontalPaddingDraggable -
                                                          5,
                                                  top: 10,
                                                  bottom:
                                                      kBottomNavigationBarHeight)
                                              : EdgeInsets.only(
                                                  left:
                                                      horizontalPaddingDraggable,
                                                  right:
                                                      horizontalPaddingDraggable,
                                                  top: 10,
                                                  bottom: 20 +
                                                      kBottomNavigationBarHeight),
                                          cart: cartState.placeOrder.foodCart,
                                          listFood: state.foodList,
                                          currencyCode:
                                              widget.restaurant.currencyCode,
                                          type: _isListMode
                                              ? FoodListViewType.list
                                              : FoodListViewType.grid,
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
          },
        );
      },
    );
  }

  _onSearchTap() {
    _bloc.add(InitializeSearch());
    showMaterialModalBottomSheet(
        backgroundColor: Colors.transparent,
        expand: false,
        duration: Duration(milliseconds: 200),
        enableDrag: true,
        context: context,
        builder: (context, controller) {
          return Container(
            height: AppUtil.getScreenHeight(context) -
                AppUtil.getToolbarHeight(context),
            width: AppUtil.getScreenWidth(context),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
            child: CustomScrollView(
              controller: controller,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 30,
                      left: horizontalPaddingDraggable,
                      right: horizontalPaddingDraggable,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "SEARCH FOOD",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear))
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 55,
                    margin: EdgeInsets.only(
                        right: horizontalPaddingDraggable,
                        left: horizontalPaddingDraggable,
                        top: 20,
                        bottom: 20),
                    padding: EdgeInsets.only(left: horizontalPaddingDraggable),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primary1),
                      boxShadow: [
                        BoxShadow(
                          color: primary1,
                          blurRadius: 7,
                          spreadRadius: -3,
                        )
                      ],
                    ),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here....",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        _bloc.add(SearchFood(widget.restaurant.id, value,
                            widget.location.address));
                      },
                    ),
                  ),
                ),
                BlocBuilder<DetailPageBloc, DetailPageState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is LoadingSearch) {
                      return SliverToBoxAdapter(
                        child: Container(
                          child: Center(
                            child: SpinKitCircle(
                              color: Colors.black38,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    } else if (state is ErrorSearch) {
                      return SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable),
                          child: Text(state.message),
                        ),
                      );
                    }
                    return state.result != null
                        ? BlocBuilder<FoodOrderBloc, FoodOrderState>(
                            builder: (context, cartState) {
                              return FoodListWidget(
                                onAdd: (i) {
                                  BlocProvider.of<FoodOrderBloc>(context).add(
                                      ChangeQuantityNoPayment(
                                          widget.restaurant,
                                          state.result[i].id,
                                          state.result[i],
                                          (cartState.placeOrder.foodCart
                                                  .getFoodQuantity(
                                                      state.result[i]) +
                                              1),
                                          state.result[i].price,
                                          [],
                                          true));
                                },
                                onRemove: (i) {
                                  BlocProvider.of<FoodOrderBloc>(context).add(
                                      ChangeQuantityNoPayment(
                                          widget.restaurant,
                                          state.result[i].id,
                                          state.result[i],
                                          (cartState.placeOrder.foodCart
                                                  .getFoodQuantity(
                                                      state.result[i]) -
                                              1),
                                          state.result[i].price,
                                          [],
                                          false));
                                },
                                padding: EdgeInsets.only(
                                    left: horizontalPaddingDraggable - 5,
                                    right: horizontalPaddingDraggable - 5,
                                    top: 10,
                                    bottom: kBottomNavigationBarHeight),
                                cart: cartState.placeOrder.foodCart,
                                listFood: state.result,
                                type: FoodListViewType.list,
                                scale: 0.90,
                                currencyCode: widget.restaurant.currencyCode,
                              );
                            },
                          )
                        : SliverToBoxAdapter(
                            child: SizedBox(),
                          );
                  },
                ),
              ],
            ),
          );
        });
  }

  _showAddOnsSheet(Food food) {
    Price price;
    Map<int, AddOn> multipleAddOns = Map();
    //Map<int, List<TextEditingController>> textControllersMap = Map();
    Map<int, int> maxNumberMap = Map();
    int quantity = 1;

    BlocProvider.of<FoodOrderBloc>(context).add(GetFoodDetail(food.id));
    showMaterialModalBottomSheet(
        duration: Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        expand: false,
        builder: (context, controller) {
          return StatefulBuilder(
            builder: (context, newState) {
              return Container(
                height: AppUtil.getScreenHeight(context) * 3 / 4,
                width: AppUtil.getScreenWidth(context),
                padding: EdgeInsets.only(top: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: BlocConsumer<FoodOrderBloc, FoodOrderState>(
                  listener: (context, cartState) {
                    if (cartState is SuccessGetFoodDetail) {
                      price = cartState.foodDetail.prices[0];
                      for (int i = 0;
                          i < cartState.foodDetail.addOnsTypes.length;
                          i++) {
                        if (cartState.foodDetail.addOnsTypes[i].options ==
                            "custom") {
                          maxNumberMap[i] =
                              cartState.foodDetail.addOnsTypes[i].maxNumber;
                        }
                        /*if (cartState.foodDetail.addOnsTypes[i].options ==
                            "multiple") {
                          textControllersMap[i] = List<TextEditingController>();
                          for (int j = 0;
                              j <
                                  cartState
                                      .foodDetail.addOnsTypes[i].addOns.length;
                              j++) {
                            TextEditingController textController =
                                TextEditingController(text: 1.toString());
                            textControllersMap[i].add(textController);
                          }
                        }*/
                      }
                    }
                  },
                  builder: (context, cartState) {
                    if (cartState is LoadingGetFoodDetail) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (cartState is ErrorGetFoodDetail) {
                      return Center(
                        child: Text(cartState.message),
                      );
                    } else if (cartState is SuccessGetFoodDetail) {
                      List<Widget> listWidget = List();
                      listWidget.add(
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                top: 10,
                                bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SIZE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ),
                      );
                      listWidget.add(SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          return RadioListTile<Price>(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        cartState.foodDetail.prices[i].size)),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppUtil.getCurrencyIcon(
                                          widget.restaurant.currencyCode),
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(width: 3),
                                    Text((cartState.foodDetail.prices[i]
                                            .discountedPrice)
                                        .toString()),
                                  ],
                                )
                              ],
                            ),
                            value: cartState.foodDetail.prices[i],
                            onChanged: (i) {
                              newState(() {
                                price = i;
                              });
                            },
                            groupValue: price,
                          );
                        }, childCount: cartState.foodDetail.prices.length),
                      ));

                      for (int i = 0;
                          i < cartState.foodDetail.addOnsTypes.length;
                          i++) {
                        listWidget.add(SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                                top: 10,
                                bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  cartState.foodDetail.addOnsTypes[i].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ));
                        if (cartState.foodDetail.addOnsTypes[i].options ==
                            "multiple") {
                          // one is check box with number inside
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    cartState.foodDetail.addOnsTypes[i]
                                        .addOns[j].isSelected = bool;
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i]
                                    .addOns[j].isSelected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    /*Container(
                                      width: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: textControllersMap[i][j],
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          newState(() {
                                            if (text == "") {
                                              cartState
                                                  .foodDetail
                                                  .addOnsTypes[i]
                                                  .addOns[j]
                                                  .quantity = 0;
                                            } else {
                                              cartState
                                                  .foodDetail
                                                  .addOnsTypes[i]
                                                  .addOns[j]
                                                  .quantity = int.parse(text);
                                            }
                                          });
                                        },
                                      ),
                                    ),*/
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(
                                              widget.restaurant.currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState
                                .foodDetail.addOnsTypes[i].options ==
                            "one") {
                          // multiple is radio button
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return RadioListTile<AddOn>(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(
                                              widget.restaurant.currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                                value: cartState
                                    .foodDetail.addOnsTypes[i].addOns[j],
                                onChanged: (addOn) {
                                  newState(() {
                                    multipleAddOns[i] = addOn;
                                    cartState.foodDetail.addOnsTypes[i].addOns
                                        .forEach((e) {
                                      e.isSelected = false;
                                    });
                                    addOn.isSelected = true;
                                  });
                                },
                                groupValue: multipleAddOns[i],
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState
                                .foodDetail.addOnsTypes[i].options ==
                            "custom") {
                          // custom is check box only
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    if (bool) {
                                      if (cartState.foodDetail.addOnsTypes[i]
                                              .getSelectedAddOn()
                                              .length ==
                                          cartState.foodDetail.addOnsTypes[i]
                                              .maxNumber) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: Text(
                                                cartState.foodDetail
                                                    .addOnsTypes[i].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                "You are allowed to select maximum " +
                                                    cartState
                                                        .foodDetail
                                                        .addOnsTypes[i]
                                                        .maxNumber
                                                        .toString() +
                                                    " items in this " +
                                                    cartState.foodDetail
                                                        .addOnsTypes[i].name,
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK")),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        cartState.foodDetail.addOnsTypes[i]
                                            .addOns[j].isSelected = bool;
                                      }
                                    } else {
                                      cartState.foodDetail.addOnsTypes[i]
                                          .addOns[j].isSelected = bool;
                                    }
                                    /*if (bool) {
                                      cartState.foodDetail.addOnsTypes[i]
                                          .addOns[j].quantity = 1;
                                    } else {
                                      cartState.foodDetail.addOnsTypes[i]
                                          .addOns[j].quantity = 0;
                                    }*/
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i]
                                    .addOns[j].isSelected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(
                                              widget.restaurant.currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        }
                      }

                      listWidget.add(SliverToBoxAdapter(
                        child: SizedBox(
                          height: kBottomNavigationBarHeight + 30,
                        ),
                      ));

                      return Stack(
                        children: <Widget>[
                          CustomScrollView(
                            controller: controller,
                            slivers: listWidget,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: kBottomNavigationBarHeight,
                              width: AppUtil.getScreenWidth(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.yellow[600]))),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: price == null || quantity == 0
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: quantity > 1
                                                      ? InkWell(
                                                          onTap: () {
                                                            newState(() {
                                                              quantity--;
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons.remove))
                                                      : SizedBox(),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "$quantity",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                      onTap: () {
                                                        newState(() {
                                                          quantity++;
                                                        });
                                                      },
                                                      child: Icon(Icons.add)),
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: GestureDetector(
                                        onTap: price == null || quantity == 0
                                            ? () {}
                                            : () {
                                                //do something add item here
                                                Navigator.pop(context);
                                                BlocProvider.of<FoodOrderBloc>(
                                                        context)
                                                    .add(
                                                        ChangeQuantityNoPayment(
                                                            widget.restaurant,
                                                            "",
                                                            food,
                                                            quantity,
                                                            price,
                                                            _getAddOns(cartState
                                                                .foodDetail
                                                                .addOnsTypes),
                                                            true));
                                              },
                                        child: SizedBox.expand(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[600],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    18))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            AppUtil.getCurrencyIcon(
                                                                widget
                                                                    .restaurant
                                                                    .currencyCode),
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            AppUtil.doubleRemoveZeroTrailing(
                                                                _getTotalFoodDetail(
                                                                    price,
                                                                    quantity,
                                                                    cartState
                                                                        .foodDetail
                                                                        .addOnsTypes)),
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "ADD ITEM",
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                opacity: price == null ||
                                                        quantity == 0
                                                    ? 0.65
                                                    : 0.0,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                                duration:
                                                    Duration(milliseconds: 300),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              );
            },
          );
        });
  }

  double _getTotalFoodDetail(
      Price price, int quantity, List<AddOnsType> addOnsTypes) {
    double totalAmount = 0;

    if (price == null || quantity == 0) {
      return 0;
    } else {
      totalAmount = price.discountedPrice;

      addOnsTypes.forEach((element) {
        totalAmount = totalAmount + element.getAmount();
      });

      totalAmount = totalAmount * quantity;
    }

    return totalAmount;
  }

  List<AddOn> _getAddOns(List<AddOnsType> addOnsTypes) {
    List<AddOn> list = List();

    addOnsTypes.forEach((element) {
      list = list + element.getSelectedAddOn();
    });

    return list;
  }
}

class RestaurantDetailBottomNavBar extends StatelessWidget {
  final int totalItem;
  final String buttonText;
  final Function onButtonTap;
  final bool isValid;
  final double totalAmount;
  final String currencyIcon;

  const RestaurantDetailBottomNavBar({
    Key key,
    this.totalItem,
    this.buttonText,
    this.onButtonTap,
    this.isValid,
    this.totalAmount,
    this.currencyIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: AppUtil.getScreenWidth(context),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.yellow[600]))),
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
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                        currencyIcon,
                        width: 13,
                        height: 13,
                      ),
                    ),
                    Text(
                      "${AppUtil.doubleRemoveZeroTrailing(totalAmount)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                        color: Colors.yellow[600],
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(18))),
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
  final Function onSearchTap;
  final String address;

  DetailRestaurantFilterTabs(
    this.restaurantId, {
    this.onListButtonTap,
    this.address,
    this.onGridButtonTap,
    this.isListSelected,
    this.size,
    this.isVegOnly,
    this.onSwitchChanged,
    this.offset,
    this.onSearchTap,
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
                InkWell(
                  onTap: onSearchTap,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: SvgPicture.asset(
                      "assets/search.svg",
                      color: Colors.grey,
                    ),
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
                        BlocProvider.of<DetailPageBloc>(context).add(
                            RestaurantMenuChange(restaurantId,
                                state.menuCategories[i].id, i, address));
                      },
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black26,
                      indicatorColor: Colors.yellow[600],
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      indicatorPadding: EdgeInsets.only(
                          left: 0, right: 15, bottom: 2, top: 0),
                      labelPadding:
                          EdgeInsets.only(left: 0, right: 15, bottom: 0),
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
