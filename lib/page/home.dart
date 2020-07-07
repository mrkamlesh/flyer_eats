import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/currentorder/current_order_bloc.dart';
import 'package:flyereats/bloc/currentorder/current_order_event.dart';
import 'package:flyereats/bloc/currentorder/current_order_state.dart';
import 'package:flyereats/bloc/location/location_bloc.dart';
import 'package:flyereats/bloc/location/location_event.dart';
import 'package:flyereats/bloc/location/location_state.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/model/home_page_data.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/model/scratch_card.dart';
import 'package:flyereats/page/cancelled_order_page.dart';
import 'package:flyereats/page/delivery_process_order_page.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
import 'package:flyereats/page/search_page.dart';
import 'package:flyereats/page/select_location_page.dart';
import 'package:flyereats/page/track_order_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/banner_list_widget.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:flyereats/widget/food_category_list.dart';
import 'package:flyereats/widget/promo_list.dart';
import 'package:flyereats/widget/restaurant_list.dart';
import 'package:flyereats/widget/shop_category_list.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  Animation<double> _orderInformationAnimation;

  HomePageData _homePageData;

  @override
  initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _orderInformationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    //_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LoadingLocation ||
                state is LoadingLocationSuccess ||
                state is LoadingLocationError ||
                state is NoLocationsAvailable) {
              return SizedBox(
                height: 0,
              );
            }
            if (state is HomePageDataLoaded) {
              _homePageData = state.data;
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
                        BottomNavyBarItem(icon: "assets/2.svg", title: "Flyer Eats"),
                        BottomNavyBarItem(icon: "assets/4.svg", title: "Offers"),
                        BottomNavyBarItem(icon: "assets/1.svg", title: "Search"),
                        BottomNavyBarItem(icon: "assets/3.svg", title: "Order")
                      ],
                      onItemSelected: (index) {
                        setState(() {
                          _currentIndex = index;
                          if (index == 2) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return SearchPage(
                                address: _homePageData.location,
                                token: loginState.user.token,
                              );
                            }));
                          } else if (index == 3) {
                            Navigator.pushNamed(context, "/orderHistory");
                          }
                        });
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
          BlocBuilder<LocationBloc, LocationState>(condition: (oldState, state) {
            if (state is HomePageDataLoaded ||
                state is NoLocationsAvailable ||
                state is LoadingLocationError ||
                state is LoadingLocation) {
              return true;
            } else {
              return false;
            }
          }, builder: (context, state) {
            if (state is HomePageDataLoaded) {
              _homePageData = state.data;
              if (_homePageData.promos.isNotEmpty) {
                return Positioned(
                  top: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: BannerListWidget(
                      bannerList: _homePageData.promos,
                    ),
                  ),
                );
              } else {
                return DefaultBanner();
              }
            }
            return DefaultBanner();
          }),
          Align(
            alignment: Alignment.topCenter,
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                return BlocConsumer<LocationBloc, LocationState>(
                  buildWhen: (oldState, state) {
                    if (state is LoadingLocation ||
                        state is LoadingLocationSuccess ||
                        state is LoadingLocationError ||
                        state is NoLocationsAvailable ||
                        state is HomePageDataLoaded) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  listenWhen: (oldState, state) {
                    if (state is NoLocationsAvailable ||
                        state is LoadingLocationError ||
                        state is LoadingLocationSuccess ||
                        state is HomePageDataLoaded) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  listener: (context, state) {
                    if (state is LoadingLocationError) {
                      final snackBar = SnackBar(
                        content: Text(state.message),
                        duration: Duration(days: 365),
                        action: SnackBarAction(
                          label: "Retry",
                          onPressed: () {
                            BlocProvider.of<LocationBloc>(context).add(GetCurrentLocation(loginState.user.token));
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else if (state is NoLocationsAvailable) {
                      final snackBar = SnackBar(
                        content: Text(state.message),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else if (state is HomePageDataLoaded) {}
                  },
                  builder: (context, state) {
                    String titleText = "Choose Location Here";
                    String leading;
                    bool isLoading = false;
                    bool isDropdownVisible = false;
                    bool isFlag = false;
                    if (state is LoadingLocationSuccess) {
                      titleText = "Loading Location...";
                      isLoading = true;
                      isDropdownVisible = false;
                    } else if (state is NoLocationsAvailable) {
                      titleText = "No Locations Available";
                      isLoading = false;
                      isDropdownVisible = true;
                    } else if (state is LoadingLocationError) {
                      titleText = "Click Here to Choose Location";
                      isLoading = false;
                      isDropdownVisible = true;
                    } else if (state is HomePageDataLoaded) {
                      titleText = state.data.location;
                      isLoading = false;
                      isDropdownVisible = true;
                      switch (state.data.countryId) {
                        case "IN":
                          leading = "assets/india_flag.svg";
                          break;
                        case "SG":
                          leading = "assets/singapore_flag.svg";
                          break;
                        default:
                          leading = "";
                      }
                      _homePageData = state.data;
                      isFlag = true;
                    } else if (state is LoadingLocation) {
                      titleText = "Loading Location...";
                      isLoading = true;
                      isDropdownVisible = false;
                    }

                    return Builder(
                      builder: (context) {
                        return CustomAppBar(
                          isDropDownButtonVisible: isDropdownVisible,
                          leading: leading,
                          isFlag: isFlag,
                          drawer: "assets/drawer.svg",
                          title: titleText,
                          isLoading: isLoading,
                          onTapTitle: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return SelectLocationPage();
                            }));
                          },
                          onTapLeading: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return SelectLocationPage();
                            }));
                          },
                          onTapDrawer: () {
                            Scaffold.of(context).openEndDrawer();
                            //Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<LocationBloc, LocationState>(
            condition: (oldState, state) {
              if (state is LoadingLocation ||
                  state is LoadingLocationSuccess ||
                  state is LoadingLocationError ||
                  state is NoLocationsAvailable ||
                  state is HomePageDataLoaded) {
                return true;
              } else {
                return false;
              }
            },
            builder: (context, state) {
              if (state is LoadingLocation || state is LoadingLocationSuccess) {
                return Center(child: HomeLoadingWidget());
              } else if (state is LoadingLocationError) {
                return Center(child: HomeErrorWidget("Can Not Get Location"));
              } else if (state is NoLocationsAvailable) {
                return HomeErrorWidget("No Available Location");
              } else if (state is HomePageDataLoaded) {
                return DraggableScrollableSheet(
                  initialChildSize: AppUtil.getDraggableHeight(context) / AppUtil.getScreenHeight(context),
                  minChildSize: AppUtil.getDraggableHeight(context) / AppUtil.getScreenHeight(context),
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
                    return SingleChildScrollView(
                        controller: controller,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(top: 10, bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable - 5),
                                margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                height: 115,
                                child: ShopCategoryListWidget(
                                  onTap: (i) {
                                    if (i == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return RestaurantListPage(
                                          image: "assets/allrestaurant.png",
                                          merchantType: MerchantType.restaurant,
                                          isExternalImage: false,
                                          title: "All Restaurants",
                                          location: Location(address: _homePageData.location),
                                        );
                                      }));
                                    } else if (i == 1) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return RestaurantListPage(
                                          image: "assets/allrestaurant.png",
                                          merchantType: MerchantType.grocery,
                                          isExternalImage: false,
                                          title: "All Restaurants",
                                          location: Location(address: _homePageData.location),
                                        );
                                      }));
                                    } else if (i == 2) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return RestaurantListPage(
                                          image: "assets/allrestaurant.png",
                                          merchantType: MerchantType.vegFruits,
                                          isExternalImage: false,
                                          title: "All Restaurants",
                                          location: Location(address: _homePageData.location),
                                        );
                                      }));
                                    } else if (i == 3) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return RestaurantListPage(
                                          image: "assets/allrestaurant.png",
                                          merchantType: MerchantType.meat,
                                          isExternalImage: false,
                                          title: "All Restaurants",
                                          location: Location(address: _homePageData.location),
                                        );
                                      }));
                                    }
                                  },
                                  shopCategories: ExampleModel.getShopCategories(),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                      bottom: distanceSectionContent,
                                      top: 5),
                                  child: HomeActionWidget()),
                              _homePageData.topRestaurants.isNotEmpty
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                          margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Top Restaurants",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return RestaurantListPage(
                                                      title: "Top Restaurants",
                                                      location: Location(address: _homePageData.location),
                                                      type: RestaurantListType.top,
                                                      merchantType: MerchantType.restaurant,
                                                      isExternalImage: false,
                                                      image: "assets/allrestaurant.png",
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  width: 70,
                                                  height: 20,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "See All",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(color: primary3, fontSize: 14),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: distanceBetweenSection - 20),
                                          height: 160,
                                          child: RestaurantListWidget(
                                            type: RestaurantViewType.topRestaurant,
                                            restaurants: _homePageData.topRestaurants,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                    ),
                              _homePageData.categories.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                          margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                          child: Text(
                                            "Food Categories",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: distanceBetweenSection - 10),
                                          height: 130,
                                          decoration: BoxDecoration(color: Colors.white, boxShadow: [
                                            BoxShadow(
                                                offset: Offset(2, 2),
                                                color: Colors.black26,
                                                spreadRadius: 0,
                                                blurRadius: 5)
                                          ]),
                                          child: FoodCategoryListWidget(
                                            onTap: (category) {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return RestaurantListPage(
                                                  title: category.name,
                                                  image: category.image,
                                                  merchantType: MerchantType.restaurant,
                                                  category: category.id,
                                                  isExternalImage: true,
                                                  location: Location(address: _homePageData.location),
                                                );
                                              }));
                                            },
                                            foodCategoryList: _homePageData.categories,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(bottom: distanceBetweenSection - 10),
                                    ),
                              _homePageData.orderAgainRestaurants.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                          margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Order Again",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return RestaurantListPage(
                                                      title: "Order Again",
                                                      merchantType: MerchantType.restaurant,
                                                      type: RestaurantListType.orderAgain,
                                                      location: Location(address: _homePageData.location),
                                                      isExternalImage: false,
                                                      image: "assets/allrestaurant.png",
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 70,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "See All",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(color: primary3, fontSize: 14),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                          height: 150,
                                          child: RestaurantListWidget(
                                            type: RestaurantViewType.orderAgainRestaurant,
                                            restaurants: _homePageData.orderAgainRestaurants,
                                            isExpand: true,
                                            location: Location(address: state.data.location),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(bottom: distanceSectionContent - 10),
                                    ),
                              Container(
                                margin: EdgeInsets.only(bottom: distanceBetweenSection - 10),
                                height: 0.16 * AppUtil.getScreenHeight(context),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFC94B),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)],
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 0.16 * AppUtil.getScreenHeight(context) - 20,
                                      height: 0.16 * AppUtil.getScreenHeight(context) - 20,
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "assets/order success icon 2.svg",
                                            height: 40,
                                            width: 40,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Refer Now",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "REFER A FRIEND AND EARN",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Get a coupon worth",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/rupee.svg",
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "100",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          FittedBox(
                                            fit: BoxFit.none,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Use Referal Code: ",
                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "HHHHHH",
                                                    style: TextStyle(
                                                      color: primary3,
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
                              _homePageData.ads.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: distanceBetweenSection - 10),
                                      height: 140,
                                      child: PromoListWidget(
                                        promoList: _homePageData.ads,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(bottom: distanceBetweenSection - 10),
                                    ),
                              _homePageData.dblRestaurants.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: distanceBetweenSection + distanceSectionContent),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: distanceSectionContent - 10,
                                                right: horizontalPaddingDraggable,
                                                left: horizontalPaddingDraggable),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "It's Dinner Time",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return RestaurantListPage(
                                                        title: "It's Dinner Time",
                                                        merchantType: MerchantType.restaurant,
                                                        location: Location(address: _homePageData.location),
                                                        type: RestaurantListType.dbl,
                                                        isExternalImage: false,
                                                        image: "assets/allrestaurant.png",
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    width: 70,
                                                    height: 20,
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      "See All",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(color: primary3, fontSize: 14),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 225,
                                            padding: EdgeInsets.only(
                                                top: distanceSectionContent, bottom: distanceSectionContent),
                                            margin: EdgeInsets.only(bottom: distanceSectionContent),
                                            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(2, 2),
                                                  color: Colors.black26,
                                                  spreadRadius: 0,
                                                  blurRadius: 5)
                                            ]),
                                            alignment: Alignment.center,
                                            child: RestaurantListWidget(
                                              type: RestaurantViewType.dinnerTimeRestaurant,
                                              restaurants: _homePageData.dblRestaurants,
                                              location: Location(address: state.data.location),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(bottom: distanceBetweenSection + distanceSectionContent),
                                    ),
                            ],
                          ),
                        ));
                  },
                );
              }
              return Container();
            },
          ),
          Positioned(
            bottom: kBottomNavigationBarHeight,
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                return BlocConsumer<CurrentOrderBloc, CurrentOrderState>(
                  listener: (context, state) {
                    if (state is DeliveredOrderState) {
                      if (state.currentOrder.isShowReview) {
                        _showReviewSheet(loginState.user.token, state.currentOrder.orderId);
                      }
                      if (state.currentOrder.isShowScratch) {
                        _showScratchCard(loginState.user.token, state.currentOrder.scratchCard);
                      }
                    } else if (state is CancelledOrderState) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CancelledOrderPage(
                          token: loginState.user.token,
                          orderId: state.currentOrder.orderId,
                          address: _homePageData != null ? _homePageData.location : null,
                        );
                      }));
                    }
                  },
                  builder: (context, state) {
                    if (state is ErrorState) {
                      return AnimatedBuilder(
                        animation: _orderInformationAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _orderInformationAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          height: 90,
                          width: AppUtil.getScreenWidth(context),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Connection Error",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<CurrentOrderBloc>(context).add(Retry(loginState.user.token));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(color: primary3, borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "RETRY",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is LoadingState) {
                      return AnimatedBuilder(
                        animation: _orderInformationAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _orderInformationAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          height: 90,
                          width: AppUtil.getScreenWidth(context),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
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
                        state is CancelledOrderState) {
                      return SizedBox();
                    }
                    return AnimatedBuilder(
                      animation: _orderInformationAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _orderInformationAnimation.value,
                          child: child,
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 90,
                            width: AppUtil.getScreenWidth(context),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                ),
                                SvgPicture.asset(
                                  state.currentOrder.statusOrder.getIconAssets(),
                                  width: 45,
                                  height: 45,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "ORDER NO - " + state.currentOrder.orderId,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        state.currentOrder.statusOrder.status,
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return TrackOrderPage();
                                    }));
                                  },
                                  child: Container(
                                    child: Text(
                                      "Track Order",
                                      style: TextStyle(color: primary3),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ))
                        ],
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
  }

  void _showReviewSheet(String token, String orderId) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
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
                              "Add Review To Order #" + state.currentOrder.orderId,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    state.currentOrder.merchantName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: Colors.black26),
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
                                BlocProvider.of<CurrentOrderBloc>(context).add(UpdateReviewRating(rating));
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
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
                        child: TextField(
                          onChanged: (value) {
                            BlocProvider.of<CurrentOrderBloc>(context).add(UpdateReviewComment(value));
                          },
                          maxLines: 4,
                          autofocus: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              hintText: "Enter your review",
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: state.isReviewValid() && !(state is LoadingAddReview)
                            ? () {
                                BlocProvider.of<CurrentOrderBloc>(context).add(AddReview(token, orderId));
                              }
                            : () {},
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                              opacity: state.isReviewValid() && !(state is LoadingAddReview) ? 0.0 : 0.5,
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

  void _showScratchCard(String token, ScratchCard scratchCard) {
    double opacity = 0.0;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        child: Center(child: Text("You Have Won A Scratch Card!")),
                      ),
                      Scratcher(
                        accuracy: ScratchAccuracy.medium,
                        brushSize: 50,
                        threshold: 25,
                        color: Colors.black,
                        onThreshold: () {
                          newState(() {
                            opacity = 1.0;
                          });
                          BlocProvider.of<CurrentOrderBloc>(context).add(ScratchCardEvent(token, scratchCard.cardId));
                        },
                        image: Image.asset(
                          "assets/flyereatslogo.png",
                          fit: BoxFit.none,
                          width: AppUtil.getScreenWidth(context) - 100,
                          height: 0.7 * AppUtil.getScreenWidth(context) - 100,
                        ),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: opacity,
                          child: Container(
                            height: 0.7 * AppUtil.getScreenWidth(context),
                            width: AppUtil.getScreenWidth(context),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Center(
                              child: Text(
                                "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(scratchCard.amount),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: primary3),
                              ),
                            ),
                          ),
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
}

class HomeActionWidget extends StatefulWidget {
  @override
  _HomeActionWidgetState createState() => _HomeActionWidgetState();
}

class _HomeActionWidgetState extends State<HomeActionWidget> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.90).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
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
          BoxShadow(offset: Offset(2, 2), color: Colors.black38, spreadRadius: 0, blurRadius: 5),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Sample dummy text to be replaced here",
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
                        _animationController.forward().orCancel.whenComplete(() {
                          _animationController.reverse().orCancel.whenComplete(() {});
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          _animationController.forward().orCancel.whenComplete(() {
                            _animationController
                                .reverse()
                                .orCancel
                                .whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return DeliveryProcessOrderPage();
                                    })));
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration:
                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60), boxShadow: [
                            BoxShadow(offset: Offset(2, 2), color: Colors.black38, spreadRadius: 0, blurRadius: 5),
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
            height: AppUtil.getScreenHeight(context) - AppUtil.getDraggableHeight(context),
            color: Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: AppUtil.getDraggableHeight(context),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
            padding: EdgeInsets.only(top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
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

  const HomeErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      condition: (context, state) {
        if (state is NoLocationsAvailable || state is LoadingLocationError) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is NoLocationsAvailable) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IgnorePointer(
                child: Container(
                  height: AppUtil.getScreenHeight(context) - AppUtil.getDraggableHeight(context),
                  color: Colors.transparent,
                ),
              ),
              Container(
                height: AppUtil.getDraggableHeight(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset("assets/coming soon.svg", height: AppUtil.getDraggableHeight(context) / 2.5),
                    Text(
                      "IN YOUR LOCATION",
                      style: TextStyle(fontSize: 25, color: primary3, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Wish to start at your town?",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("info@flyereats.in",
                        style: TextStyle(
                            fontSize: 20, decoration: TextDecoration.underline, color: Colors.lightBlueAccent)),
                    SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset(
                      "assets/coming soon 2.svg",
                      height: 0.23 * AppUtil.getDraggableHeight(context),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is LoadingLocationError) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IgnorePointer(
                child: Container(
                  height: AppUtil.getScreenHeight(context) - AppUtil.getDraggableHeight(context),
                  color: Colors.transparent,
                ),
              ),
              Container(
                height: AppUtil.getDraggableHeight(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                alignment: Alignment.center,
                child: Container(
                  child: Center(
                    child: Text("Error Get Your Location"),
                  ),
                ),
              )
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}

class DefaultBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtil.getScreenHeight(context) - AppUtil.getDraggableHeight(context) + 100,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  "assets/flyereatslogo.png",
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
