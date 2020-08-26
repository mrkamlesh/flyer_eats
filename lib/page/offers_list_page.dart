import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/offerlist/bank/bank_offer_bloc.dart';
import 'package:clients/bloc/offerlist/bank/bank_offer_event.dart';
import 'package:clients/bloc/offerlist/bank/bank_offer_state.dart';
import 'package:clients/bloc/offerlist/feoffer/bloc.dart';
import 'package:clients/bloc/offerlist/merchant/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/fe_offer.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/restaurant_place_order_page.dart';
import 'package:clients/page/search_restaurant_page.dart';
import 'package:clients/widget/custom_bottom_navigation_bar.dart';
import 'package:clients/widget/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OfferListPage extends StatefulWidget {
  final String address;

  const OfferListPage({Key key, this.address}) : super(key: key);

  @override
  _OfferListPageState createState() => _OfferListPageState();
}

class _OfferListPageState extends State<OfferListPage>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;
  ScrollController _scrollController;
  TabController _tabController;
  bool _isScrollingDown = false;

  FeOfferBloc _feOfferBloc;
  MerchantOfferBloc _merchantOfferBloc;
  BankOfferBloc _bankOfferBloc;

  @override
  void initState() {
    super.initState();

    _feOfferBloc = FeOfferBloc();
    _merchantOfferBloc = MerchantOfferBloc();
    _bankOfferBloc = BankOfferBloc();

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
      //double maxScroll = _scrollController.position.maxScrollExtent;
      //double currentScroll = _scrollController.position.pixels;

      //if (currentScroll == maxScroll) _bloc.add(LoadMore(widget.token, widget.address));

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

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _feOfferBloc.close();
    _merchantOfferBloc.close();
    _bankOfferBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<FoodOrderBloc, FoodOrderState>(
          builder: (context, cartState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<FeOfferBloc>(
                  create: (context) {
                    return _feOfferBloc
                      ..add(GetFEOffer(loginState.user.token, widget.address));
                  },
                ),
                BlocProvider<MerchantOfferBloc>(
                  create: (context) {
                    return _merchantOfferBloc;
                  },
                ),
                BlocProvider<BankOfferBloc>(
                  create: (context) {
                    return _bankOfferBloc;
                  },
                ),
              ],
              child: Scaffold(
                backgroundColor: Colors.white,
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
                          BottomNavyBarItem(
                              icon: "assets/4.svg", title: "Offers"),
                          BottomNavyBarItem(
                              icon: "assets/1.svg", title: "Search"),
                          BottomNavyBarItem(
                              icon: "assets/3.svg",
                              title: "Order",
                              badge:
                                  cartState.placeOrder.foodCart.cartItemTotal())
                        ],
                        onItemSelected: (index) async {
                          _currentIndex = index;
                          if (index == 0) {
                            /*await Navigator.pushReplacement(context,
                                PageRouteBuilder(
                                    pageBuilder: (context, anim1, anim2) {
                              return Home();
                            }));*/
                            Navigator.pop(context);
                            _currentIndex = 1;
                          } else if (index == 2) {
                            await Navigator.pushReplacement(context,
                                PageRouteBuilder(
                                    pageBuilder: (context, anim1, anim2) {
                              return SearchRestaurantPage(
                                address: widget.address,
                                token: loginState.user.token,
                              );
                            }));
                            _currentIndex = 1;
                          } else if (index == 3) {
                            await Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) {
                              return RestaurantPlaceOrderPage(
                                location: Location(address: widget.address),
                                user: loginState.user,
                              );
                            }));
                            _currentIndex = 1;
                          }
                        },
                        selectedIndex: _currentIndex,
                        selectedColor: Colors.orange[700],
                        unselectedColor: Colors.black26,
                      ),
                    ),
                  ),
                ),
                body: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 20),
                      padding: EdgeInsets.only(
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable),
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Container(
                          child: TabBar(
                            controller: _tabController,
                            onTap: (i) {
                              if (i == 0) {
                                _feOfferBloc.add(GetFEOffer(
                                    loginState.user.token, widget.address));
                              } else if (i == 1) {
                                _merchantOfferBloc.add(GetMerchantOffer(
                                    loginState.user.token, widget.address));
                              } else if (i == 2) {
                                _bankOfferBloc.add(GetBankOffer(
                                    loginState.user.token, widget.address));
                              }
                            },
                            //isScrollable: true,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black26,
                            indicatorColor: Colors.yellow[600],
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: GoogleFonts.poppins(
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            indicatorPadding: EdgeInsets.only(
                                left: 0, right: 15, bottom: 2, top: 0),
                            labelPadding:
                                EdgeInsets.only(left: 0, right: 15, bottom: 0),
                            tabs: [
                              Tab(text: "FE Offers"),
                              Tab(text: "Merchant"),
                              Tab(text: "Bank"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          BlocBuilder<FeOfferBloc, FeOfferState>(
                            builder: (context, state) {
                              if (state is LoadingFEOfferState) {
                                return LoadingWidget();
                              } else if (state is ErrorFEOfferState) {
                                return ErrorWidget(
                                  message: state.message,
                                  onTapRetry: () {
                                    _feOfferBloc.add(GetFEOffer(
                                        loginState.user.token, widget.address));
                                  },
                                );
                              }
                              if (state.feOffers.isEmpty) {
                                return ErrorWidget(
                                  message:
                                      "No Offers is Available Now.\n Stay Tune with Us",
                                );
                              } else {
                                return FEOfferListWidget(
                                    offers: state.feOffers);
                              }
                            },
                          ),
                          BlocBuilder<MerchantOfferBloc, MerchantOfferState>(
                            builder: (context, state) {
                              if (state is LoadingMerchantOfferState) {
                                return LoadingWidget();
                              } else if (state is ErrorMerchantOfferState) {
                                return ErrorWidget(
                                  message: state.message,
                                  onTapRetry: () {
                                    _merchantOfferBloc.add(GetMerchantOffer(
                                        loginState.user.token, widget.address));
                                  },
                                );
                              }
                              if (state.merchants.isEmpty) {
                                return ErrorWidget(
                                  message:
                                      "No Offers is Available Now.\n Stay Tune with Us",
                                );
                              } else {
                                return CustomScrollView(
                                  slivers: <Widget>[
                                    RestaurantListWidget(
                                      type: RestaurantViewType.offerPage,
                                      location:
                                          Location(address: widget.address),
                                      fade: 0.4,
                                      scale: 0.95,
                                      restaurants: state.merchants,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          BlocBuilder<BankOfferBloc, BankOfferState>(
                              builder: (context, state) {
                            if (state is LoadingBankOfferState) {
                              return LoadingWidget();
                            } else if (state is ErrorBankOfferState) {
                              return ErrorWidget(
                                message: state.message,
                                onTapRetry: () {
                                  _bankOfferBloc.add(GetBankOffer(
                                      loginState.user.token, widget.address));
                                },
                              );
                            }
                            if (state.banks.isEmpty) {
                              return ErrorWidget(
                                message:
                                    "No Offers is Available Now.\n Stay Tune with Us",
                              );
                            } else {
                              return CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, i) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom: 15),
                                      child: Text(state.banks[i].text),
                                    );
                                  }, childCount: state.banks.length)),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FEOfferListWidget extends StatelessWidget {
  final List<FEOffer> offers;

  const FEOfferListWidget({Key key, this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, i) {
            return FEOfferWidget(
              feOffer: offers[i],
            );
          },
          childCount: offers.length,
        ))
      ],
    );
  }
}

class FEOfferWidget extends StatelessWidget {
  final FEOffer feOffer;

  const FEOfferWidget({Key key, this.feOffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(
          left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: feOffer.image,
          height: 120,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          placeholder: (context, url) {
            return Shimmer.fromColors(
                child: Container(
                  height: 120,
                  color: Colors.black,
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          },
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text("Loading"),
          ],
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  final Function onTapRetry;

  const ErrorWidget({Key key, this.message, this.onTapRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(horizontalPaddingDraggable),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          onTapRetry == null
              ? Container(
                  margin: EdgeInsets.only(bottom: horizontalPaddingDraggable),
                  child: SvgPicture.asset(
                    "assets/no offers available icon.svg",
                    height: AppUtil.getScreenHeight(context) / 5,
                    width: AppUtil.getScreenHeight(context) / 5,
                  ),
                )
              : SizedBox(),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          onTapRetry != null
              ? InkWell(
                  onTap: onTapRetry,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: primary3,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "RETRY",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
