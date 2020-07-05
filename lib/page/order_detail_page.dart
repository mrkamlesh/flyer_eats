import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/detailorder/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DetailOrderPage extends StatefulWidget {
  final String orderId;

  const DetailOrderPage({Key key, this.orderId}) : super(key: key);

  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  DetailOrderBloc _bloc;
  TextEditingController _reviewTextController;

  @override
  void initState() {
    super.initState();
    _bloc = DetailOrderBloc();
    _reviewTextController = TextEditingController();
    _reviewTextController.addListener(() {
      _bloc.add(UpdateReviewComment(_reviewTextController.text));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<DetailOrderBloc>(
          create: (context) {
            return _bloc..add(GetDetailOrder(widget.orderId, loginState.user.token));
          },
          child: Scaffold(
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
                          child: Image.asset(
                            "assets/allrestaurant.png",
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
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: CustomAppBar(
                        leading: "assets/back.svg",
                        title: "Order History Detailed Summary",
                        onTapLeading: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  maxChildSize: 1.0,
                  builder: (context, controller) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                      padding: EdgeInsets.only(left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                      child: BlocBuilder<DetailOrderBloc, DetailOrderState>(
                        builder: (context, state) {
                          if (state is LoadingDetailOrderState) {
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
                                    Text("Loading Order History..."),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is ErrorDetailOrderState) {
                            return Container(
                              height: AppUtil.getDraggableHeight(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                              alignment: Alignment.center,
                              child: Container(
                                child: Center(
                                  child: Text(state.message),
                                ),
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                state.detailOrder.statusHistory.last.isDelivered()
                                    ? state.isReviewAdded
                                        ? Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 30, bottom: 20),
                                                  padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    "Review has been added!",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _showReviewSheet();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 30, top: 30),
                                              child: Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    "assets/add review icon.svg",
                                                    height: 30,
                                                    width: 30,
                                                    color: primary3,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "Add Reviews To Earn Points",
                                                      style: TextStyle(fontSize: 16, color: primary3),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: primary3,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                    : SizedBox(),
                                Container(
                                  margin: state.detailOrder.statusHistory.last.isDelivered()
                                      ? EdgeInsets.only(bottom: 10)
                                      : EdgeInsets.only(bottom: 10, top: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: CachedNetworkImage(
                                            imageUrl: state.detailOrder.restaurant.image,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            placeholder: (context, url) {
                                              return Shimmer.fromColors(
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    color: Colors.black,
                                                  ),
                                                  baseColor: Colors.grey[300],
                                                  highlightColor: Colors.grey[100]);
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              state.detailOrder.restaurant.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              state.detailOrder.restaurant.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12, color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Divider(
                                    height: 0.5,
                                    color: Colors.black12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "ORDER NO - " + state.detailOrder.id,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.detailOrder.createdDate,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Divider(
                                    height: 0.5,
                                    color: Colors.black12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "Order Detail",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ),
                                Column(
                                  children: _foodCartWidgets(state.detailOrder.foodCart),
                                ),
                                Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            _feeRowWidget("Order", state.detailOrder.total, true),
                                            _feeRowWidget("Tax", state.detailOrder.tax, true),
                                            _feeRowWidget("Packaging", state.detailOrder.packagingFee, true),
                                            _feeRowWidget("Delivery Fee", state.detailOrder.deliveryCharges, true),
                                            _feeRowWidget("Discount Food", state.detailOrder.discountFood, false),
                                            _feeRowWidget("Discount Order", state.detailOrder.discountOrder, false),
                                            _feeRowWidget("Coupon/Voucher", state.detailOrder.voucherAmount, false),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10, top: 5),
                                          child: Divider(
                                            height: 0.5,
                                            color: Colors.black12,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 7,
                                                child: Text(
                                                  "Total",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "\u20b9 " +
                                                      AppUtil.doubleRemoveZeroTrailing(state.detailOrder.grandTotal),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Divider(
                                            height: 0.5,
                                            color: Colors.black12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    state.detailOrder.statusHistory.last.isDelivered()
                                        ? Positioned(
                                            bottom: -50,
                                            left: 50,
                                            child: Image.asset(
                                              "assets/delivered signature.png",
                                              width: 150,
                                              height: 150,
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                state.detailOrder.orderInstruction != null && state.detailOrder.orderInstruction != ""
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5, bottom: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "ORDER INSTRUCTION",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(state.detailOrder.orderInstruction),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (context) {
                                          List<Widget> statusWidgets = List();
                                          for (int i = 0; i < state.detailOrder.statusHistory.length; i++) {
                                            statusWidgets.add(
                                              Container(
                                                margin: EdgeInsets.symmetric(vertical: 3),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SvgPicture.asset(
                                                          state.detailOrder.statusHistory[i].getIconAssets(),
                                                          width: 60,
                                                          height: 60,
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text(
                                                                state.detailOrder.statusHistory[i].status,
                                                                style: TextStyle(
                                                                    fontSize: 20, fontWeight: FontWeight.bold),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons.calendar_today,
                                                                        size: 16,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Text(state
                                                                          .detailOrder.statusHistory[i].dateCreated)
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons.access_time,
                                                                        color: primary3,
                                                                        size: 16,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Text(
                                                                        state.detailOrder.statusHistory[i].time,
                                                                        style: TextStyle(color: primary3),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    i != state.detailOrder.statusHistory.length - 1
                                                        ? Container(
                                                            margin: EdgeInsets.only(left: 25),
                                                            child: SvgPicture.asset(
                                                              "assets/separator icon.svg",
                                                              height: 60,
                                                              width: 15,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          return Wrap(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  SingleChildScrollView(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: kBottomNavigationBarHeight,
                                                          top: 20),
                                                      decoration:
                                                          BoxDecoration(borderRadius: BorderRadius.circular(32)),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets.only(bottom: 52),
                                                          ),
                                                          Column(
                                                            children: statusWidgets,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: Container(
                                                        width: AppUtil.getScreenWidth(context),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(32),
                                                                topRight: Radius.circular(32)),
                                                            color: Colors.white),
                                                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                                flex: 2,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Icon(Icons.clear),
                                                                )),
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                "Track Order Timeline",
                                                                style: TextStyle(
                                                                    fontSize: 18, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: state.detailOrder.orderInstruction != null &&
                                            state.detailOrder.orderInstruction != ""
                                        ? EdgeInsets.only(top: 30, bottom: 30)
                                        : EdgeInsets.only(top: 50, bottom: 30),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFB531),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.detailOrder.statusHistory.last.isDelivered()
                                          ? "TRACK ORDER TIMELINE"
                                          : "TRACK ORDER",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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

  List<Widget> _foodCartWidgets(FoodCart cart) {
    List<Widget> widgets = List();

    cart.cart.forEach((key, value) {
      widgets.add(FoodCartItemWidget(
        item: value,
      ));
    });

    return widgets;
  }

  Widget _feeRowWidget(String title, double amount, bool isPositive) {
    String amountString = isPositive
        ? "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(amount)
        : "(\u20b9 " + AppUtil.doubleRemoveZeroTrailing(amount) + ")";

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              amountString,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void _showReviewSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return BlocConsumer<DetailOrderBloc, DetailOrderState>(
            listener: (context, state) {
              if (state is ErrorAddReview) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Error",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          state.message,
                          style: TextStyle(color: Colors.black54),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("YES")),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("NO")),
                        ],
                      );
                    },
                    barrierDismissible: true);
              } else if (state is SuccessAddReview) {
                Navigator.pop(context);
              }
            },
            bloc: _bloc,
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 52),
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Rate Merchant",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SmoothStarRating(
                                      rating: state.rating,
                                      borderColor: primary3,
                                      color: primary3,
                                      size: 30,
                                      allowHalfRating: true,
                                      onRated: (rating) {
                                        _bloc.add(UpdateReviewRating(rating));
                                      },
                                      starCount: 5,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
                                child: TextField(
                                  controller: _reviewTextController,
                                  maxLines: 5,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      hintText: "Enter your review",
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, loginState) {
                                  return GestureDetector(
                                    onTap: state.isReviewValid() && !(state is LoadingAddReview)
                                        ? () {
                                            _bloc.add(AddReview(loginState.user.token));
                                          }
                                        : () {},
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFB531),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: state is LoadingAddReview
                                              ? SpinKitCircle(
                                                  color: Colors.white,
                                                  size: 30,
                                                )
                                              : Text(
                                                  "SUBMIT",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                        ),
                                        AnimatedOpacity(
                                          opacity: state.isReviewValid() && !(state is LoadingAddReview) ? 0.0 : 0.5,
                                          child: Container(
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(milliseconds: 300),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: AppUtil.getScreenWidth(context),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                            color: Colors.white),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.clear),
                                )),
                            Expanded(
                              flex: 8,
                              child: Text(
                                "Add Review",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              );
            },
          );
        });
  }
}

class FoodCartItemWidget extends StatelessWidget {
  final FoodCartItem item;

  const FoodCartItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.food.category.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Text(
                item.food.title +
                    " ( " +
                    item.quantity.toString() +
                    " X \u20b9 " +
                    AppUtil.doubleRemoveZeroTrailing(item.food.price) +
                    " )",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  "\u20b9 " + AppUtil.doubleRemoveZeroTrailing((item.quantity * item.food.price)),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Divider(
            height: 0.5,
            color: Colors.black12,
          ),
        ),
      ],
    );
  }
}
