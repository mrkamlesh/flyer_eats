import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/model/add_on.dart';
import 'package:clients/model/add_ons_type.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/price.dart';
import 'package:clients/page/home.dart';
import 'package:clients/page/offers_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/page/restaurant_place_order_page.dart';
import 'package:clients/widget/custom_bottom_navigation_bar.dart';
import 'package:clients/bloc/search/bloc.dart';
import 'package:clients/widget/food_list.dart';
import 'package:clients/widget/restaurant_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  final String token;
  final String address;

  const SearchPage({Key key, this.token, this.address}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  int _currentIndex = 2;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  ScrollController _scrollController;
  TabController _tabController;

  SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      if (currentScroll == maxScroll) _bloc.add(LoadMore(widget.token, widget.address));

      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          _isScrollingDown = true;
          setState(() {
            _animationController.forward().orCancel;
          });
        }
      }
      if ((_scrollController.position.userScrollDirection ==
              ScrollDirection
                  .forward) /*|
          (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent -
                      kBottomNavigationBarHeight &&
              !_scrollController.position.outOfRange)*/
          ) {
        if (_isScrollingDown) {
          _isScrollingDown = false;
          setState(() {
            _animationController.reverse().orCancel;
          });
        }
      }
    });

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _bloc = SearchBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          return BlocConsumer<FoodOrderBloc, FoodOrderState>(
            listener: (context, cartState) {
              if (cartState is ConfirmCartState) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Clear Cart?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          "Would you like to clear current cart?",
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
              return BlocConsumer<SearchBloc, SearchState>(
                listener: (context, state) {
                  if (state is CartState) {
                    _isScrollingDown = false;
                    _animationController.reverse().orCancel;
                  }
                },
                builder: (context, state) {
                  return Scaffold(
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    bottomNavigationBar: AnimatedCrossFade(
                      crossFadeState: cartState.placeOrder.foodCart.cartItemTotal() > 0
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                      firstChild: AnimatedBuilder(
                        animation: _navBarAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _navBarAnimation.value,
                            child: child,
                          );
                        },
                        child: BottomAppBar(
                          elevation: 8,
                          clipBehavior: Clip.antiAlias,
                          child: AnimatedBuilder(
                            animation: _navBarAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: _navBarAnimation.value,
                                child: child,
                              );
                            },
                            child: CustomBottomNavBar(
                              animationDuration: Duration(milliseconds: 300),
                              items: [
                                BottomNavyBarItem(icon: "assets/2.svg", title: "Flyer Eats"),
                                BottomNavyBarItem(icon: "assets/4.svg", title: "Offers"),
                                BottomNavyBarItem(icon: "assets/1.svg", title: "Search"),
                                BottomNavyBarItem(
                                    icon: "assets/3.svg",
                                    title: "Order",
                                    badge: cartState.placeOrder.foodCart.cartItemTotal())
                              ],
                              onItemSelected: (index) {
                                setState(() async {
                                  _currentIndex = index;
                                  if (index == 0) {
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Home();
                                    }));
                                    _currentIndex = 2;
                                  } else if (index == 1) {
                                    await Navigator.push(context,
                                        PageRouteBuilder(pageBuilder: (context, anim1, anim2) {
                                      return OfferListPage(
                                        address: widget.address,
                                      );
                                    }));
                                    _currentIndex = 2;
                                  } else if (index == 3) {
                                    await Navigator.push(context,
                                        PageRouteBuilder(pageBuilder: (context, anim1, anim2) {
                                      return RestaurantPlaceOrderPage(
                                        location: Location(address: widget.address),
                                        user: loginState.user,
                                      );
                                    }));
                                    _currentIndex = 2;
                                  }
                                });
                              },
                              selectedIndex: _currentIndex,
                              selectedColor: Colors.orange[700],
                              unselectedColor: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      secondChild: AnimatedBuilder(
                        animation: _navBarAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _navBarAnimation.value,
                            child: child,
                          );
                        },
                        child: SearchPageOrderBottomNavBar(
                          isValid: cartState.placeOrder.foodCart.cartItemTotal() > 0 ? true : false,
                          totalAmount: cartState.placeOrder.foodCart.getCartTotalAmount(),
                          totalItem: cartState.placeOrder.foodCart.cartItemTotal(),
                          currencyIcon: AppUtil.getCurrencyIcon(cartState.placeOrder.restaurant.currencyCode),
                          buttonText: "CHECK OUT",
                          onButtonTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return RestaurantPlaceOrderPage(
                                location: Location(address: widget.address),
                                user: loginState.user,
                              );
                            }));
                          },
                        ),
                      ),
                    ),
                    body: Container(
                      height: AppUtil.getScreenHeight(context),
                      width: AppUtil.getScreenWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + distanceBetweenSection,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable),
                            child: CustomTextField(
                              onChanged: (value) {
                                _bloc.add(Search(widget.token, widget.address, value));
                              },
                              hint: "SEARCH ANYTHING",
                            ),
                          ),
                          BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              if (state is InitialSearchState) {
                                return SizedBox();
                              }
                              return DefaultTabController(
                                length: 2,
                                initialIndex: 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Center(
                                    child: TabBar(
                                      controller: _tabController,
                                      onTap: (i) {},
                                      isScrollable: true,
                                      labelColor: Colors.black,
                                      unselectedLabelColor: Colors.black26,
                                      indicatorColor: Colors.yellow[600],
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      labelStyle:
                                          GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                                      indicatorPadding: EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
                                      labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
                                      tabs: [
                                        Tab(
                                          text: "Restaurant",
                                        ),
                                        Tab(text: "Items")
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
                            if (state is LoadingNewSearch) {
                              return Expanded(
                                child: Container(
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.black38,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state is InitialSearchState) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 30, right: horizontalPaddingDraggable, left: horizontalPaddingDraggable),
                                child: Text(
                                  "Search anything here...",
                                  style: TextStyle(color: Colors.black38, fontSize: 14),
                                ),
                              );
                            } else if (state is ErrorNewSearch) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 30, right: horizontalPaddingDraggable, left: horizontalPaddingDraggable),
                                child: Text(
                                  state.message,
                                  style: TextStyle(color: Colors.black38, fontSize: 14),
                                ),
                              );
                            }

                            if (state.restaurants.isEmpty) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 30, right: horizontalPaddingDraggable, left: horizontalPaddingDraggable),
                                child: Text("No result for your search..."),
                              );
                            } else {
                              List<Widget> slivers = List();
                              for (int i = 0; i < state.restaurants.length; i++) {
                                if (state.restaurants[i].searchFoodList.length > 0) {
                                  slivers.add(SliverToBoxAdapter(
                                    child: Container(
                                        margin: EdgeInsets.only(bottom: 10, top: distanceSectionContent),
                                        padding: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                        ),
                                        child: Text(
                                          state.restaurants[i].name,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        )),
                                  ));
                                  slivers.add(FoodListWidget(
                                    onAdd: (j) {
                                      FocusScope.of(context).unfocus();
                                      _animationController.reverse().orCancel;
                                      if (state.restaurants[i].searchFoodList[j].isSingleItem) {
                                        BlocProvider.of<FoodOrderBloc>(context).add(ChangeQuantityNoPayment(
                                            state.restaurants[i],
                                            state.restaurants[i].searchFoodList[j].id,
                                            state.restaurants[i].searchFoodList[j],
                                            (cartState.placeOrder.foodCart
                                                    .getFoodQuantity(state.restaurants[i].searchFoodList[j]) +
                                                1),
                                            state.restaurants[i].searchFoodList[j].price,
                                            [],
                                            true));
                                      } else {
                                        _showAddOnsSheet(state.restaurants[i].searchFoodList[j], state.restaurants[i]);
                                      }
                                    },
                                    onRemove: (j) {
                                      _animationController.reverse().orCancel;
                                      BlocProvider.of<FoodOrderBloc>(context).add(ChangeQuantityNoPayment(
                                          state.restaurants[i],
                                          state.restaurants[i].searchFoodList[j].id,
                                          state.restaurants[i].searchFoodList[j],
                                          (cartState.placeOrder.foodCart
                                                  .getFoodQuantity(state.restaurants[i].searchFoodList[j]) -
                                              1),
                                          state.restaurants[i].searchFoodList[j].price,
                                          [],
                                          false));
                                    },
                                    padding: EdgeInsets.only(
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                    ),
                                    cart: cartState.placeOrder.foodCart,
                                    currencyIcon: AppUtil.getCurrencyIcon(state.restaurants[i].currencyCode),
                                    listFood: state.restaurants[i].searchFoodList,
                                    type: FoodListViewType.search,
                                    scale: 0.90,
                                  ));
                                }
                              }

                              slivers.add(SliverToBoxAdapter(
                                child: state is LoadingMore
                                    ? Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Center(
                                            child: SpinKitCircle(
                                          color: Colors.black38,
                                          size: 30,
                                        )))
                                    : SizedBox(),
                              ));
                              slivers.add(
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight + distanceBetweenSection,
                                  ),
                                ),
                              );

                              return Expanded(
                                child: Container(
                                  child: TabBarView(controller: _tabController, children: [
                                    CustomScrollView(
                                      controller: _scrollController,
                                      slivers: <Widget>[
                                        RestaurantListWidget(
                                          type: RestaurantViewType.searchResult,
                                          location: Location(address: widget.address),
                                          restaurants: state.restaurants,
                                          fade: 0.4,
                                          scale: 0.95,
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: kBottomNavigationBarHeight + distanceBetweenSection,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CustomScrollView(
                                      controller: _scrollController,
                                      slivers: slivers,
                                    ),
                                  ]),
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  _showAddOnsSheet(Food food, Restaurant selectedRestaurant) {
    Price price;
    Map<int, AddOn> multipleAddOns = Map();
    Map<int, List<TextEditingController>> textControllersMap = Map();
    int quantity = 1;

    BlocProvider.of<FoodOrderBloc>(context).add(GetFoodDetail(food.id));
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: BlocConsumer<FoodOrderBloc, FoodOrderState>(
                  listener: (context, cartState) {
                    if (cartState is SuccessGetFoodDetail) {
                      price = cartState.foodDetail.prices[0];
                      for (int i = 0; i < cartState.foodDetail.addOnsTypes.length; i++) {
                        if (cartState.foodDetail.addOnsTypes[i].options == "one") {
                          textControllersMap[i] = List<TextEditingController>();
                          for (int j = 0; j < cartState.foodDetail.addOnsTypes[i].addOns.length; j++) {
                            TextEditingController textController = TextEditingController(text: 1.toString());
                            textControllersMap[i].add(textController);
                          }
                        }
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
                            padding: EdgeInsets.only(left: horizontalPaddingDraggable, top: 10, bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SIZE",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                Expanded(child: Text(cartState.foodDetail.prices[i].size)),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppUtil.getCurrencyIcon(selectedRestaurant.currencyCode),
                                      height: 10,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text((cartState.foodDetail.prices[i].discountedPrice).toString()),
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

                      for (int i = 0; i < cartState.foodDetail.addOnsTypes.length; i++) {
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                )),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ));
                        if (cartState.foodDetail.addOnsTypes[i].options == "one") {
                          // one is check box with number inside
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    cartState.foodDetail.addOnsTypes[i].addOns[j].isSelected = bool;
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i].addOns[j].isSelected,
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(cartState.foodDetail.addOnsTypes[i].addOns[j].name)),
                                    Container(
                                      width: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: textControllersMap[i][j],
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          newState(() {
                                            if (text == "") {
                                              cartState.foodDetail.addOnsTypes[i].addOns[j].quantity = 0;
                                            } else {
                                              cartState.foodDetail.addOnsTypes[i].addOns[j].quantity = int.parse(text);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(selectedRestaurant.currencyCode),
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text((cartState.foodDetail.addOnsTypes[i].addOns[j].price).toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }, childCount: cartState.foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState.foodDetail.addOnsTypes[i].options == "multiple") {
                          // multiple is radio button
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return RadioListTile<AddOn>(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(cartState.foodDetail.addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(selectedRestaurant.currencyCode),
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text((cartState.foodDetail.addOnsTypes[i].addOns[j].price).toString()),
                                      ],
                                    )
                                  ],
                                ),
                                value: cartState.foodDetail.addOnsTypes[i].addOns[j],
                                onChanged: (addOn) {
                                  newState(() {
                                    multipleAddOns[i] = addOn;
                                    cartState.foodDetail.addOnsTypes[i].addOns.forEach((e) {
                                      e.isSelected = false;
                                    });
                                    addOn.isSelected = true;
                                  });
                                },
                                groupValue: multipleAddOns[i],
                              );
                            }, childCount: cartState.foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState.foodDetail.addOnsTypes[i].options == "custom") {
                          // custom is check box only
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    cartState.foodDetail.addOnsTypes[i].addOns[j].isSelected = bool;
                                    if (bool) {
                                      cartState.foodDetail.addOnsTypes[i].addOns[j].quantity = 1;
                                    } else {
                                      cartState.foodDetail.addOnsTypes[i].addOns[j].quantity = 0;
                                    }
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i].addOns[j].isSelected,
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(cartState.foodDetail.addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(selectedRestaurant.currencyCode),
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text((cartState.foodDetail.addOnsTypes[i].addOns[j].price).toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }, childCount: cartState.foodDetail.addOnsTypes[i].addOns.length),
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
                                  color: Colors.white, border: Border(top: BorderSide(color: Colors.yellow[600]))),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: price == null || quantity == 0
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.only(left: 10, right: 10),
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
                                                          child: Icon(Icons.remove))
                                                      : SizedBox(),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "$quantity",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 16),
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
                                                BlocProvider.of<FoodOrderBloc>(context).add(ChangeQuantityNoPayment(
                                                    selectedRestaurant,
                                                    "",
                                                    food,
                                                    quantity,
                                                    price,
                                                    _getAddOns(cartState.foodDetail.addOnsTypes),
                                                    true));
                                              },
                                        child: SizedBox.expand(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[600],
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18))),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            AppUtil.getCurrencyIcon(selectedRestaurant.currencyCode),
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            AppUtil.doubleRemoveZeroTrailing(_getTotalFoodDetail(
                                                                price, quantity, cartState.foodDetail.addOnsTypes)),
                                                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "ADD ITEM",
                                                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                opacity: price == null || quantity == 0 ? 0.65 : 0.0,
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

  double _getTotalFoodDetail(Price price, int quantity, List<AddOnsType> addOnsTypes) {
    double totalAmount = 0;

    if (price == null || quantity == 0) {
      return 0;
    } else {
      totalAmount = totalAmount + price.discountedPrice;

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

class SearchRestaurantWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int selectedIndex;
  final Function onTap;
  final Animation<double> scale;

  const SearchRestaurantWidget({Key key, this.restaurant, this.index, this.selectedIndex, this.onTap, this.scale})
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

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;

  const CustomTextField({
    Key key,
    this.hint,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: primary1, blurRadius: 10, spreadRadius: -4, offset: Offset(-4, 4))],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primary1, width: 2)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: onChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                hintText: hint == null ? "" : hint,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}

class SearchPageOrderBottomNavBar extends StatelessWidget {
  final int totalItem;
  final String buttonText;
  final Function onButtonTap;
  final bool isValid;
  final double totalAmount;
  final String currencyIcon;

  const SearchPageOrderBottomNavBar({
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
                        currencyIcon,
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
