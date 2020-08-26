import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/page/offers_list_page.dart';
import 'package:clients/page/restaurant_place_order_page.dart';
import 'package:clients/page/search_restaurant_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/currentorder/current_order_event.dart';
import 'package:clients/bloc/currentorder/current_order_state.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/scratch_card.dart';
import 'package:clients/page/cancelled_order_page.dart';
import 'package:clients/page/delivery_process_order_page.dart';
import 'package:clients/page/restaurants_list_page.dart';
import 'package:clients/page/select_location_page.dart';
import 'package:clients/page/track_order_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/banner_list_widget.dart';
import 'package:clients/widget/custom_bottom_navigation_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/food_category_list.dart';
import 'package:clients/widget/ads_list.dart';
import 'package:clients/widget/restaurant_list.dart';
import 'package:clients/widget/shop_category_list.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:after_layout/after_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final bool isShowContactConfirmationSheet;
  final String contactNumber;

  const Home(
      {Key key,
      this.isShowContactConfirmationSheet = false,
      this.contactNumber})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<Home> {
  int _currentIndex = 0;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  Animation<double> _orderInformationFadeAnimation;
  Animation<double> _orderInformationScaleAnimation;

  @override
  initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _orderInformationFadeAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.95, curve: Curves.ease)));
    _orderInformationScaleAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.95, 1.0, curve: Curves.ease)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    //_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<FoodOrderBloc, FoodOrderState>(
          builder: (context, cartState) {
            return Scaffold(
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
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, homeState) {
                    if (homeState is LoadingCurrentLocation ||
                        homeState is ErrorCurrentLocation ||
                        homeState is NoHomepageData ||
                        homeState is ErrorHomeState ||
                        homeState is LoadingHomeState) {
                      return SizedBox(
                        height: 0,
                      );
                    }

                    return BottomAppBar(
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
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoggedOut) {
                              Navigator.pushReplacementNamed(context, "/");
                            }
                          },
                          builder: (context, loginState) {
                            return CustomBottomNavBar(
                              animationDuration: Duration(milliseconds: 300),
                              items: [
                                BottomNavyBarItem(
                                    icon: "assets/2.svg", title: "Flyer Eats"),
                                BottomNavyBarItem(
                                    icon: "assets/4.svg", title: "Offers"),
                                BottomNavyBarItem(
                                    icon: "assets/1.svg", title: "Search"),
                                BottomNavyBarItem(
                                    icon: "assets/3.svg",
                                    title: "Order",
                                    badge: cartState.placeOrder.foodCart
                                        .cartItemTotal())
                              ],
                              onItemSelected: (index) async {
                                _currentIndex = index;
                                if (index == 1) {
                                  await Navigator.push(context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, anim1, anim2) {
                                    return OfferListPage(
                                      address: homeState
                                          .homePageData.location.address,
                                    );
                                  }));
                                  _currentIndex = 0;
                                } else if (index == 2) {
                                  await Navigator.push(context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, anim1, anim2) {
                                    return SearchRestaurantPage(
                                      address: homeState
                                          .homePageData.location.address,
                                      token: loginState.user.token,
                                    );
                                  }));
                                  _currentIndex = 0;
                                } else if (index == 3) {
                                  await Navigator.push(context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, anim1, anim2) {
                                    return RestaurantPlaceOrderPage(
                                      location: homeState.homePageData.location,
                                      user: loginState.user,
                                    );
                                  }));
                                  _currentIndex = 0;
                                }
                              },
                              selectedIndex: _currentIndex,
                              selectedColor: Colors.orange[700],
                              unselectedColor: Colors.black26,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              body: Stack(
                children: <Widget>[
                  BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState) {
                    if (homeState is LoadingCurrentLocation ||
                        homeState is ErrorCurrentLocation ||
                        homeState is LoadingHomeState ||
                        homeState is NoHomepageData ||
                        homeState is ErrorHomeState) {
                      return DefaultBanner();
                    }

                    if (homeState.homePageData.promos.isEmpty) {
                      return DefaultBanner();
                    }
                    return Positioned(
                      top: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: BannerListWidget(
                          location: homeState.homePageData.location,
                          bannerList: homeState.homePageData.promos,
                        ),
                      ),
                    );
                  }),
                  Align(
                    alignment: Alignment.topCenter,
                    child: BlocConsumer<HomeBloc, HomeState>(
                      listener: (context, homeState) {
                        if (homeState is ErrorCurrentLocation) {
                          final snackBar = SnackBar(
                            content: Text(homeState.message),
                            duration: Duration(days: 365),
                            action: SnackBarAction(
                              label: "Retry",
                              onPressed: () {
                                BlocProvider.of<HomeBloc>(context).add(
                                    InitGetData(loginState.user.token, null,
                                        loginState.user.lastLocation));
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        } else if (homeState is NoHomepageData) {
                          final snackBar = SnackBar(
                            content: Text(
                                "We are not available yet in your location"),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      builder: (context, state) {
                        return Builder(
                          builder: (context) {
                            return CustomAppBar(
                              isDropDownButtonVisible:
                                  state.isAppBarDropDownVisible,
                              drawer: "assets/drawer.svg",
                              title: state.appBarTitle,
                              isLoading: state.isAppBarLoading,
                              leading: state.leading,
                              isFlag: state.isFlagVisible,
                              onTapTitle: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SelectLocationPage();
                                }));
                              },
                              onTapLeading: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SelectLocationPage();
                                }));
                              },
                              onTapDrawer: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, homeState) {
                      if (homeState is LoadingCurrentLocation ||
                          homeState is LoadingHomeState) {
                        return Center(child: HomeLoadingWidget());
                      } else if (homeState is ErrorCurrentLocation) {
                        return Center(
                            child: HomeErrorWidget(homeState.message));
                      } else if (homeState is ErrorHomeState) {
                        return Center(
                            child: HomeErrorWidget(homeState.message));
                      } else if (homeState is NoHomepageData) {
                        return NoHomePageWidget(
                            location: homeState.appBarTitle);
                      }
                      return DraggableScrollableSheet(
                        initialChildSize: AppUtil.getDraggableHeight(context) /
                            AppUtil.getScreenHeight(context),
                        minChildSize: AppUtil.getDraggableHeight(context) /
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
                          return SingleChildScrollView(
                            controller: controller,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(32),
                                      topLeft: Radius.circular(32))),
                              padding: EdgeInsets.only(top: 10, bottom: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            horizontalPaddingDraggable - 5),
                                    margin: EdgeInsets.only(
                                        bottom: distanceSectionContent - 10),
                                    height: 115,
                                    child: ShopCategoryListWidget(
                                      onTap: (i) {
                                        if (i == 0) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RestaurantListPage(
                                              image: "assets/allrestaurant.png",
                                              merchantType:
                                                  MerchantType.restaurant,
                                              isExternalImage: false,
                                              title: "All Restaurants",
                                              location: Location(
                                                  address: homeState
                                                      .homePageData
                                                      .location
                                                      .address),
                                              isFilterEnabled: true,
                                            );
                                          }));
                                        } else if (i == 1) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RestaurantListPage(
                                              image: "assets/allrestaurant.png",
                                              merchantType:
                                                  MerchantType.grocery,
                                              isExternalImage: false,
                                              title: "All Grocery",
                                              location: Location(
                                                  address: homeState
                                                      .homePageData
                                                      .location
                                                      .address),
                                              isFilterEnabled: false,
                                            );
                                          }));
                                        } else if (i == 2) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RestaurantListPage(
                                              image: "assets/allrestaurant.png",
                                              merchantType:
                                                  MerchantType.vegFruits,
                                              isExternalImage: false,
                                              title: "All Merchants",
                                              location: Location(
                                                  address: homeState
                                                      .homePageData
                                                      .location
                                                      .address),
                                              isFilterEnabled: false,
                                            );
                                          }));
                                        } else if (i == 3) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RestaurantListPage(
                                              image: "assets/allrestaurant.png",
                                              merchantType: MerchantType.meat,
                                              isExternalImage: false,
                                              title: "All Merchants",
                                              location: Location(
                                                  address: homeState
                                                      .homePageData
                                                      .location
                                                      .address),
                                              isFilterEnabled: false,
                                            );
                                          }));
                                        }
                                      },
                                      shopCategories:
                                          AppUtil.getShopCategories(),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom: distanceSectionContent,
                                          top: 5),
                                      child: HomeActionWidget(
                                          location:
                                              homeState.homePageData.location)),
                                  homeState.homePageData.topRestaurants
                                          .isNotEmpty
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceSectionContent -
                                                          10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Top Restaurants",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return RestaurantListPage(
                                                          title:
                                                              "Top Restaurants",
                                                          location: Location(
                                                              address: homeState
                                                                  .homePageData
                                                                  .location
                                                                  .address),
                                                          type:
                                                              RestaurantListType
                                                                  .top,
                                                          merchantType:
                                                              MerchantType
                                                                  .restaurant,
                                                          isExternalImage:
                                                              false,
                                                          image:
                                                              "assets/allrestaurant.png",
                                                        );
                                                      }));
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      height: 20,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        "See All",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color: primary3,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceBetweenSection -
                                                          20),
                                              height: 170,
                                              child: RestaurantListWidget(
                                                onLoadMore: () {
                                                  if (!(homeState.indicator
                                                      .isTopRestaurantLoading)) {
                                                    BlocProvider.of<HomeBloc>(
                                                            context)
                                                        .add(LoadMoreTopRestaurant(
                                                            loginState
                                                                .user.token,
                                                            homeState
                                                                .homePageData
                                                                .location));
                                                  }
                                                },
                                                type: RestaurantViewType
                                                    .topRestaurant,
                                                restaurants: homeState
                                                    .homePageData
                                                    .topRestaurants,
                                                location: homeState
                                                    .homePageData.location,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  distanceSectionContent - 10),
                                        ),
                                  homeState.homePageData.categories.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceSectionContent -
                                                          10),
                                              child: Text(
                                                "Food Categories",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceBetweenSection -
                                                          10),
                                              height: 130,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(2, 2),
                                                        color: Colors.black26,
                                                        spreadRadius: 0,
                                                        blurRadius: 5)
                                                  ]),
                                              child: FoodCategoryListWidget(
                                                onTap: (category) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RestaurantListPage(
                                                      title: category.name,
                                                      image: category.image,
                                                      merchantType: MerchantType
                                                          .restaurant,
                                                      category: category.id,
                                                      isExternalImage: true,
                                                      location: Location(
                                                          address: homeState
                                                              .homePageData
                                                              .location
                                                              .address),
                                                    );
                                                  }));
                                                },
                                                foodCategoryList: homeState
                                                    .homePageData.categories,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  homeState.homePageData.orderAgainRestaurants
                                          .isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      horizontalPaddingDraggable),
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceSectionContent -
                                                          10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Order Again",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return RestaurantListPage(
                                                          title: "Order Again",
                                                          merchantType:
                                                              MerchantType
                                                                  .restaurant,
                                                          type:
                                                              RestaurantListType
                                                                  .orderAgain,
                                                          location: Location(
                                                              address: homeState
                                                                  .homePageData
                                                                  .location
                                                                  .address),
                                                          isExternalImage:
                                                              false,
                                                          image:
                                                              "assets/allrestaurant.png",
                                                        );
                                                      }));
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 70,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        "See All",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color: primary3,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      distanceSectionContent -
                                                          10),
                                              height: 170,
                                              child: RestaurantListWidget(
                                                type: RestaurantViewType
                                                    .orderAgainRestaurant,
                                                restaurants: homeState
                                                    .homePageData
                                                    .orderAgainRestaurants,
                                                isExpand: true,
                                                location: Location(
                                                    address: homeState
                                                        .homePageData
                                                        .location
                                                        .address),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  homeState.homePageData.isReferralAvailable
                                      ? InkWell(
                                          onTap: () {
                                            AppUtil.share(
                                                context,
                                                homeState
                                                    .homePageData.referralCode,
                                                AppUtil.getCurrencyString(
                                                        homeState.homePageData
                                                            .currencyCode) +
                                                    " " +
                                                    homeState.homePageData
                                                        .referralDiscount);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: distanceBetweenSection -
                                                    10),
                                            height: 0.16 *
                                                AppUtil.getScreenHeight(
                                                    context),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFC94B),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 10,
                                                    spreadRadius: 5)
                                              ],
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 0.16 *
                                                          AppUtil
                                                              .getScreenHeight(
                                                                  context) -
                                                      20,
                                                  height: 0.16 *
                                                          AppUtil
                                                              .getScreenHeight(
                                                                  context) -
                                                      20,
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        "assets/order success icon 2.svg",
                                                        height: 0.16 *
                                                                AppUtil
                                                                    .getScreenHeight(
                                                                        context) -
                                                            60,
                                                        width: 0.16 *
                                                                AppUtil
                                                                    .getScreenHeight(
                                                                        context) -
                                                            60,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Refer Now",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "REFER A FRIEND AND EARN",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            "Get a coupon worth",
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          SvgPicture.asset(
                                                            AppUtil.getCurrencyIcon(
                                                                homeState
                                                                    .homePageData
                                                                    .currencyCode),
                                                            height: 12,
                                                            width: 12,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            homeState
                                                                    .homePageData
                                                                    .referralDiscount ??
                                                                "",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.none,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                "Use Referal Code: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                homeState
                                                                        .homePageData
                                                                        .referralCode ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      primary3,
                                                                  fontSize: 12,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  homeState.homePageData.ads.isNotEmpty
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  distanceBetweenSection - 10),
                                          height: 140,
                                          child: AdsListWidget(
                                            adsList: homeState.homePageData.ads,
                                          ),
                                        )
                                      : SizedBox(),
                                  homeState.homePageData.dblRestaurants
                                          .isNotEmpty
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: distanceBetweenSection +
                                                  distanceSectionContent),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        distanceSectionContent -
                                                            10,
                                                    right:
                                                        horizontalPaddingDraggable,
                                                    left:
                                                        horizontalPaddingDraggable),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      homeState
                                                          .homePageData.dblText,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return RestaurantListPage(
                                                            title: homeState
                                                                .homePageData
                                                                .dblText,
                                                            merchantType:
                                                                MerchantType
                                                                    .restaurant,
                                                            location: Location(
                                                                address: homeState
                                                                    .homePageData
                                                                    .location
                                                                    .address),
                                                            type:
                                                                RestaurantListType
                                                                    .dbl,
                                                            isExternalImage:
                                                                false,
                                                            image:
                                                                "assets/allrestaurant.png",
                                                          );
                                                        }));
                                                      },
                                                      child: Container(
                                                        width: 70,
                                                        height: 20,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "See All",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                              color: primary3,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 225,
                                                padding: EdgeInsets.only(
                                                    top: distanceSectionContent,
                                                    bottom:
                                                        distanceSectionContent),
                                                //margin: EdgeInsets.only(bottom: distanceSectionContent),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(2, 2),
                                                          color: Colors.black26,
                                                          spreadRadius: 0,
                                                          blurRadius: 5)
                                                    ]),
                                                alignment: Alignment.center,
                                                child: RestaurantListWidget(
                                                  onLoadMore: () {
                                                    if (!(homeState.indicator
                                                        .isDblRestaurantLoading)) {
                                                      BlocProvider.of<HomeBloc>(
                                                              context)
                                                          .add(LoadMoreDblRestaurant(
                                                              loginState
                                                                  .user.token,
                                                              homeState
                                                                  .homePageData
                                                                  .location));
                                                    }
                                                  },
                                                  type: RestaurantViewType
                                                      .dinnerTimeRestaurant,
                                                  restaurants: homeState
                                                      .homePageData
                                                      .dblRestaurants,
                                                  location: Location(
                                                      address: homeState
                                                          .homePageData
                                                          .location
                                                          .address),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: distanceBetweenSection,
                                        ),
                                  BlocBuilder<CurrentOrderBloc,
                                          CurrentOrderState>(
                                      builder: (context, state) {
                                    if (state is SuccessState ||
                                        state is ErrorState ||
                                        state is LoadingState) {
                                      if (state.isShowStatus) {
                                        return SizedBox(
                                          height: 90,
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                    return SizedBox();
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: kBottomNavigationBarHeight,
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, loginState) {
                        return BlocConsumer<CurrentOrderBloc,
                            CurrentOrderState>(
                          listener: (context, state) {
                            if (state is DeliveredOrderState) {
                              if (state.currentOrder.isShowReview) {
                                _showReviewSheet(loginState.user.token,
                                    state.currentOrder.orderId);
                              }
                              if (state.currentOrder.isShowScratch &&
                                  state.currentOrder.scratchCard != null) {
                                _showScratchCard(
                                    loginState.user.token,
                                    state.currentOrder.scratchCard,
                                    state.currentOrder.currencyCode);
                              }
                            } else if (state is CancelledOrderState) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CancelledOrderPage(
                                  token: loginState.user.token,
                                  orderId: state.currentOrder.orderId,
                                  cancelReason: state.currentOrder.cancelReason,
                                  address: state.currentOrder.merchantCity +
                                      " " +
                                      state.currentOrder.merchantState,
                                  merchantId: state.currentOrder.merchantId,
                                );
                              }));
                            }
                          },
                          builder: (context, state) {
                            if (state is ErrorState) {
                              return AnimatedBuilder(
                                animation: _orderInformationFadeAnimation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity:
                                        _orderInformationFadeAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  height: 90,
                                  width: AppUtil.getScreenWidth(context),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7)),
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          "Connection Error getting active order",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () {
                                            BlocProvider.of<CurrentOrderBloc>(
                                                    context)
                                                .add(Retry(
                                                    loginState.user.token));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: primary3,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                "RETRY",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (state is LoadingState) {
                              return AnimatedBuilder(
                                animation: _orderInformationFadeAnimation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity:
                                        _orderInformationFadeAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  height: 90,
                                  width: AppUtil.getScreenWidth(context),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7)),
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Retrying...",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(width: 20),
                                      SpinKitCircle(
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (state.currentOrder.statusOrder == null ||
                                state is NoActiveOrderState ||
                                state is DeliveredOrderState ||
                                state is CancelledOrderState ||
                                state is InitialCurrentOrderState) {
                              return SizedBox();
                            }
                            return AnimatedOpacity(
                              opacity: state.isShowStatus == null
                                  ? 0.0
                                  : state.isShowStatus ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: AnimatedBuilder(
                                animation: _orderInformationScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale:
                                        _orderInformationScaleAnimation.value,
                                    child: child,
                                  );
                                },
                                child: AnimatedBuilder(
                                  animation: _orderInformationFadeAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity:
                                          _orderInformationFadeAnimation.value,
                                      child: child,
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 90,
                                        width: AppUtil.getScreenWidth(context),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 40,
                                            ),
                                            SvgPicture.asset(
                                              state.currentOrder.statusOrder
                                                  .getIconAssets(),
                                              width: 45,
                                              height: 45,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "ORDER NO - " +
                                                        state.currentOrder
                                                            .orderId,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    state.currentOrder
                                                        .statusOrder.status,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return TrackOrderPage();
                                                }));
                                              },
                                              child: Container(
                                                child: Text(
                                                  "Track Order",
                                                  style: TextStyle(
                                                      color: primary3),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<CurrentOrderBloc>(
                                                  context)
                                              .add(CloseStatusBox());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showReviewSheet(String token, String orderId) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return BlocConsumer<CurrentOrderBloc, CurrentOrderState>(
            listener: (context, state) {
              if (state is ErrorAddReview) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Error",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          state.message,
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
              } else if (state is SuccessAddReview) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              "Add Review To Order #" +
                                  state.currentOrder.orderId,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Divider(
                          height: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: state.currentOrder.merchantLogo,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  placeholder: (context, url) {
                                    return Shimmer.fromColors(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.black,
                                        ),
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[100]);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    state.currentOrder.merchantName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    state.currentOrder.merchantName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black26),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Rate Merchant",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SmoothStarRating(
                              rating: state.rating,
                              borderColor: primary3,
                              color: primary3,
                              size: 30,
                              allowHalfRating: true,
                              onRated: (rating) {
                                BlocProvider.of<CurrentOrderBloc>(context)
                                    .add(UpdateReviewRating(rating));
                              },
                              starCount: 5,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12)),
                        child: TextField(
                          onChanged: (value) {
                            BlocProvider.of<CurrentOrderBloc>(context)
                                .add(UpdateReviewComment(value));
                          },
                          maxLines: 4,
                          autofocus: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: "Enter your review",
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: state.isReviewValid() &&
                                !(state is LoadingAddReview)
                            ? () {
                                BlocProvider.of<CurrentOrderBloc>(context)
                                    .add(AddReview(token, orderId));
                              }
                            : () {},
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFB531),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: state is LoadingAddReview
                                  ? SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Text(
                                      "SUBMIT",
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ),
                            AnimatedOpacity(
                              opacity: state.isReviewValid() &&
                                      !(state is LoadingAddReview)
                                  ? 0.0
                                  : 0.5,
                              child: Container(
                                height: 50,
                                color: Colors.white,
                              ),
                              duration: Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _showScratchCard(
      String token, ScratchCard scratchCard, String currencyCode) {
    double opacity = 0.0;
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              return SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              "Scratch Card",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Divider(
                          height: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child:
                            Center(child: Text("You Have Won A Scratch Card!")),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Scratcher(
                          accuracy: ScratchAccuracy.medium,
                          brushSize: 50,
                          threshold: 25,
                          //color: appLogoBackground,
                          onThreshold: () {
                            newState(() {
                              opacity = 1.0;
                            });
                            BlocProvider.of<CurrentOrderBloc>(context).add(
                                ScratchCardEvent(token, scratchCard.cardId));
                          },
                          image: Image.asset(
                            "assets/scratch card.png",
                            fit: BoxFit.none,
                            width: AppUtil.getScreenWidth(context) - 100,
                            height: 0.7 * AppUtil.getScreenWidth(context) - 100,
                          ),
                          child: Container(
                            height: 0.7 * AppUtil.getScreenWidth(context),
                            width: AppUtil.getScreenWidth(context),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: opacity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: primary2,
                                  strokeWidth: 2,
                                  dashPattern: [8, 8, 8, 8],
                                  radius: Radius.circular(8),
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/scratch_won_icon.svg",
                                          height: 0.16 *
                                              0.7 *
                                              AppUtil.getScreenWidth(context),
                                          width: 0.16 *
                                              0.7 *
                                              AppUtil.getScreenWidth(context),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "You Won",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppUtil.getCurrencyIcon(
                                                  currencyCode),
                                              width: 30,
                                              height: 30,
                                              color: primary3,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppUtil.doubleRemoveZeroTrailing(
                                                  scratchCard.amount),
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                  color: primary3),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: AnimatedOpacity(
                              opacity: 1.0 - opacity,
                              duration: Duration(milliseconds: 300),
                              child: Text("Will Expiry On: " +
                                  scratchCard.dateExpiration)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _showContactConfirmation() {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(horizontalPaddingDraggable),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("NOTIFICATION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("Your Number",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Colors.black38)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                          AppUtil.formattedPhoneNumber(widget.contactNumber),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "will be used as login ID for next time and the OTP will be used as password",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFB531),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "GOT IT",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]));
        });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.isShowContactConfirmationSheet) {
      _showContactConfirmation();
    }
  }
}

class HomeActionWidget extends StatefulWidget {
  final Location location;

  const HomeActionWidget({Key key, this.location}) : super(key: key);

  @override
  _HomeActionWidgetState createState() => _HomeActionWidgetState();
}

class _HomeActionWidgetState extends State<HomeActionWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 2),
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 5),
        ],
      ),
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                "assets/banner1.jpg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Pickup and Drop",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "SAVE your Time, Energy, Fuel and Money",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        _animationController
                            .forward()
                            .orCancel
                            .whenComplete(() {
                          _animationController
                              .reverse()
                              .orCancel
                              .whenComplete(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DeliveryProcessOrderPage(
                                location: widget.location,
                              );
                            }));
                          });
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(2, 2),
                                  color: Colors.black38,
                                  spreadRadius: 0,
                                  blurRadius: 5),
                            ]),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Add Task",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IgnorePointer(
          child: Container(
            height: AppUtil.getScreenHeight(context) -
                AppUtil.getDraggableHeight(context),
            color: Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: AppUtil.getDraggableHeight(context),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32))),
            padding: EdgeInsets.only(
                top: 20,
                left: horizontalPaddingDraggable,
                right: horizontalPaddingDraggable),
            alignment: Alignment.center,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitCircle(
                      color: Colors.black38,
                      size: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Loading Locations..."),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeErrorWidget extends StatelessWidget {
  final String message;

  HomeErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IgnorePointer(
          child: Container(
            height: AppUtil.getScreenHeight(context) -
                AppUtil.getDraggableHeight(context),
            color: Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: AppUtil.getDraggableHeight(context),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32))),
            padding: EdgeInsets.only(
                top: 20,
                left: horizontalPaddingDraggable,
                right: horizontalPaddingDraggable),
            alignment: Alignment.center,
            child: Container(
              child: Center(
                child: Text(message),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class NoHomePageWidget extends StatelessWidget {
  final String location;

  const NoHomePageWidget({Key key, this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IgnorePointer(
          child: Container(
            height: AppUtil.getScreenHeight(context) -
                AppUtil.getDraggableHeight(context),
            color: Colors.transparent,
          ),
        ),
        Container(
          height: AppUtil.getDraggableHeight(context),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          padding: EdgeInsets.only(
              top: 20,
              left: horizontalPaddingDraggable,
              right: horizontalPaddingDraggable,
              bottom: 20),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/coming soon.svg",
                  height: AppUtil.getDraggableHeight(context) / 2.8),
              Text(
                "IN YOUR LOCATION",
                style: TextStyle(
                    fontSize: 25, color: primary3, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wish to start at your town?",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  String url =
                      'mailto:info@flyereats.in?subject=Request to Add New Location&body=Please add new location at $location';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text("info@flyereats.in",
                    style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        color: Colors.lightBlueAccent)),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SvgPicture.asset(
                  "assets/coming soon 2.svg",
                  height: 0.23 * AppUtil.getDraggableHeight(context),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class DefaultBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtil.getScreenHeight(context) -
          AppUtil.getDraggableHeight(context) +
          100,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: appLogoBackground),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  AppUtil.getAppLogo(),
                  alignment: Alignment.center,
                  width: AppUtil.getScreenWidth(context) - 140,
                  height: 0.46 * (AppUtil.getScreenWidth(context) - 140),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
