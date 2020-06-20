import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/location/location_bloc.dart';
import 'package:flyereats/bloc/location/location_event.dart';
import 'package:flyereats/bloc/location/location_state.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/model/home_page_data.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/page/delivery_process_order_page.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
import 'package:flyereats/page/search_page.dart';
import 'package:flyereats/page/select_location_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/banner_list_widget.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:flyereats/widget/food_category_list.dart';
import 'package:flyereats/widget/promo_list.dart';
import 'package:flyereats/widget/restaurant_list.dart';
import 'package:flyereats/widget/shop_category_list.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;

  HomePageData _homePageData;

  @override
  initState() {
    super.initState();

    AppUtil.checkLocationServiceAndPermission();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            if (state is HomePageDataLoaded) {
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
                  child: CustomBottomNavBar(
                    animationDuration: Duration(milliseconds: 300),
                    items: [
                      BottomNavyBarItem(
                          icon: "assets/2.svg", title: "Flyer Eats"),
                      BottomNavyBarItem(icon: "assets/4.svg", title: "Offers"),
                      BottomNavyBarItem(icon: "assets/1.svg", title: "Search"),
                      BottomNavyBarItem(icon: "assets/3.svg", title: "Order")
                    ],
                    onItemSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                        if (index == 2) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SearchPage();
                          }));
                        } else if (index == 3) {
                          Navigator.pushNamed(context, "/orderHistory");
                        }
                      });
                    },
                    selectedIndex: _currentIndex,
                    selectedColor: Colors.orange[700],
                    unselectedColor: Colors.black26,
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          BlocBuilder<LocationBloc, LocationState>(
              condition: (oldState, state) {
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
              return Positioned(
                top: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: BannerListWidget(
                    bannerList: _homePageData.promos,
                  ),
                ),
              );
            } else if (state is NoLocationsAvailable ||
                state is LoadingLocationError ||
                state is LoadingLocation) {
              return Container(
                height: AppUtil.getScreenHeight(context) -
                    AppUtil.getDraggableHeight(context) +
                    100,
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
                            height:
                                0.46 * (AppUtil.getScreenWidth(context) - 140),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
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
                            BlocProvider.of<LocationBloc>(context)
                                .add(GetCurrentLocation(loginState.user.token));
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
                    bool isFlag = false;
                    if (state is LoadingLocationSuccess) {
                      titleText = "Loading Location...";
                      isLoading = true;
                    } else if (state is NoLocationsAvailable) {
                      titleText = "No Locations Available";
                      isLoading = false;
                    } else if (state is LoadingLocationError) {
                      titleText = "Click Here to Choose Location";
                      isLoading = false;
                    } else if (state is HomePageDataLoaded) {
                      titleText = state.data.location;
                      isLoading = false;
                      switch (state.data.countryId) {
                        case "101":
                          leading = "assets/india_flag.svg";
                          break;
                        case "196":
                          leading = "assets/singapore_flag.svg";
                          break;
                      }
                      _homePageData = state.data;
                      isFlag = true;
                    } else if (state is LoadingLocation) {
                      titleText = "Loading Location...";
                      isLoading = true;
                    }

                    return Builder(
                      builder: (context) {
                        return CustomAppBar(
                          leading: leading,
                          isFlag: isFlag,
                          drawer: "assets/drawer.svg",
                          title: titleText,
                          isLoading: isLoading,
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
                                    horizontal: horizontalPaddingDraggable - 5),
                                margin: EdgeInsets.only(
                                    bottom: distanceSectionContent - 10),
                                height: 110,
                                child: ShopCategoryListWidget(
                                  onTap: (i) {
                                    if (i == 0) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RestaurantListPage(
                                          image: "assets/allrestaurant.png",
                                          isExternalImage: false,
                                          title: "All Restaurants",
                                          location: Location(
                                              address: _homePageData.location),
                                        );
                                      }));
                                    }
                                  },
                                  shopCategories:
                                      ExampleModel.getShopCategories(),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                      bottom: distanceSectionContent,
                                      top: 5),
                                  child: HomeActionWidget()),
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPaddingDraggable),
                                    margin: EdgeInsets.only(
                                        bottom: distanceSectionContent - 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Top Restaurants",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return RestaurantListPage(
                                                title: "Top Restaurants",
                                                isExternalImage: false,
                                                image:
                                                    "assets/allrestaurant.png",
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
                                        bottom: distanceBetweenSection - 10),
                                    height: 160,
                                    child: RestaurantListWidget(
                                      type: RestaurantViewType.topRestaurant,
                                      restaurants: _homePageData.topRestaurants,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPaddingDraggable),
                                margin: EdgeInsets.only(
                                    bottom: distanceSectionContent - 10),
                                child: Text(
                                  "Food Categories",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: distanceBetweenSection - 10),
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
                                  foodCategoryList:
                                      _homePageData.categories,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPaddingDraggable),
                                margin: EdgeInsets.only(
                                    bottom: distanceSectionContent - 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Order Again",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return RestaurantListPage(
                                            title: "Order Again",
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
                                          style: TextStyle(
                                              color: primary3, fontSize: 14),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: distanceSectionContent - 10),
                                height: 135,
                                child: RestaurantListWidget(
                                  type: RestaurantViewType.orderAgainRestaurant,
                                  restaurants: _homePageData.orderAgainRestaurants,
                                  isExpand: true,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: distanceBetweenSection - 10),
                                height: 120,
                                width: AppUtil.getScreenWidth(context),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://cdn6.f-cdn.com/contestentries/1146228/26247298/59d210472a379_thumb900.jpg",
                                  height: 130,
                                  width: AppUtil.getScreenWidth(context),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  placeholder: (context, url) {
                                    return Shimmer.fromColors(
                                        child: Container(
                                          height: 130,
                                          width:
                                              AppUtil.getScreenWidth(context),
                                          color: Colors.black,
                                        ),
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[100]);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: distanceBetweenSection - 10),
                                height: 140,
                                child: PromoListWidget(
                                  promoList: _homePageData.ads,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPaddingDraggable),
                                margin: EdgeInsets.only(
                                    bottom: distanceSectionContent - 10),
                                child: Text(
                                  "It's Dinner Time",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 190,
                                padding: EdgeInsets.only(
                                    top: distanceSectionContent,
                                    bottom: distanceSectionContent),
                                margin: EdgeInsets.only(
                                    bottom: distanceBetweenSection +
                                        distanceSectionContent),
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
                                  type: RestaurantViewType.topRestaurant,
                                  restaurants: ExampleModel.getRestaurants(),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class HomeActionWidget extends StatefulWidget {
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
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "Sample dummy text to be replaced here",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                    ],
                  ),
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
                              .whenComplete(() {});
                        });
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
                                .whenComplete(() => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DeliveryProcessOrderPage();
                                    })));
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
        Container(
          height: AppUtil.getDraggableHeight(context),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(
                    top: 20,
                    left: horizontalPaddingDraggable,
                    right: horizontalPaddingDraggable),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset("assets/coming soon.svg",
                        height: AppUtil.getDraggableHeight(context) / 2.5),
                    Text(
                      "IN YOUR LOCATION",
                      style: TextStyle(
                          fontSize: 25,
                          color: primary3,
                          fontWeight: FontWeight.bold),
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
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: Colors.lightBlueAccent)),
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
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(
                    top: 20,
                    left: horizontalPaddingDraggable,
                    right: horizontalPaddingDraggable),
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
