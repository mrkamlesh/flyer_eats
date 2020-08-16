import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/bloc/location/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/cancelledorder/cancelled_order_bloc.dart';
import 'package:clients/bloc/cancelledorder/cancelled_order_event.dart';
import 'package:clients/bloc/cancelledorder/cancelled_order_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/location.dart';
import 'package:clients/page/restaurants_list_page.dart';
import 'package:clients/widget/ads_list.dart';
import 'package:clients/widget/restaurant_list.dart';

class CancelledOrderPage extends StatefulWidget {
  final String orderId;
  final String token;
  final String address;
  final String merchantId;
  final String cancelReason;

  const CancelledOrderPage(
      {Key key,
      this.orderId,
      this.token,
      this.address,
      this.merchantId,
      this.cancelReason})
      : super(key: key);

  @override
  _CancelledOrderPageState createState() => _CancelledOrderPageState();
}

class _CancelledOrderPageState extends State<CancelledOrderPage> {
  CancelledOrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CancelledOrderBloc();
    _bloc.add(
        GetSimilarRestaurant(widget.token, widget.address, widget.merchantId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CancelledOrderBloc>(
      create: (context) {
        return _bloc;
      },
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
            width: AppUtil.getScreenWidth(context),
            height: AppUtil.getScreenHeight(context),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4747),
                  ),
                  height: 0.45 * AppUtil.getScreenHeight(context) + 50,
                  padding: EdgeInsets.only(top: kToolbarHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/ordersuccess icon.png",
                        height: 0.2 * AppUtil.getScreenHeight(context),
                        width: AppUtil.getScreenHeight(context),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          "YOUR ORDER CANCELLED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Text(
                          widget.cancelReason,
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 1.0,
                    builder: (context, controller) {
                      return SingleChildScrollView(
                        controller: controller,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32),
                              topLeft: Radius.circular(32),
                            ),
                          ),
                          height: AppUtil.getScreenHeight(context),
                          child: Column(
                            children: <Widget>[
                              BlocBuilder<CancelledOrderBloc,
                                  CancelledOrderState>(
                                condition: (context, state) {
                                  if (state is LoadingSimilarRestaurant ||
                                      state is SuccessSimilarRestaurant ||
                                      state is ErrorSimilarRestaurant) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                builder: (context, state) {
                                  if (state is LoadingSimilarRestaurant) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: distanceBetweenSection,
                                          top: distanceBetweenSection - 10),
                                      child: Center(
                                        child: SpinKitCircle(
                                          color: Colors.black38,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  } else if (state is ErrorSimilarRestaurant) {
                                    return SizedBox(
                                      height: 20,
                                    );
                                  } else if (state
                                      is SuccessSimilarRestaurant) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  horizontalPaddingDraggable),
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  distanceSectionContent - 10,
                                              top: distanceBetweenSection - 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Similar Restaurant",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RestaurantListPage(
                                                      title:
                                                          "Similar Restaurant",
                                                      merchantType: MerchantType
                                                          .restaurant,
                                                      location: Location(
                                                          address:
                                                              widget.address),
                                                      isExternalImage: false,
                                                      image:
                                                          "assets/allrestaurant.png",
                                                      category:
                                                          state.categoryId,
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
                                              bottom:
                                                  distanceBetweenSection - 20),
                                          height: 150,
                                          child: RestaurantListWidget(
                                            type: RestaurantViewType
                                                .orderAgainRestaurant,
                                            restaurants: state.restaurants,
                                            isExpand: true,
                                            location: Location(
                                                address: widget.address),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, homeState) {
                                  return homeState
                                              .homePageData.referralDiscount !=
                                          ""
                                      ? InkWell(
                                          onTap: homeState.homePageData != null
                                              ? () {
                                                  AppUtil.share(
                                                      context,
                                                      homeState.homePageData
                                                          .referralCode,
                                                      AppUtil.getCurrencyString(
                                                              homeState
                                                                  .homePageData
                                                                  .currencyCode) +
                                                          " " +
                                                          homeState.homePageData
                                                              .referralDiscount);
                                                }
                                              : () {},
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20, bottom: 20),
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
                                      : SizedBox();
                                },
                              ),
                              BlocBuilder<CancelledOrderBloc,
                                  CancelledOrderState>(
                                condition: (context, state) {
                                  if (state is LoadingAds ||
                                      state is SuccessAds ||
                                      state is ErrorAds) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                builder: (context, state) {
                                  if (state is LoadingAds) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: distanceBetweenSection - 20),
                                      child: Center(
                                        child: SpinKitCircle(
                                          color: Colors.black38,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  } else if (state is ErrorAds) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: distanceBetweenSection - 20,
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable),
                                      child: Center(
                                        child: Text(
                                          state.message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    );
                                  } else if (state is SuccessAds) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: distanceBetweenSection - 10),
                                      height: 140,
                                      child: AdsListWidget(
                                        adsList: state.ads,
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                GestureDetector(
                  onTap: () {
                    _onBackPressed();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 40, left: 15),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5)),
                    child: Icon(
                      Icons.clear,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushReplacementNamed(context, "/home");
    return true;
  }
}
