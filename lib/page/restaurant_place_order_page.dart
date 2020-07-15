import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/address/address_repository.dart';
import 'package:clients/bloc/address/bloc.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/voucher.dart';
import 'package:clients/page/address_page.dart';
import 'package:clients/page/apply_coupon_page.dart';
import 'package:clients/page/placed_order_success.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/place_order_bottom_navbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class RestaurantPlaceOrderPage extends StatefulWidget {
  final Restaurant restaurant;
  final FoodCart foodCart;
  final Location location;

  const RestaurantPlaceOrderPage({Key key, this.restaurant, this.foodCart, this.location}) : super(key: key);

  @override
  _RestaurantPlaceOrderPageState createState() => _RestaurantPlaceOrderPageState();
}

class _RestaurantPlaceOrderPageState extends State<RestaurantPlaceOrderPage> with SingleTickerProviderStateMixin {
  AddressBloc _addressBloc;
  FoodOrderBloc _foodOrderBloc;

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _addressBloc = AddressBloc(AddressRepository());
    _foodOrderBloc = FoodOrderBloc();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    _addressBloc.close();
    _foodOrderBloc.close();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<FoodOrderBloc>(
              create: (context) {
                return _foodOrderBloc..add(InitPlaceOrder(widget.restaurant, widget.foodCart, loginState.user));
              },
            ),
            BlocProvider<AddressBloc>(
              create: (context) {
                return _addressBloc;
              },
            )
          ],
          child: BlocBuilder<FoodOrderBloc, FoodOrderState>(
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  _onBackPressed(state.placeOrder);
                  return true;
                },
                child: Scaffold(
                  endDrawer: EndDrawer(),
                  body: BlocBuilder<FoodOrderBloc, FoodOrderState>(
                    builder: (context, state) {
                      if (state is InitialFoodOrderState) {
                        return Container();
                      } else if (state is NoItemsInCart) {
                        return Stack(
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
                                      child: CachedNetworkImage(
                                        imageUrl: widget.restaurant.image,
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
                            Container(
                              height: AppUtil.getToolbarHeight(context),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: CustomAppBar(
                                      leading: "assets/back.svg",
                                      title: "",
                                      onTapLeading: () {
                                        _onBackPressed(state.placeOrder);
                                      },
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
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
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                    padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/no available items cart.svg",
                                          height: AppUtil.getScreenWidth(context) - 50,
                                          width: AppUtil.getScreenWidth(context) - 50,
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Text("Start browsing and add item"),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(context, "/home");
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFB531),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "BROWSE",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            )
                          ],
                        );
                      }
                      return Stack(
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
                                    child: CachedNetworkImage(
                                      imageUrl: widget.restaurant.image,
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
                                child: Builder(
                                  builder: (context) {
                                    return CustomAppBar(
                                      leading: "assets/back.svg",
                                      title: widget.restaurant.name +
                                          " (" +
                                          state.placeOrder.foodCart.cart.length.toString() +
                                          ")",
                                      onTapLeading: () {
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: Colors.transparent,
                                    );
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
                                    borderRadius:
                                        BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                child: CustomScrollView(
                                  controller: controller,
                                  slivers: <Widget>[
                                    SliverPersistentHeader(
                                      delegate: DeliveryOptions(),
                                      pinned: true,
                                    ),
                                    FoodListPlaceOrder(),
                                    BlocBuilder<FoodOrderBloc, FoodOrderState>(
                                      bloc: _foodOrderBloc,
                                      builder: (context, state) {
                                        if (state is LoadingGetPayments) {
                                          return SliverToBoxAdapter(
                                              child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                left: horizontalPaddingDraggable,
                                                right: horizontalPaddingDraggable,
                                                bottom: kBottomNavigationBarHeight + 160),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child: SpinKitCircle(
                                                    color: Colors.black38,
                                                    size: 30,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text("Calculating..."),
                                              ],
                                            ),
                                          ));
                                        }
                                        if (!state.placeOrder.isValid) {
                                          return SliverToBoxAdapter(
                                              child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                left: horizontalPaddingDraggable,
                                                right: horizontalPaddingDraggable,
                                                bottom: kBottomNavigationBarHeight + 160),
                                            child: Container(
                                              child: Text(state.placeOrder.message),
                                            ),
                                          ));
                                        } else {
                                          return SliverToBoxAdapter(
                                            child: Column(
                                              children: <Widget>[
                                                state.placeOrder.voucher.id == null
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          Voucher result = await Navigator.push(context,
                                                              MaterialPageRoute(builder: (context) {
                                                            return ApplyCouponPage(
                                                              restaurant: widget.restaurant,
                                                              totalOrder: state.placeOrder.getTotal(),
                                                            );
                                                          }));

                                                          _foodOrderBloc.add(ApplyVoucher(result));
                                                        },
                                                        child: Container(
                                                          height: 55,
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 17, horizontal: horizontalPaddingDraggable),
                                                          margin: EdgeInsets.symmetric(
                                                              horizontal: horizontalPaddingDraggable),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: shadow,
                                                                blurRadius: 7,
                                                                spreadRadius: -3,
                                                              )
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              SvgPicture.asset(
                                                                "assets/discount.svg",
                                                                height: 24,
                                                                width: 24,
                                                                color: Colors.black,
                                                              ),
                                                              SizedBox(
                                                                width: 17,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "APPLY COUPON",
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 55,
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: 17, horizontal: horizontalPaddingDraggable),
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: horizontalPaddingDraggable),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: shadow,
                                                              blurRadius: 7,
                                                              spreadRadius: -3,
                                                            )
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            SvgPicture.asset(
                                                              "assets/check.svg",
                                                              height: 24,
                                                              width: 24,
                                                            ),
                                                            SizedBox(
                                                              width: 17,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                state.placeOrder.voucher.name,
                                                                style: TextStyle(fontSize: 16),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                Container(
                                                  height: 55,
                                                  margin: EdgeInsets.only(
                                                      top: 20,
                                                      left: horizontalPaddingDraggable,
                                                      right: horizontalPaddingDraggable),
                                                  padding: EdgeInsets.only(top: 17, bottom: 17, left: 17, right: 17),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 25,
                                                        child: Checkbox(
                                                            activeColor: Colors.green,
                                                            value: state.placeOrder.isUseWallet,
                                                            onChanged: (value) {
                                                              _foodOrderBloc.add(ChangeWalletUsage(value));
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        width: 17,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "WALLET AMOUNT",
                                                          style: TextStyle(fontSize: 16),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            "assets/rupee.svg",
                                                            height: 12,
                                                            width: 12,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            AppUtil.doubleRemoveZeroTrailing(
                                                                state.placeOrder.walletAmount -
                                                                    state.placeOrder.getWalletUsed()),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 20,
                                                      left: horizontalPaddingDraggable,
                                                      right: horizontalPaddingDraggable,
                                                      bottom: 20),
                                                  padding: EdgeInsets.only(
                                                      left: horizontalPaddingDraggable,
                                                      right: horizontalPaddingDraggable,
                                                      top: horizontalPaddingDraggable,
                                                      bottom: 7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      OrderRowItem(
                                                        title: "ORDER",
                                                        color: Colors.black,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.subTotal()),
                                                      ),
                                                      OrderRowItem(
                                                        title: state.placeOrder.taxPrettyString,
                                                        color: Colors.black,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.taxCharges),
                                                      ),
                                                      OrderRowItem(
                                                        title: "PACKAGING",
                                                        color: Colors.black,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.packagingCharges),
                                                      ),
                                                      OrderRowItem(
                                                        title: "DELIVERY FEE",
                                                        color: Colors.black,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.deliveryCharges),
                                                      ),
                                                      /*OrderRowItem(
                                                        title: "DISCOUNT FOOD",
                                                        color: Colors.green,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.getDiscountFoodTotal()),
                                                      ),*/
                                                      OrderRowItem(
                                                        title: state.placeOrder.discountOrderPrettyString,
                                                        color: Colors.green,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.discountOrder),
                                                      ),
                                                      OrderRowItem(
                                                        title: "COUPON/VOUCHER",
                                                        color: Colors.green,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.voucher.amount),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: 13),
                                                        child: Divider(
                                                          height: 1,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      OrderRowItem(
                                                          title: "TOTAL",
                                                          color: Colors.black,
                                                          amount: AppUtil.doubleRemoveZeroTrailing(
                                                              state.placeOrder.getTotal())),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: horizontalPaddingDraggable,
                                                      horizontal: horizontalPaddingDraggable),
                                                  margin: EdgeInsets.only(
                                                      left: horizontalPaddingDraggable,
                                                      right: horizontalPaddingDraggable,
                                                      bottom: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "DELIVERY INSTRUCTION",
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Divider(
                                                        color: Colors.black12,
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          _foodOrderBloc.add(ChangeInstruction(value));
                                                        },
                                                        maxLines: 2,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                            hintText: "Enter your instruction here",
                                                            hintStyle: TextStyle(fontSize: 12),
                                                            border: InputBorder.none),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: horizontalPaddingDraggable,
                                                      horizontal: horizontalPaddingDraggable),
                                                  margin: EdgeInsets.only(
                                                      left: horizontalPaddingDraggable,
                                                      right: horizontalPaddingDraggable,
                                                      bottom: kBottomNavigationBarHeight + 170),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "DELIVERY TIME",
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Choose time when order will be delivered",
                                                        style: TextStyle(color: Colors.black45, fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Divider(
                                                        color: Colors.black12,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDeliveryOptions(state.placeOrder);
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <Widget>[
                                                                SvgPicture.asset(
                                                                  "assets/calendar.svg",
                                                                  height: 18,
                                                                  width: 18,
                                                                  color: Colors.black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  state.placeOrder.getDeliveryDatePretty(),
                                                                  style: TextStyle(fontSize: 14),
                                                                )
                                                              ],
                                                            ),
                                                            Expanded(child: Container()),
                                                            Row(
                                                              children: <Widget>[
                                                                SvgPicture.asset(
                                                                  "assets/clock.svg",
                                                                  height: 18,
                                                                  width: 18,
                                                                  color: Colors.black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  state.placeOrder.getDeliveryTime(),
                                                                  style: TextStyle(fontSize: 14),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Icon(
                                                              Icons.arrow_forward_ios,
                                                              size: 18,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: Column(
                              children: <Widget>[
                                state.placeOrder.transactionType == "delivery"
                                    ? FoodListDeliveryInformation(
                                        address: state.placeOrder.address,
                                        token: state.placeOrder.user.token,
                                        foodOrderBloc: _foodOrderBloc,
                                        addressBloc: _addressBloc,
                                        contact: state.placeOrder.contact,
                                        deliveryEstimation: widget.restaurant.deliveryEstimation,
                                      )
                                    : Container(),
                                OrderBottomNavBar(
                                  isValid: state.placeOrder.isValid,
                                  onButtonTap: state.placeOrder.isValid
                                      ? () {
                                          placeOrderButtonTap(state.placeOrder);
                                        }
                                      : () {},
                                  showRupee: (state is LoadingGetPayments) ? false : true,
                                  amount: (state is LoadingGetPayments)
                                      ? "..."
                                      : AppUtil.doubleRemoveZeroTrailing(
                                          state.placeOrder.getTotal() - state.placeOrder.getWalletUsed()),
                                  buttonText: "PLACE ORDER",
                                  description: (state is LoadingGetPayments) ? "Calculating..." : "Total Amount",
                                ),
                              ],
                            ),
                          ),
                          BlocConsumer<FoodOrderBloc, FoodOrderState>(
                            listener: (context, state) {
                              if (state is SuccessPlaceOrder) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return PlacedOrderSuccessPage(
                                    placeOrderId: state.placeOrder.id,
                                    token: loginState.user.token,
                                    address: widget.location.address,
                                  );
                                }));
                              } else if (state is ErrorPlaceOrder) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        title: Text(
                                          "Place Order Error",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(state.message),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            builder: (context, state) {
                              if (state is LoadingPlaceOrder) {
                                return Container(
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  showDeliveryOptions(PlaceOrder placeOrder) {
    DateTime groupValue = placeOrder.selectedDeliveryTime;
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 110,
                        ),
                        Column(
                          children: placeOrder.getDeliveryTimeOptions().map((time) {
                            return Container(
                              padding:
                                  EdgeInsets.only(left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                              child: RadioListTile<DateTime>(
                                dense: true,
                                onChanged: (value) {
                                  newState(() {
                                    groupValue = value;
                                  });
                                  _foodOrderBloc.add(ChangeDeliveryTime(value));
                                  Navigator.pop(context);
                                },
                                groupValue: groupValue,
                                value: time,
                                title: Text(
                                  DateFormat('hh:mm a').format(time),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: AppUtil.getScreenWidth(context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          color: Colors.white),
                      padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  "Select Delivery Time For",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                "assets/calendar.svg",
                                height: 18,
                                width: 18,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                placeOrder.getDeliveryDatePretty(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  showPaymentMethodOptions(PlaceOrder placeOrder) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              List<Widget> listWidget = List();
              for (int i = 0; i < placeOrder.listPaymentMethod.length; i++) {
                listWidget.add(Column(
                  children: <Widget>[
                    RadioListTile(
                      value: placeOrder.listPaymentMethod[i].value,
                      dense: true,
                      groupValue: placeOrder.selectedPaymentMethod,
                      onChanged: (value) {
                        _onPaymentOptionsSelected(placeOrder, value);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      isThreeLine: false,
                      title: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            placeOrder.listPaymentMethod[i].getIcon(),
                            height: 36,
                            width: 36,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            placeOrder.listPaymentMethod[i].label,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ));
              }

              return Container(
                margin: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPaddingDraggable - 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: listWidget,
                ),
              );
            },
          );
        });
  }

  openRazorPayCheckOut(PlaceOrder placeOrder) {
    var options = {
      "key": placeOrder.razorKey, //"rzp_test_shynWbWngI8JsA", // change to placeOrder.razorKey
      "amount": (placeOrder.getTotal() * 100.0).ceil().toString(),
      "name": "Flyer Eats",
      "description": "Payment for Flyer Eats Order",
      "prefill": {
        "contact": placeOrder.contact,
        "email": placeOrder.user.username,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    _foodOrderBloc.add(PlaceOrderEvent());
  }

  void handlerPaymentError(PaymentFailureResponse response) {
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
              response.message,
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        },
        barrierDismissible: true);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {}

  void placeOrderButtonTap(PlaceOrder placeOrder) {
    if ((placeOrder.getTotal() - placeOrder.getWalletUsed()) > 0.0) {
      showPaymentMethodOptions(placeOrder);
    } else {
      _foodOrderBloc.add(ChangePaymentMethod("wallet"));
      _foodOrderBloc.add(PlaceOrderEvent());
    }
  }

  void _onPaymentOptionsSelected(PlaceOrder placeOrder, selectedPaymentMethod) {
    _foodOrderBloc.add(ChangePaymentMethod(selectedPaymentMethod));
    if (selectedPaymentMethod == "cod") {
      _foodOrderBloc.add(PlaceOrderEvent());
    } else if (selectedPaymentMethod == "rzr") {
      openRazorPayCheckOut(placeOrder);
      Navigator.pop(context);
    }
  }

  void _onBackPressed(PlaceOrder placeOrder) {
    Navigator.pop(context, placeOrder == null ? FoodCart(Map()) : placeOrder.foodCart);
  }
}

class DeliveryOptions extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<FoodOrderBloc, FoodOrderState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          padding: EdgeInsets.only(
              top: 10 + MediaQuery.of(context).padding.top,
              right: horizontalPaddingDraggable,
              left: horizontalPaddingDraggable),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: RadioCustom(
                  radio: Radio(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      activeColor: Colors.green,
                      value: "delivery",
                      groupValue: state.placeOrder.transactionType,
                      onChanged: (value) {
                        BlocProvider.of<FoodOrderBloc>(context).add(ChangeTransactionType(value));
                      }),
                  icon: "assets/delivery.svg",
                  title: "Delivery",
                  subtitle: "We Deliver At Your Doorstep",
                ),
              ),
              Expanded(
                child: RadioCustom(
                  radio: Radio(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      activeColor: Colors.green,
                      value: "self-pickup",
                      groupValue: state.placeOrder.transactionType,
                      onChanged: (value) {
                        BlocProvider.of<FoodOrderBloc>(context).add(ChangeTransactionType(value));
                      }),
                  icon: "assets/selfpickup.svg",
                  title: "Self Pickup",
                  subtitle: "Go & Pickup The Order On Time",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class RadioCustom extends StatelessWidget {
  final Radio radio;
  final String icon;
  final String title;
  final String subtitle;

  const RadioCustom({Key key, this.radio, this.icon, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          radio,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      icon,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderRowItem extends StatelessWidget {
  final String title;
  final Color color;
  final String amount;

  const OrderRowItem({Key key, this.title, this.color, this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            title,
            style: TextStyle(fontSize: 16, color: color),
          )),
          SvgPicture.asset(
            "assets/rupee.svg",
            width: 10,
            height: 10,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "$amount",
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class FoodListPlaceOrder extends StatefulWidget {
  @override
  _FoodListPlaceOrderState createState() => _FoodListPlaceOrderState();
}

class _FoodListPlaceOrderState extends State<FoodListPlaceOrder> with SingleTickerProviderStateMixin {
  int _selectedFood = -1;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodOrderBloc, FoodOrderState>(
      builder: (context, state) {
        List<Food> foodList = List();
        state.placeOrder.foodCart.cart.forEach((id, food) => foodList.add(food.food));
        return SliverPadding(
          padding: EdgeInsets.only(
              top: 20, bottom: 10, right: horizontalPaddingDraggable - 5, left: horizontalPaddingDraggable - 5),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return FoodItemPlaceOrder(
                index: i,
                selectedPrice: state.placeOrder.foodCart.getSelectedPrice(foodList[i].id),
                scale: _scaleAnimation,
                selectedIndex: _selectedFood,
                food: foodList[i],
                quantity: state.placeOrder.foodCart.getQuantity(foodList[i].id),
                onTapRemove: () {
                  setState(() {
                    _selectedFood = i;
                  });
                  _animationController.forward().orCancel.whenComplete(() {
                    _animationController.reverse().orCancel.whenComplete(() {
                      BlocProvider.of<FoodOrderBloc>(context).add(ChangeQuantityFoodCart(
                          foodList[i].id,
                          foodList[i],
                          (state.placeOrder.foodCart.getQuantity(foodList[i].id) - 1),
                          state.placeOrder.foodCart.getSelectedPrice(foodList[i].id)));
                    });
                  });
                },
                onTapAdd: () {
                  setState(() {
                    _selectedFood = i;
                  });
                  _animationController.forward().orCancel.whenComplete(() {
                    _animationController.reverse().orCancel.whenComplete(() {
                      BlocProvider.of<FoodOrderBloc>(context).add(ChangeQuantityFoodCart(
                          foodList[i].id,
                          foodList[i],
                          (state.placeOrder.foodCart.getQuantity(foodList[i].id) + 1),
                          state.placeOrder.foodCart.getSelectedPrice(foodList[i].id)));
                    });
                  });
                },
              );
            },
            childCount: foodList.length,
          )),
        );
      },
    );
  }
}

class FoodItemPlaceOrder extends StatelessWidget {
  final Food food;
  final int index;
  final int selectedIndex;
  final Function onTapAdd;
  final Function onTapRemove;
  final Animation<double> scale;
  final int quantity;
  final int selectedPrice;

  const FoodItemPlaceOrder({
    Key key,
    this.food,
    this.index,
    this.selectedIndex,
    this.onTapAdd,
    this.onTapRemove,
    this.scale,
    this.quantity,
    this.selectedPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget addButton = index == selectedIndex
        ? AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform.scale(
                scale: scale.value,
                child: child,
                alignment: Alignment.bottomRight,
              );
            },
            child: GestureDetector(
                onTap: onTapAdd,
                child: Container(
                  height: 40,
                  width: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.add), Text("Add")],
                  ),
                )),
          )
        : GestureDetector(
            onTap: onTapAdd,
            child: Container(
              height: 40,
              width: 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Icon(Icons.add), Text("Add")],
              ),
            ));

    Widget changeQuantityButton = Container(
      height: 40,
      width: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.yellow[600],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: onTapRemove,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700], borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                child: Icon(Icons.remove)),
          )),
          Expanded(child: Container(alignment: Alignment.center, child: Text("$quantity"))),
          Expanded(
              child: GestureDetector(
            onTap: onTapAdd,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700], borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                child: Icon(Icons.add)),
          ))
        ],
      ),
    );

    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 2, bottom: 18, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 7,
            spreadRadius: -3,
          )
        ],
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: food.image,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                        child: Container(
                          height: 120,
                          width: 120,
                          color: Colors.black,
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100]);
                  },
                ),
              ),
            ),
            food.isAvailable
                ? Container(
                    height: 12,
                    width: 12,
                    margin: EdgeInsets.only(right: 10, top: 15),
                    child: SvgPicture.asset(
                      "assets/box_circle.svg",
                      width: 12,
                      height: 12,
                    ),
                  )
                : Container(
                    height: 12,
                    width: 12,
                    margin: EdgeInsets.only(right: 10),
                  ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              food.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          food.description != null && food.description != ""
                              ? Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 10, right: 10),
                                  child: Text(
                                    food.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontSize: 10),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      height: 43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                food.discount > 0
                                    ? Text(
                                        "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(food.prices[selectedPrice].price),
                                        style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                                      )
                                    : SizedBox(),
                                Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      "assets/rupee.svg",
                                      height: 11,
                                      width: 11,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice(selectedPrice))}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(),
                          ),
                          quantity == 0
                              ? Expanded(flex: 6, child: addButton)
                              : Expanded(flex: 6, child: changeQuantityButton),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FoodListDeliveryInformation extends StatefulWidget {
  final Address address;
  final String token;
  final String contact;
  final String deliveryEstimation;
  final AddressBloc addressBloc;
  final FoodOrderBloc foodOrderBloc;

  const FoodListDeliveryInformation(
      {Key key, this.address, this.token, this.addressBloc, this.foodOrderBloc, this.contact, this.deliveryEstimation})
      : super(key: key);

  @override
  _FoodListDeliveryInformationState createState() => _FoodListDeliveryInformationState();
}

class _FoodListDeliveryInformationState extends State<FoodListDeliveryInformation> {
  int _countrySelected = 0;
  String _contactPredicate = "+91";
  String _number;
  bool _isChangePrimaryNumber = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.address == null
        ? Container(
            height: 90,
            width: AppUtil.getScreenWidth(context),
            padding:
                EdgeInsets.symmetric(vertical: horizontalPaddingDraggable - 5, horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.orange[100], blurRadius: 5, spreadRadius: 0, offset: Offset(0, -1)),
            ]),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddressPage(
                    forcedDefault: true,
                  );
                }));
                //widget.addressBloc.add(InitDefaultAddress());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Delivery to:"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        "ADD NEW ADDRESS",
                        style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 145,
            width: AppUtil.getScreenWidth(context),
            padding:
                EdgeInsets.symmetric(vertical: horizontalPaddingDraggable - 5, horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.orange[100], blurRadius: 5, spreadRadius: 0, offset: Offset(0, -1)),
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Delivery To"),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(color: Colors.yellow[600], borderRadius: BorderRadius.circular(2)),
                      child: Text(widget.address.title),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<AddressBloc>(context).add(OpenListAddress(widget.token));

                        showModalBottomSheet(
                            isScrollControlled: false,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                            context: context,
                            builder: (context) {
                              return BlocBuilder<AddressBloc, AddressState>(
                                bloc: widget.addressBloc,
                                builder: (context, state) {
                                  if (state is ListAddressLoaded) {
                                    List<Address> list = state.list;
                                    List<Widget> address = [];
                                    for (int i = 0; i < list.length; i++) {
                                      address.add(AddressItemWidget(
                                        address: list[i],
                                        foodOrderBloc: widget.foodOrderBloc,
                                      ));
                                    }

                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                                      child: Stack(
                                        children: <Widget>[
                                          SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20, bottom: kBottomNavigationBarHeight, top: 20),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 52),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: address,
                                                    ),
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
                                                        topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                                                    color: Colors.white),
                                                padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                                                child: Text(
                                                  "SELECT ADDRESS",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                )),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return AddressPage();
                                                  }));
                                                },
                                                child: Container(
                                                  width: AppUtil.getScreenWidth(context),
                                                  height: kBottomNavigationBarHeight,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(right: 20),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                      Text(
                                                        "ADD NEW ADDRESS",
                                                        style: TextStyle(
                                                            color: Colors.orange,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          Positioned(
                                              top: 5,
                                              right: 0,
                                              child: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }))
                                        ],
                                      ),
                                    );
                                  } else if (state is LoadingListAddress) {
                                    return Container(
                                      child: Center(
                                          child: SpinKitCircle(
                                        color: Colors.black38,
                                        size: 30,
                                      )),
                                    );
                                  } else if (state is ErrorLoadingListAddress) {
                                    return Container(
                                        margin: EdgeInsets.symmetric(vertical: 20),
                                        child: Center(child: Text("Fail load addresses")));
                                  }
                                  return Container();
                                },
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        width: 60,
                        child: Text(
                          "Change",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Text(
                        widget.address.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.deliveryEstimation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(text: "Contact Number: ", style: TextStyle(color: Colors.black), children: [
                          TextSpan(
                              text: widget.contact, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        changeContactNumber();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        width: 60,
                        child: Text(
                          "Change",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  void changeContactNumber() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: AppUtil.getScreenWidth(context),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                            color: Colors.white),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "ENTER NUMBER",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12, width: 2)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<int>(
                              underline: Container(),
                              isExpanded: false,
                              isDense: true,
                              iconSize: 0,
                              value: _countrySelected,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            child: SvgPicture.asset("assets/india_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+91",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            child: SvgPicture.asset("assets/singapore_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+65",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (i) {
                                state(() {
                                  _countrySelected = i;
                                  _contactPredicate = i == 0 ? "+91" : "+65";
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration:
                                  BoxDecoration(border: Border(left: BorderSide(color: Colors.black12, width: 2))),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                onChanged: (value) {
                                  state(() {
                                    _number = value;
                                  });
                                },
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _isChangePrimaryNumber,
                            onChanged: (value) {
                              state(() {
                                _isChangePrimaryNumber = value;
                              });
                            },
                            visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                          ),
                          Expanded(child: Text("Do you want to make this number as your primary and login number?"))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _number != "" && _number != null
                          ? () {
                              widget.foodOrderBloc
                                  .add(ChangeContactPhone(_isChangePrimaryNumber, _contactPredicate + _number));
                              Navigator.pop(context);
                            }
                          : () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 32),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFB531),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "SELECT",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: _number != "" && _number != null ? 0.0 : 0.5,
                              child: Container(
                                height: 50,
                                color: Colors.white,
                              ),
                              duration: Duration(milliseconds: 300),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final FoodOrderBloc foodOrderBloc;

  const AddressItemWidget({Key key, this.address, this.foodOrderBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        break;
      case AddressType.office:
        type = "OFFICE";
        break;
      case AddressType.other:
        type = "OTHER";
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          foodOrderBloc.add(ChangeAddress(address));
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.home,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            type,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            address.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          address.address,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black45),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black12,
            )
          ],
        ),
      ),
    );
  }
}
