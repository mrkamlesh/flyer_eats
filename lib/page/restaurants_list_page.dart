import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/restaurant_list.dart';

class RestaurantListPage extends StatefulWidget {
  @required
  final String title;
  final String image;
  final bool isExternalImage;

  const RestaurantListPage(
      {Key key, this.title, this.image, this.isExternalImage = false})
      : super(key: key);

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;

  bool _isListMode = true;

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
              child: Container(
                width: AppUtil.getScreenWidth(context),
                height: AppUtil.getBannerHeight(context),
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: widget.isExternalImage
                        ? CachedNetworkImage(
                            imageUrl: widget.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )
                        : Image.asset(
                            widget.image,
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
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ListRestaurantFilterWidget(
                        title: widget.title,
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
                        size: 27,
                      ),
                    ),
                    RestaurantListWidget(
                      restaurants: ExampleModel.getRestaurants(),
                      fade: 0.4,
                      scale: 0.95,
                      type: _isListMode
                          ? RestaurantViewType.detailList
                          : RestaurantViewType.detailGrid,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ListRestaurantFilterWidget extends SliverPersistentHeaderDelegate {
  final Function onListButtonTap;
  final Function onGridButtonTap;
  final bool isListSelected;
  final double size;
  final String title;

  ListRestaurantFilterWidget({
    this.title,
    this.onListButtonTap,
    this.onGridButtonTap,
    this.isListSelected,
    this.size,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(
            left: horizontalPaddingDraggable,
            right: horizontalPaddingDraggable,
            top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
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
                          color:
                              isListSelected ? Colors.green : Colors.grey[100],
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
                          color:
                              !isListSelected ? Colors.green : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6)),
                      duration: Duration(milliseconds: 300),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
