import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';

class CancelledOrderPage extends StatefulWidget {
  final String orderId;
  final String token;
  final String address;

  const CancelledOrderPage({Key key, this.orderId, this.token, this.address}) : super(key: key);

  @override
  _CancelledOrderPageState createState() => _CancelledOrderPageState();
}

class _CancelledOrderPageState extends State<CancelledOrderPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: Text(
                        "Reason Here",
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
                                bottom: 20),
                            child: Center(
                              child: Text(
                                "You will get order notification in some time",
                                style: TextStyle(color: Colors.black26),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
                              child: Text(
                                "Browse Restaurants",
                                style: TextStyle(color: primary3, decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
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
                          /*BlocBuilder<PlacedOrderSuccessBloc, PlacedOrderSuccessState>(builder: (context, state) {
                            if (state is LoadingAds) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(),
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
                                  height: 0.18 * AppUtil.getScreenHeight(context),
                                  child: PromoListWidget(
                                    promoList: state.ads,
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            }
                            return SizedBox();
                          }),*/
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                  child: Icon(
                    Icons.clear,
                  ),
                ),
              )
            ],
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
