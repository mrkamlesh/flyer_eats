import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/page/delivery_process_order_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/banner_list_widget.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/food_category_list.dart';
import 'package:flyereats/widget/promo_list.dart';
import 'package:flyereats/widget/restaurant_list.dart';
import 'package:flyereats/widget/shop_category_list.dart';
import 'package:flyereats/classes/example_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;

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
      bottomNavigationBar: AnimatedBuilder(
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
                BottomNavyBarItem(icon: "assets/3.svg", title: "Order")
              ],
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedIndex: _currentIndex,
              selectedColor: Colors.orange[700],
              unselectedColor: Colors.black26,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: BannerListWidget(
                bannerList: ExampleModel.getBanners(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              leading: "assets/location.svg",
              drawer: "assets/drawer.svg",
              title: "No 217, C Block, Vascon Venus",
              onTapLeading: () {},
              onTapDrawer: () {},
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: AppUtil.getDraggableHeight(context) /
                AppUtil.getScreenHeight(context),
            minChildSize: AppUtil.getDraggableHeight(context) /
                AppUtil.getScreenHeight(context),
            maxChildSize: 1.0,
            builder: (context, controller) {
              controller.addListener(() {
                if (controller.position.userScrollDirection ==
                    ScrollDirection.reverse) {
                  if (!isScrollingDown) {
                    isScrollingDown = true;
                    setState(() {
                      _animationController.forward().orCancel;
                    });
                  }
                }
                if (controller.position.userScrollDirection ==
                    ScrollDirection.forward) {
                  if (isScrollingDown) {
                    isScrollingDown = false;
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
                              horizontal: horizontalPaddingDraggable),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          height: 110,
                          child: ShopCategoryListWidget(
                            shopCategories: ExampleModel.getShopCategories(),
                          ),
                        ),
                        HomeActionWidget(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          child: Text(
                            "Top Restaurants",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: distanceBetweenSection),
                          height: 120,
                          child: RestaurantListWidget(
                            type: RestaurantViewType.home,
                            restaurants: ExampleModel.getRestaurants(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          child: Text(
                            "Food Categories",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: distanceBetweenSection),
                          height: 130,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                offset: Offset(2, 2),
                                color: Colors.black26,
                                spreadRadius: 0,
                                blurRadius: 5)
                          ]),
                          child: FoodCategoryListWidget(
                            foodCategoryList: ExampleModel.getFoodCategories(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          child: Text(
                            "Reorder from Your Favourite",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: distanceBetweenSection),
                          height: 200,
                          child: RestaurantListWidget(
                            type: RestaurantViewType.home,
                            restaurants: ExampleModel.getRestaurants(),
                            isExpand: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          child: Text(
                            "It is Dinner Time",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: distanceBetweenSection),
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                offset: Offset(2, 2),
                                color: Colors.black26,
                                spreadRadius: 0,
                                blurRadius: 5)
                          ]),
                          height: 230,
                          child: RestaurantListWidget(
                            type: RestaurantViewType.home,
                            restaurants: ExampleModel.getRestaurants(),
                            isExpand: true,
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: distanceBetweenSection),
                          height: 150,
                          child: PromoListWidget(
                            promoList: ExampleModel.getPromos(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingDraggable),
                          margin:
                              EdgeInsets.only(bottom: distanceSectionContent),
                          child: Text(
                            "Nearby Restaurant",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 120,
                          child: RestaurantListWidget(
                            type: RestaurantViewType.home,
                            restaurants: ExampleModel.getRestaurants(),
                          ),
                        ),
                      ],
                    ),
                  ));
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 2),
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 5),
        ],
      ),
      margin: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          bottom: distanceSectionContent + 10,
          top: 5),
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
