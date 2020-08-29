import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/page/home.dart';
import 'package:clients/page/pickup_order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/currentorder/bloc.dart';
import 'package:clients/bloc/placedordersuccess/placed_order_success_bloc.dart';
import 'package:clients/bloc/placedordersuccess/placed_order_success_event.dart';
import 'package:clients/bloc/placedordersuccess/placed_order_success_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/order_detail_page.dart';
import 'package:clients/widget/ads_list.dart';

class PlacedOrderSuccessPage extends StatefulWidget {
  final String placeOrderId;
  final String token;
  final String address;
  final bool isPickupOrder;

  const PlacedOrderSuccessPage(
      {Key key,
      this.placeOrderId,
      this.token,
      this.address,
      this.isPickupOrder = false})
      : super(key: key);

  @override
  _PlacedOrderSuccessPageState createState() => _PlacedOrderSuccessPageState();
}

class _PlacedOrderSuccessPageState extends State<PlacedOrderSuccessPage> {
  PlacedOrderSuccessBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PlacedOrderSuccessBloc()..add(GetAds(widget.token, widget.address));
    BlocProvider.of<CurrentOrderBloc>(context)
        .add(GetActiveOrder(widget.token));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlacedOrderSuccessBloc>(
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
                    color: Color(0xFFFFB531),
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
                          "ORDER PLACED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Text(
                          "Waiting for the restaurant to accept",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IgnorePointer(
                      child: SizedBox(
                        height: 0.45 * AppUtil.getScreenHeight(context),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            topLeft: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: 30,
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable,
                                  bottom: 10),
                              child: Center(
                                child: Text(
                                  "You will get order notification in some time",
                                  style: TextStyle(color: Colors.black26),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.isPickupOrder) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PickupOrderDetailPage(
                                      orderId: widget.placeOrderId,
                                    );
                                  }));
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailOrderPage(
                                      orderId: widget.placeOrderId,
                                    );
                                  }));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "View Order Summary",
                                  style: TextStyle(
                                      color: primary3,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            BlocBuilder<PlacedOrderSuccessBloc,
                                PlacedOrderSuccessState>(
                              builder: (context, state) {
                                if (state is SuccessAds) {
                                  return BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, homeState) {
                                      return homeState
                                              .homePageData.isReferralAvailable
                                          ? InkWell(
                                              onTap:
                                                  homeState.homePageData != null
                                                      ? () {
                                                          AppUtil.share(
                                                              context,
                                                              homeState
                                                                  .homePageData
                                                                  .referralCode,
                                                              AppUtil.getCurrencyString(
                                                                      homeState
                                                                          .homePageData
                                                                          .currencyCode) +
                                                                  " " +
                                                                  homeState
                                                                      .homePageData
                                                                      .referralDiscount);
                                                        }
                                                      : () {},
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 20),
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
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      padding:
                                                          EdgeInsets.all(10),
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
                                                                    AppUtil.getScreenHeight(
                                                                        context) -
                                                                60,
                                                            width: 0.16 *
                                                                    AppUtil.getScreenHeight(
                                                                        context) -
                                                                60,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Refer Now",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
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
                                                                    fontSize:
                                                                        12),
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
                                                                    fontSize:
                                                                        18,
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
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          15),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Use Referal Code: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                                      fontSize:
                                                                          12,
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
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                            BlocBuilder<PlacedOrderSuccessBloc,
                                    PlacedOrderSuccessState>(
                                builder: (context, state) {
                              if (state is LoadingAds) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.black38,
                                      size: 30,
                                    ),
                                  ),
                                );
                              } else if (state is ErrorAds) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(state.message),
                                  ),
                                );
                              } else if (state is SuccessAds) {
                                if (state.ads.isNotEmpty) {
                                  return Container(
                                    height:
                                        0.18 * AppUtil.getScreenHeight(context),
                                    child: AdsListWidget(
                                      adsList: state.ads,
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }
                              return SizedBox();
                            }),
                            /*Container(
                                height: 0.18 * AppUtil.getScreenHeight(context),
                                child: PromoListWidget(
                                  promoList: ExampleModel.getPromos(),
                                ),
                              ),*/
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Home();
    }), (Route<dynamic> route) => false);
    return true;
  }
}
