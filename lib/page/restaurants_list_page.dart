import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/bloc/restaurantlist/restaurantlist_bloc.dart';
import 'package:flyereats/bloc/restaurantlist/restaurantlist_event.dart';
import 'package:flyereats/bloc/restaurantlist/restaurantlist_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/custom_bottom_navigation_bar.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:flyereats/widget/restaurant_list.dart';

class RestaurantListPage extends StatefulWidget {
  @required
  final String title;
  final String image;
  final bool isExternalImage;
  final Location location;
  final RestaurantListType type;
  final MerchantType merchantType;
  final String category;

  const RestaurantListPage(
      {Key key,
      this.title,
      this.image,
      this.isExternalImage = false,
      this.location,
      this.type,
      this.category,
      this.merchantType})
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
  int _selectedFilter = 0;
  int _radioFilterGroup = -1;

  RestaurantListBloc _bloc;

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

    _bloc = RestaurantListBloc();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<RestaurantListBloc>(
          create: (context) {
            return _bloc
              ..add(GetFirstDataRestaurantList(
                  loginState.user.token,
                  widget.location.address,
                  widget.merchantType,
                  widget.type,
                  widget.category));
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
                      BottomNavyBarItem(
                          icon: "assets/2.svg", title: "Flyer Eats"),
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
                DraggableScrollableSheet(
                  initialChildSize: (AppUtil.getScreenHeight(context) -
                          AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  minChildSize: (AppUtil.getScreenHeight(context) -
                          AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  maxChildSize: 1.0,
                  builder: (context, controller) {
                    if (!controller.hasListeners) {
                      controller.addListener(() {
                        double maxScroll = controller.position.maxScrollExtent;
                        double currentScroll = controller.position.pixels;

                        if (currentScroll == maxScroll)
                          _bloc.add(LoadMore(
                              loginState.user.token,
                              widget.location.address,
                              widget.merchantType,
                              widget.type,
                              widget.category));

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
                    }

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
                              onTap: _onTapFilter,
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
                          BlocBuilder<RestaurantListBloc, RestaurantListState>(
                            bloc: _bloc,
                            builder: (context, state) {
                              return RestaurantListWidget(
                                restaurants: state.restaurants,
                                location: widget.location,
                                fade: 0.4,
                                scale: 0.95,
                                type: _isListMode
                                    ? RestaurantViewType.detailList
                                    : RestaurantViewType.detailGrid,
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
    );
  }

  _onTapFilter() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        builder: (context) {
          return BlocBuilder<RestaurantListBloc, RestaurantListState>(
            bloc: _bloc,
            builder: (context, currentState) {
              return StatefulBuilder(
                builder: (context, state) {
                  return BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, loginState) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    left: horizontalPaddingDraggable,
                                    right: horizontalPaddingDraggable,
                                    top: 25,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "FILTERS (${currentState.selectedFilter.length})",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _bloc.add(ClearFilter(
                                              loginState.user.token,
                                              widget.location.address,
                                              widget.merchantType,
                                              widget.type,
                                              widget.category));
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Clear Filter",
                                            style: TextStyle(
                                                color: primary3, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              child: Icon(Icons.clear))),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 0),
                                  child: Divider(
                                    color: Colors.black12,
                                    endIndent: 0,
                                    indent: 0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100]),
                                            child: ListView(
                                              children: <Widget>[
                                                FilterItem(
                                                  text: "SORT",
                                                  index: 0,
                                                  selectedIndex:
                                                      _selectedFilter,
                                                  onTap: () {
                                                    state(() {
                                                      _selectedFilter = 0;
                                                    });
                                                  },
                                                ),
                                                currentState.filters.isNotEmpty
                                                    ? FilterItem(
                                                        text: "CUISINES",
                                                        index: 1,
                                                        selectedIndex:
                                                            _selectedFilter,
                                                        onTap: () {
                                                          state(() {
                                                            _selectedFilter = 1;
                                                          });
                                                        },
                                                      )
                                                    : Container(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                /*FilterItem(
                                                  text: "OTHERS",
                                                  index: 2,
                                                  selectedIndex:
                                                      _selectedFilter,
                                                  onTap: () {
                                                    state(() {
                                                      _selectedFilter = 2;
                                                    });
                                                  },
                                                )*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left:
                                                    horizontalPaddingDraggable,
                                                right:
                                                    horizontalPaddingDraggable,
                                                bottom:
                                                    horizontalPaddingDraggable),
                                            child: IndexedStack(
                                              index: _selectedFilter,
                                              children: <Widget>[
                                                ListView.builder(
                                                  itemBuilder: (context, i) {
                                                    return RadioListTile(
                                                        controlAffinity:
                                                            ListTileControlAffinity
                                                                .leading,
                                                        isThreeLine: false,
                                                        dense: false,
                                                        value: i,
                                                        title: Text(currentState
                                                            .sortBy[i].title),
                                                        groupValue:
                                                            _radioFilterGroup,
                                                        onChanged: (value) {
                                                          state(() {
                                                            _radioFilterGroup =
                                                                i;
                                                          });
                                                          _bloc.add(
                                                              SelectSortBy(
                                                                  currentState
                                                                      .sortBy[i]
                                                                      .key));
                                                        });
                                                  },
                                                  itemCount: currentState
                                                      .sortBy.length,
                                                ),
                                                ListView.builder(
                                                  itemBuilder: (context, i) {
                                                    bool value = false;
                                                    for (int j = 0;
                                                        j <
                                                            currentState
                                                                .selectedFilter
                                                                .length;
                                                        j++) {
                                                      if (currentState
                                                              .filters[i].id ==
                                                          currentState
                                                                  .selectedFilter[
                                                              j]) {
                                                        value = true;
                                                        break;
                                                      }
                                                    }

                                                    return CheckboxListTile(
                                                      value: value,
                                                      dense: false,
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      onChanged: (value) {
                                                        if (value) {
                                                          _bloc.add(AddFilter(
                                                              currentState
                                                                  .filters[i]
                                                                  .id));
                                                        } else {
                                                          _bloc.add(
                                                              RemoveFilter(
                                                                  currentState
                                                                      .filters[
                                                                          i]
                                                                      .id));
                                                        }
                                                      },
                                                      isThreeLine: false,
                                                      title: Text(currentState
                                                          .filters[i].title),
                                                    );
                                                  },
                                                  itemCount: currentState
                                                      .filters.length,
                                                ),
                                                Text("3"),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                _bloc.add(ApplyFilter(
                                    loginState.user.token,
                                    widget.location.address,
                                    widget.merchantType,
                                    widget.type,
                                    widget.category));
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: primary1),
                                child: Text("APPLY FILTER"),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        });
  }
}

class ListRestaurantFilterWidget extends SliverPersistentHeaderDelegate {
  final Function onListButtonTap;
  final Function onGridButtonTap;
  final bool isListSelected;
  final double size;
  final String title;
  final Function onTap;

  ListRestaurantFilterWidget({
    this.onTap,
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
                onTap: onTap,
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

class FilterItem extends StatelessWidget {
  final String text;
  final int index;
  final int selectedIndex;
  final Function onTap;

  const FilterItem(
      {Key key, this.text, this.index, this.selectedIndex, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: index == selectedIndex ? primary1 : Colors.transparent,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

enum RestaurantListType { top, dbl, orderAgain }

enum MerchantType { restaurant, grocery, vegFruits, meat }
