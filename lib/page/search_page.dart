import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/restaurant_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
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
                  if (index == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchPage();
                    }));
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
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, bool) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top +
                        distanceBetweenSection,
                    left: horizontalPaddingDraggable,
                    right: horizontalPaddingDraggable),
                child: CustomTextField(
                  hint: "SEARCH ANYTHING",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: TabBar(
                  onTap: (index) {},
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: Colors.yellow[600],
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  indicatorPadding:
                      EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
                  labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
                  tabs: <Widget>[
                    Tab(
                      text: "Restaurants",
                    ),
                    Tab(
                      text: "Items",
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Builder(
              builder: (context) {
                return CustomScrollView(
                  slivers: <Widget>[
                    RestaurantListWidget(
                      restaurants: ExampleModel.getRestaurants(),
                      fade: 0.4,
                      scale: 0.95,
                      type: RestaurantViewType.detailGrid,
                    ),
                  ],
                );
              },
            ),
            Builder(
              builder: (context) {
                return CustomScrollView(
                  slivers: <Widget>[
                    RestaurantListWidget(
                      restaurants: ExampleModel.getRestaurants(),
                      fade: 0.4,
                      scale: 0.95,
                      type: RestaurantViewType.detailGrid,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),

      /*body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top +
                      distanceBetweenSection,
                  left: horizontalPaddingDraggable,
                  right: horizontalPaddingDraggable),
              child: CustomTextField(
                hint: "SEARCH ANYTHING",
              ),
            ),
            TabBar(
              onTap: (index) {

              },
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black26,
              indicatorColor: Colors.yellow[600],
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorPadding:
                  EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
              labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
              tabs: <Widget>[
                Tab(
                  text: "Restaurants",
                ),
                Tab(
                  text: "Items",
                ),
              ],
            ),
          ],
        ),
      ),*/
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: primary3,
                blurRadius: 10,
                spreadRadius: -4,
                offset: Offset(-4, 4))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primary3, width: 2)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                hintText: hint == null ? "" : hint,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
