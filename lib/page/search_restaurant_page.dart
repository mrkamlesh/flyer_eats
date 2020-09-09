import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/searchrestaurant/search_restaurant_bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/offers_list_page.dart';
import 'package:clients/page/restaurant_place_order_page.dart';
import 'package:clients/widget/custom_bottom_navigation_bar.dart';
import 'package:clients/widget/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchRestaurantPage extends StatefulWidget {
  final String token;
  final String address;

  const SearchRestaurantPage({Key key, this.token, this.address})
      : super(key: key);

  @override
  _SearchRestaurantPageState createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 2;
  bool _isScrollingDown = false;
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  ScrollController _scrollController;

  SearchRestaurantBloc _bloc = SearchRestaurantBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
      return BlocBuilder<FoodOrderBloc, FoodOrderState>(
        builder: (context, cartState) {
          return BlocProvider<SearchRestaurantBloc>(
            create: (context) {
              return _bloc;
            },
            child: Scaffold(
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
                  child: CustomBottomNavBar(
                    animationDuration: Duration(milliseconds: 300),
                    items: [
                      BottomNavyBarItem(
                          icon: "assets/2.svg", title: "Flyer Eats"),
                      BottomNavyBarItem(icon: "assets/4.svg", title: "Offers"),
                      BottomNavyBarItem(icon: "assets/1.svg", title: "Search"),
                      BottomNavyBarItem(
                          icon: "assets/3.svg",
                          title: "Order",
                          badge: cartState.placeOrder.foodCart.cartItemTotal())
                    ],
                    onItemSelected: (index) async {
                      setState(() async {
                        _currentIndex = index;
                        if (index == 0) {
                          /*await Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Home();
                          }));*/
                          Navigator.pop(context);
                          _currentIndex = 2;
                        } else if (index == 1) {
                          await Navigator.pushReplacement(context,
                              PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) {
                            return OfferListPage(
                              address: widget.address,
                            );
                          }));
                          _currentIndex = 2;
                        } else if (index == 3) {
                          await Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, anim1, anim2) {
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
              body: Container(
                height: AppUtil.getScreenHeight(context),
                width: AppUtil.getScreenWidth(context),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              distanceBetweenSection,
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable,
                          bottom: distanceBetweenSection),
                      child: CustomTextField(
                        onSubmitted: (value) {
                          _bloc.add(SearchRestaurant(
                              widget.token, widget.address, value));
                        },
                        hint: "Search Restaurant",
                      ),
                    ),
                    BlocBuilder<SearchRestaurantBloc, SearchRestaurantState>(
                        builder: (context, state) {
                      if (state is LoadingNewSearchRestaurant) {
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
                      } else if (state is InitialSearchRestaurantState) {
                        return SizedBox();
                      } else if (state is ErrorNewSearchRestaurant) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 30,
                              right: horizontalPaddingDraggable,
                              left: horizontalPaddingDraggable),
                          child: Text(
                            state.message,
                            style:
                                TextStyle(color: Colors.black38, fontSize: 14),
                          ),
                        );
                      } else if (state is NoAvailableSearchRestaurant) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 30,
                              right: horizontalPaddingDraggable,
                              left: horizontalPaddingDraggable),
                          child: Text(
                            "No result for your search",
                            style:
                                TextStyle(color: Colors.black38, fontSize: 14),
                          ),
                        );
                      }

                      return Expanded(
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: <Widget>[
                            RestaurantListWidget(
                              type: RestaurantViewType.searchRestaurantResult,
                              location: Location(address: widget.address),
                              restaurants: state.restaurants,
                              fade: 0.4,
                              scale: 0.95,
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight +
                                    distanceBetweenSection,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String) onSubmitted;

  const CustomTextField({
    Key key,
    this.hint,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: primary1,
                blurRadius: 10,
                spreadRadius: -4,
                offset: Offset(-4, 4))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primary1, width: 2)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                hintText: hint == null ? "" : hint,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ),
          ),
          /*Icon(
            Icons.search,
            color: Colors.black38,
          ),*/
        ],
      ),
    );
  }
}
