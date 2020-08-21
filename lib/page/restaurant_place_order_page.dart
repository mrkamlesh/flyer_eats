import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/model/add_on.dart';
import 'package:clients/model/add_ons_type.dart';
import 'package:clients/model/price.dart';
import 'package:clients/model/user.dart';
import 'package:clients/page/change_contact_verify_otp.dart';
import 'package:clients/widget/payment_method_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/voucher.dart';
import 'package:clients/page/address_page.dart';
import 'package:clients/page/apply_coupon_page.dart';
import 'package:clients/page/placed_order_success.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/place_order_bottom_navbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';

class RestaurantPlaceOrderPage extends StatefulWidget {
  final Location location;
  final User user;

  const RestaurantPlaceOrderPage({Key key, this.location, this.user})
      : super(key: key);

  @override
  _RestaurantPlaceOrderPageState createState() =>
      _RestaurantPlaceOrderPageState();
}

class _RestaurantPlaceOrderPageState extends State<RestaurantPlaceOrderPage>
    with SingleTickerProviderStateMixin {
  AddressBloc _addressBloc;

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _addressBloc = AddressBloc(AddressRepository());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

    BlocProvider.of<FoodOrderBloc>(context)..add(InitPlaceOrder(widget.user));
  }

  @override
  void dispose() {
    _addressBloc.close();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<AddressBloc>(
          create: (context) {
            return _addressBloc;
          },
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
                      if (state is InitialFoodOrderState ||
                          state is CartChangeState ||
                          state is ConfirmCartState) {
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
                                        //_onBackPressed(state.placeOrder);
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DraggableScrollableSheet(
                              initialChildSize:
                                  (AppUtil.getScreenHeight(context) -
                                          AppUtil.getToolbarHeight(context)) /
                                      AppUtil.getScreenHeight(context),
                              minChildSize: (AppUtil.getScreenHeight(context) -
                                      AppUtil.getToolbarHeight(context)) /
                                  AppUtil.getScreenHeight(context),
                              maxChildSize: 1.0,
                              builder: (context, controller) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(32),
                                            topLeft: Radius.circular(32))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPaddingDraggable),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/no available items cart.jpg",
                                          width:
                                              AppUtil.getScreenWidth(context) -
                                                  50,
                                        ),
                                        /*SvgPicture.asset(
                                          "assets/no available items cart.svg",
                                          height: AppUtil.getScreenWidth(context) - 50,
                                          width: AppUtil.getScreenWidth(context) - 50,
                                        ),*/
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Text(
                                          "Start browsing and add item",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context, "/home");
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFB531),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                      imageUrl:
                                          state.placeOrder.restaurant.image,
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
                                      title: state.placeOrder.restaurant.name +
                                          " " +
                                          state.placeOrder.foodCart
                                              .cartItemTotal()
                                              .toString(),
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
                            initialChildSize:
                                (AppUtil.getScreenHeight(context) -
                                        AppUtil.getToolbarHeight(context)) /
                                    AppUtil.getScreenHeight(context),
                            minChildSize: (AppUtil.getScreenHeight(context) -
                                    AppUtil.getToolbarHeight(context)) /
                                AppUtil.getScreenHeight(context),
                            maxChildSize: 1.0,
                            builder: (context, controller) {
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
                                      delegate: DeliveryOptions(),
                                      pinned: true,
                                    ),
                                    FoodListPlaceOrder(),
                                    BlocBuilder<FoodOrderBloc, FoodOrderState>(
                                      builder: (context, state) {
                                        if (state is LoadingGetPayments) {
                                          return SliverToBoxAdapter(
                                              child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                left:
                                                    horizontalPaddingDraggable,
                                                right:
                                                    horizontalPaddingDraggable,
                                                bottom:
                                                    kBottomNavigationBarHeight +
                                                        160),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                left:
                                                    horizontalPaddingDraggable,
                                                right:
                                                    horizontalPaddingDraggable,
                                                bottom:
                                                    kBottomNavigationBarHeight +
                                                        160),
                                            child: Container(
                                              child: loginState.user
                                                          .defaultAddress ==
                                                      null
                                                  ? Text("No Address Found")
                                                  : Text(
                                                      state.placeOrder.message),
                                            ),
                                          ));
                                        } else {
                                          return SliverToBoxAdapter(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          horizontalPaddingDraggable,
                                                      horizontal:
                                                          horizontalPaddingDraggable),
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          horizontalPaddingDraggable,
                                                      right:
                                                          horizontalPaddingDraggable,
                                                      bottom: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "DELIVERY INSTRUCTION",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Divider(
                                                        color: Colors.black12,
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {
                                                          BlocProvider.of<
                                                                      FoodOrderBloc>(
                                                                  context)
                                                              .add(
                                                                  ChangeInstruction(
                                                                      value));
                                                        },
                                                        maxLines: 2,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                            hintText:
                                                                "Enter your instruction here",
                                                            hintStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            border: InputBorder
                                                                .none),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                state.placeOrder.voucher.id ==
                                                        null
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          Voucher result =
                                                              await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                            return ApplyCouponPage(
                                                              restaurant: state
                                                                  .placeOrder
                                                                  .restaurant,
                                                              totalOrder: state
                                                                      .placeOrder
                                                                      .subTotal() -
                                                                  state
                                                                      .placeOrder
                                                                      .discountOrder,
                                                            );
                                                          }));

                                                          if (result != null) {
                                                            BlocProvider.of<
                                                                        FoodOrderBloc>(
                                                                    context)
                                                                .add(ApplyVoucher(
                                                                    result));
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 55,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 17,
                                                                  horizontal:
                                                                      horizontalPaddingDraggable),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      horizontalPaddingDraggable),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: shadow,
                                                                blurRadius: 7,
                                                                spreadRadius:
                                                                    -3,
                                                              )
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              SvgPicture.asset(
                                                                "assets/discount.svg",
                                                                height: 24,
                                                                width: 24,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                width: 17,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "APPLY COUPON",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: state.placeOrder
                                                                    .applyVoucherErrorMessage ==
                                                                null
                                                            ? 55
                                                            : 115,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15,
                                                                horizontal:
                                                                    horizontalPaddingDraggable),
                                                        margin: EdgeInsets.only(
                                                            right:
                                                                horizontalPaddingDraggable,
                                                            left:
                                                                horizontalPaddingDraggable),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: shadow,
                                                              blurRadius: 7,
                                                              spreadRadius: -3,
                                                            )
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  SvgPicture
                                                                      .asset(
                                                                    state.placeOrder.applyVoucherErrorMessage ==
                                                                            null
                                                                        ? "assets/check.svg"
                                                                        : "assets/warnings.svg",
                                                                    height: 24,
                                                                    width: 24,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 17,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      state
                                                                          .placeOrder
                                                                          .voucher
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      Voucher result = await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder:
                                                                              (context) {
                                                                        return ApplyCouponPage(
                                                                          restaurant: state
                                                                              .placeOrder
                                                                              .restaurant,
                                                                          totalOrder: state
                                                                              .placeOrder
                                                                              .getTotal(),
                                                                        );
                                                                      }));

                                                                      if (result !=
                                                                          null) {
                                                                        BlocProvider.of<FoodOrderBloc>(context)
                                                                            .add(ApplyVoucher(result));
                                                                      }
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/add review icon.svg",
                                                                      height:
                                                                          24,
                                                                      width: 24,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      BlocProvider.of<FoodOrderBloc>(
                                                                              context)
                                                                          .add(
                                                                              RemoveVoucher());
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/remove.svg",
                                                                      height:
                                                                          24,
                                                                      width: 24,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              state.placeOrder
                                                                          .applyVoucherErrorMessage !=
                                                                      null
                                                                  ? Expanded(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        padding:
                                                                            EdgeInsets.all(7),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            state.placeOrder.applyVoucherErrorMessage,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                Container(
                                                  height: 55,
                                                  margin: EdgeInsets.only(
                                                      top: 20,
                                                      left:
                                                          horizontalPaddingDraggable,
                                                      right:
                                                          horizontalPaddingDraggable),
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 17,
                                                      right: 17),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 25,
                                                        child: Checkbox(
                                                            activeColor:
                                                                Colors.green,
                                                            value: state
                                                                .placeOrder
                                                                .isUseWallet,
                                                            onChanged: (value) {
                                                              BlocProvider.of<
                                                                          FoodOrderBloc>(
                                                                      context)
                                                                  .add(ChangeWalletUsage(
                                                                      value));
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        width: 17,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "WALLET AMOUNT",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            AppUtil.getCurrencyIcon(
                                                                state
                                                                    .placeOrder
                                                                    .restaurant
                                                                    .currencyCode),
                                                            height: 10,
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            AppUtil.doubleRemoveZeroTrailing(state
                                                                    .placeOrder
                                                                    .walletAmount -
                                                                state.placeOrder
                                                                    .getWalletUsed()),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 20,
                                                      left:
                                                          horizontalPaddingDraggable,
                                                      right:
                                                          horizontalPaddingDraggable,
                                                      bottom: 20),
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          horizontalPaddingDraggable,
                                                      right:
                                                          horizontalPaddingDraggable,
                                                      top:
                                                          horizontalPaddingDraggable,
                                                      bottom: 7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                        title: "Item Total",
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.black,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state.placeOrder
                                                                    .subTotal()),
                                                      ),
                                                      OrderRowItem(
                                                        title: state.placeOrder
                                                            .taxPrettyString,
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.black,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state.placeOrder
                                                                    .taxCharges),
                                                      ),
                                                      OrderRowItem(
                                                        title: "Packaging",
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.black,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state.placeOrder
                                                                    .packagingCharges),
                                                      ),
                                                      OrderRowItem(
                                                        title: "Delivery Fee",
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.black,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state.placeOrder
                                                                    .deliveryCharges),
                                                      ),
                                                      /*OrderRowItem(
                                                        title: "DISCOUNT FOOD",
                                                        color: Colors.green,
                                                        amount: AppUtil.doubleRemoveZeroTrailing(
                                                            state.placeOrder.getDiscountFoodTotal()),
                                                      ),*/
                                                      OrderRowItem(
                                                        title: state.placeOrder
                                                            .discountOrderPrettyString,
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.green,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state.placeOrder
                                                                    .discountOrder),
                                                      ),
                                                      OrderRowItem(
                                                        title: "Coupon/Voucher",
                                                        currencyIcon: AppUtil
                                                            .getCurrencyIcon(state
                                                                .placeOrder
                                                                .restaurant
                                                                .currencyCode),
                                                        color: Colors.green,
                                                        amount: AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                state
                                                                    .placeOrder
                                                                    .voucher
                                                                    .amount),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 13),
                                                        child: Divider(
                                                          height: 1,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      OrderRowItem(
                                                          title: "Total",
                                                          currencyIcon: AppUtil
                                                              .getCurrencyIcon(state
                                                                  .placeOrder
                                                                  .restaurant
                                                                  .currencyCode),
                                                          color: Colors.black,
                                                          amount: AppUtil
                                                              .doubleRemoveZeroTrailing(state
                                                                  .placeOrder
                                                                  .getTotal())),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          horizontalPaddingDraggable,
                                                      horizontal:
                                                          horizontalPaddingDraggable),
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          horizontalPaddingDraggable,
                                                      right:
                                                          horizontalPaddingDraggable,
                                                      bottom: state.placeOrder
                                                                  .transactionType ==
                                                              "pickup"
                                                          ? kBottomNavigationBarHeight +
                                                              30
                                                          : kBottomNavigationBarHeight +
                                                              170),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: shadow,
                                                        blurRadius: 7,
                                                        spreadRadius: -3,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "DELIVERY TIME",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Choose time when order will be delivered",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 12),
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
                                                          showDeliveryOptions(
                                                              state.placeOrder);
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/calendar.svg",
                                                                  height: 18,
                                                                  width: 18,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  state
                                                                      .placeOrder
                                                                      .getDeliveryDatePretty(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )
                                                              ],
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container()),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/clock.svg",
                                                                  height: 18,
                                                                  width: 18,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  state
                                                                      .placeOrder
                                                                      .getDeliveryTime(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
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
                                        foodOrderBloc:
                                            BlocProvider.of<FoodOrderBloc>(
                                                context),
                                        addressBloc: _addressBloc,
                                        contact: state.placeOrder.contact,
                                        deliveryEstimation: state.placeOrder
                                            .restaurant.deliveryEstimation,
                                      )
                                    : Container(),
                                OrderBottomNavBar(
                                  isValid: state.placeOrder.isValid,
                                  currencyIcon: AppUtil.getCurrencyIcon(
                                      state.placeOrder.restaurant.currencyCode),
                                  onButtonTap: state.placeOrder.isValid &&
                                          !(state is LoadingPlaceOrder)
                                      ? () {
                                          placeOrderButtonTap(state.placeOrder);
                                        }
                                      : () {},
                                  showCurrency: (state is LoadingGetPayments)
                                      ? false
                                      : true,
                                  amount: (state is LoadingGetPayments)
                                      ? "..."
                                      : AppUtil.doubleRemoveZeroTrailing(
                                          state.placeOrder.getTotal() -
                                              state.placeOrder.getWalletUsed()),
                                  buttonText: "PLACE ORDER",
                                  description: (state is LoadingGetPayments)
                                      ? "Calculating..."
                                      : "Total Amount",
                                ),
                              ],
                            ),
                          ),
                          BlocConsumer<FoodOrderBloc, FoodOrderState>(
                            listener: (context, state) async {
                              if (state is SuccessPlaceOrder) {
                                BlocProvider.of<FoodOrderBloc>(context)
                                    .add(ClearCart());
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Text(
                                          "Place Order Error",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(state.message),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (state is CancelledPlaceOrder) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Text(
                                          "Place Order Cancelled",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(state.message),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (state
                                  is ErrorRequestOtpChangeContact) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Text(
                                          "Request OTP Failed",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(state.message),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (state
                                  is SuccessRequestOtpChangeContact) {
                                bool result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChangeContactVerifyOtp(
                                    isChangePrimaryContact:
                                        state.isChangePrimaryContact,
                                    contact: state.newContact,
                                    token: loginState.user.token,
                                  );
                                }));

                                if (result != null) {
                                  BlocProvider.of<FoodOrderBloc>(context).add(
                                      ChangeContactPhone(
                                          state.isChangePrimaryContact,
                                          state.newContact));
                                  if (state.isChangePrimaryContact) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        UpdatePrimaryContact(state.newContact));
                                    _showContactConfirmationDialog(
                                        state.newContact);
                                  }
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is LoadingPlaceOrder ||
                                  state is LoadingRequestOtpChangeContact) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
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
                          children:
                              placeOrder.getDeliveryTimeOptions().map((time) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable),
                              child: RadioListTile<DateTime>(
                                dense: true,
                                onChanged: (value) {
                                  newState(() {
                                    groupValue = value;
                                  });
                                  BlocProvider.of<FoodOrderBloc>(context)
                                      .add(ChangeDeliveryTime(value));
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32)),
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
    bool isLoading = false;
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        builder: (context, controller) {
          return StatefulBuilder(
            builder: (context, newState) {
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: 40, horizontal: horizontalPaddingDraggable - 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: PaymentMethodListWidget(
                  paymentMethods: placeOrder.listPaymentMethod,
                  onTap: (i) {
                    if (!isLoading){
                      isLoading = true;
                      Navigator.pop(context);
                      _onPaymentOptionsSelected(
                          placeOrder, placeOrder.listPaymentMethod[i].value);
                    }
                  },
                ),
              );
            },
          );
        });
  }

  openRazorPayCheckOut(PlaceOrder placeOrder) {
    var options = {
      "key": placeOrder.razorKey,
      //"rzp_test_shynWbWngI8JsA", // change to placeOrder.razorKey
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
    BlocProvider.of<FoodOrderBloc>(context).add(PlaceOrderEvent());
  }

  void handlerPaymentError(PaymentFailureResponse response) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    if (placeOrder.applyVoucherErrorMessage == null) {
      if ((placeOrder.getTotal() - placeOrder.getWalletUsed()) > 0.0) {
        showPaymentMethodOptions(placeOrder);
      } else {
        BlocProvider.of<FoodOrderBloc>(context)
            .add(ChangePaymentMethod("wallet"));
        BlocProvider.of<FoodOrderBloc>(context).add(PlaceOrderEvent());
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                "Voucher Can Not Be Applied",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(placeOrder.applyVoucherErrorMessage),
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
  }

  void _onPaymentOptionsSelected(PlaceOrder placeOrder, selectedPaymentMethod) {
    BlocProvider.of<FoodOrderBloc>(context)
        .add(ChangePaymentMethod(selectedPaymentMethod));
    if (selectedPaymentMethod == "cod") {
      BlocProvider.of<FoodOrderBloc>(context).add(PlaceOrderEvent());
    } else if (selectedPaymentMethod == "rzr") {
      openRazorPayCheckOut(placeOrder);
    } else if (selectedPaymentMethod == "stp") {
      BlocProvider.of<FoodOrderBloc>(context).add(PlaceOrderStripeEvent());
    }
  }

  void _onBackPressed(PlaceOrder placeOrder) {
    Navigator.pop(context,
        placeOrder == null ? FoodCart(Map(), List()) : placeOrder.foodCart);
  }

  Future<void> _showContactConfirmationDialog(String contact) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(horizontalPaddingDraggable),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("NOTIFICATION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("Your Number",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Colors.black38)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(AppUtil.formattedPhoneNumber(contact),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "will be used as login ID for next time and the OTP will be used as password",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFB531),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "GOT IT",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]));
        });
  }
}

class DeliveryOptions extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<FoodOrderBloc, FoodOrderState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      activeColor: Colors.green,
                      value: "delivery",
                      groupValue: state.placeOrder.transactionType,
                      onChanged: (value) {
                        BlocProvider.of<FoodOrderBloc>(context)
                            .add(ChangeTransactionType(value));
                      }),
                  icon: "assets/delivery.svg",
                  title: "Delivery",
                  subtitle: "We Deliver At Your Doorstep",
                ),
              ),
              Expanded(
                child: RadioCustom(
                  radio: Radio(
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      activeColor: Colors.green,
                      value: "pickup",
                      groupValue: state.placeOrder.transactionType,
                      onChanged: (value) {
                        BlocProvider.of<FoodOrderBloc>(context)
                            .add(ChangeTransactionType(value));
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
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

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

  const RadioCustom({Key key, this.radio, this.icon, this.title, this.subtitle})
      : super(key: key);

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  maxLines: 2,
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
  final String currencyIcon;

  const OrderRowItem(
      {Key key, this.title, this.color, this.amount, this.currencyIcon})
      : super(key: key);

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
            currencyIcon,
            width: 10,
            height: 10,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "$amount",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 16),
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

class _FoodListPlaceOrderState extends State<FoodListPlaceOrder>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodOrderBloc, FoodOrderState>(
      builder: (context, state) {
        return SliverPadding(
          padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
              right: horizontalPaddingDraggable,
              left: horizontalPaddingDraggable),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return FoodItemPlaceOrder(
                index: i,
                currencyIcon: AppUtil.getCurrencyIcon(
                    state.placeOrder.restaurant.currencyCode),
                onTapEditAddOns: () {
                  _showAddOnsEditSheet(
                      state.placeOrder.foodCart.getAllFoodCartItem()[i]);
                },
                foodCartItem: state.placeOrder.foodCart.getAllFoodCartItem()[i],
                quantity:
                    state.placeOrder.foodCart.getAllFoodCartItem()[i].quantity,
                onTapRemove: () {
                  BlocProvider.of<FoodOrderBloc>(context)
                      .add(ChangeQuantityWithPayment(
                    state.placeOrder.foodCart.getAllFoodCartItem()[i],
                    ((state.placeOrder.foodCart
                            .getAllFoodCartItem()[i]
                            .quantity) -
                        1),
                  ));
                },
                onTapAdd: () {
                  BlocProvider.of<FoodOrderBloc>(context)
                      .add(ChangeQuantityWithPayment(
                    state.placeOrder.foodCart.getAllFoodCartItem()[i],
                    ((state.placeOrder.foodCart
                            .getAllFoodCartItem()[i]
                            .quantity) +
                        1),
                  ));
                },
              );
            },
            childCount: state.placeOrder.foodCart.getAllFoodCartItem().length,
          )),
        );
      },
    );
  }

  _showAddOnsEditSheet(FoodCartItem cartItem) {
    Price price;
    Map<int, AddOn> multipleAddOns = Map();
    //Map<int, List<TextEditingController>> textControllersMap = Map();
    Map<int, int> maxNumberMap = Map();
    int quantity = cartItem.quantity;

    BlocProvider.of<FoodOrderBloc>(context).add(StartEditFoodDetail(cartItem));
    showMaterialModalBottomSheet(
        duration: Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        expand: false,
        builder: (context, controller) {
          return StatefulBuilder(
            builder: (context, newState) {
              return Container(
                height: AppUtil.getScreenHeight(context) * 3 / 4,
                width: AppUtil.getScreenWidth(context),
                padding: EdgeInsets.only(top: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: BlocConsumer<FoodOrderBloc, FoodOrderState>(
                  listener: (context, cartState) {
                    if (cartState is SuccessGetFoodDetail) {
                      price = _getSelectedPrice(
                          cartItem.price, cartState.foodDetail.prices);
                      for (int i = 0;
                          i < cartState.foodDetail.addOnsTypes.length;
                          i++) {
                        if (cartState.foodDetail.addOnsTypes[i].options ==
                            "one") {
                          cartState.foodDetail.addOnsTypes[i].addOns
                              .forEach((addOn) {
                            if (addOn.isSelected) {
                              multipleAddOns[i] = addOn;
                            }
                          });
                        }
                      }

                      for (int i = 0;
                          i < cartState.foodDetail.addOnsTypes.length;
                          i++) {
                        if (cartState.foodDetail.addOnsTypes[i].options ==
                            "custom") {
                          maxNumberMap[i] =
                              cartState.foodDetail.addOnsTypes[i].maxNumber;
                        }
                        /*if (cartState.foodDetail.addOnsTypes[i].options ==
                            "one") {
                          textControllersMap[i] = List<TextEditingController>();
                          for (int j = 0;
                              j <
                                  cartState
                                      .foodDetail.addOnsTypes[i].addOns.length;
                              j++) {
                            TextEditingController textController =
                                TextEditingController(
                                    text: cartState.foodDetail.addOnsTypes[i]
                                        .addOns[j].quantity
                                        .toString());
                            textControllersMap[i].add(textController);
                          }
                        }*/
                      }
                    }
                  },
                  builder: (context, cartState) {
                    if (cartState is LoadingGetFoodDetail) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (cartState is ErrorGetFoodDetail) {
                      return Center(
                        child: Text(cartState.message),
                      );
                    } else if (cartState is SuccessGetFoodDetail) {
                      List<Widget> listWidget = List();
                      listWidget.add(
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                top: 10,
                                bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SIZE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ),
                      );
                      listWidget.add(SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          return RadioListTile<Price>(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        cartState.foodDetail.prices[i].size)),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppUtil.getCurrencyIcon(cartState
                                          .placeOrder.restaurant.currencyCode),
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(width: 3),
                                    Text((cartState.foodDetail.prices[i]
                                            .discountedPrice)
                                        .toString()),
                                  ],
                                )
                              ],
                            ),
                            value: cartState.foodDetail.prices[i],
                            onChanged: (i) {
                              newState(() {
                                price = i;
                              });
                            },
                            groupValue: price,
                          );
                        }, childCount: cartState.foodDetail.prices.length),
                      ));

                      for (int i = 0;
                          i < cartState.foodDetail.addOnsTypes.length;
                          i++) {
                        listWidget.add(SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                                top: 10,
                                bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  cartState.foodDetail.addOnsTypes[i].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ));
                        if (cartState.foodDetail.addOnsTypes[i].options ==
                            "multiple") {
                          // one is check box with number inside
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    cartState.foodDetail.addOnsTypes[i]
                                        .addOns[j].isSelected = bool;
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i]
                                    .addOns[j].isSelected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    /*Container(
                                      width: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: textControllersMap[i][j],
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          newState(() {
                                            if (text == "") {
                                              cartState
                                                  .foodDetail
                                                  .addOnsTypes[i]
                                                  .addOns[j]
                                                  .quantity = 0;
                                            } else {
                                              cartState
                                                  .foodDetail
                                                  .addOnsTypes[i]
                                                  .addOns[j]
                                                  .quantity = int.parse(text);
                                            }
                                          });
                                        },
                                      ),
                                    ),*/
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(cartState
                                              .placeOrder
                                              .restaurant
                                              .currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState
                                .foodDetail.addOnsTypes[i].options ==
                            "one") {
                          // multiple is radio button
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return RadioListTile<AddOn>(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(cartState
                                              .placeOrder
                                              .restaurant
                                              .currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                                value: cartState
                                    .foodDetail.addOnsTypes[i].addOns[j],
                                onChanged: (addOn) {
                                  newState(() {
                                    multipleAddOns[i] = addOn;
                                    cartState.foodDetail.addOnsTypes[i].addOns
                                        .forEach((e) {
                                      e.isSelected = false;
                                    });
                                    addOn.isSelected = true;
                                  });
                                },
                                groupValue: multipleAddOns[i],
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        } else if (cartState
                                .foodDetail.addOnsTypes[i].options ==
                            "custom") {
                          // custom is check box only
                          listWidget.add(SliverList(
                            delegate: SliverChildBuilderDelegate((context, j) {
                              return CheckboxListTile(
                                onChanged: (bool) {
                                  newState(() {
                                    if (bool) {
                                      if (cartState.foodDetail.addOnsTypes[i]
                                              .getSelectedAddOn()
                                              .length ==
                                          cartState.foodDetail.addOnsTypes[i]
                                              .maxNumber) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: Text(
                                                "Can Not Select Add On",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                "For this type of Add On you can only select " +
                                                    maxNumberMap[i].toString() +
                                                    " items",
                                                style: TextStyle(
                                                    color: Colors.black54),
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
                                        );
                                      } else {
                                        cartState.foodDetail.addOnsTypes[i]
                                            .addOns[j].isSelected = bool;
                                      }
                                    } else {
                                      cartState.foodDetail.addOnsTypes[i]
                                          .addOns[j].isSelected = bool;
                                    }
                                  });
                                },
                                value: cartState.foodDetail.addOnsTypes[i]
                                    .addOns[j].isSelected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(cartState.foodDetail
                                            .addOnsTypes[i].addOns[j].name)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppUtil.getCurrencyIcon(cartState
                                              .placeOrder
                                              .restaurant
                                              .currencyCode),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(width: 3),
                                        Text((cartState.foodDetail
                                                .addOnsTypes[i].addOns[j].price)
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                                childCount: cartState
                                    .foodDetail.addOnsTypes[i].addOns.length),
                          ));
                        }
                      }

                      listWidget.add(SliverToBoxAdapter(
                        child: SizedBox(
                          height: kBottomNavigationBarHeight + 30,
                        ),
                      ));

                      return Stack(
                        children: <Widget>[
                          CustomScrollView(
                            controller: controller,
                            slivers: listWidget,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: kBottomNavigationBarHeight,
                              width: AppUtil.getScreenWidth(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.yellow[600]))),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: price == null || quantity == 0
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: quantity > 1
                                                      ? InkWell(
                                                          onTap: () {
                                                            newState(() {
                                                              quantity--;
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons.remove))
                                                      : SizedBox(),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "$quantity",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                      onTap: () {
                                                        newState(() {
                                                          quantity++;
                                                        });
                                                      },
                                                      child: Icon(Icons.add)),
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: GestureDetector(
                                        onTap: price == null || quantity == 0
                                            ? () {}
                                            : () {
                                                //do something add item here
                                                Navigator.pop(context);
                                                BlocProvider.of<FoodOrderBloc>(
                                                        context)
                                                    .add(UpdateFoodDetail(
                                                        cartItem,
                                                        quantity,
                                                        price,
                                                        _getAddOns(cartState
                                                            .foodDetail
                                                            .addOnsTypes)));
                                              },
                                        child: SizedBox.expand(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[600],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    18))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            AppUtil.getCurrencyIcon(
                                                                cartState
                                                                    .placeOrder
                                                                    .restaurant
                                                                    .currencyCode),
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            AppUtil.doubleRemoveZeroTrailing(
                                                                _getTotalFoodDetail(
                                                                    price,
                                                                    quantity,
                                                                    cartState
                                                                        .foodDetail
                                                                        .addOnsTypes)),
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "UPDATE",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                opacity: price == null ||
                                                        quantity == 0
                                                    ? 0.65
                                                    : 0.0,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                                duration:
                                                    Duration(milliseconds: 300),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              );
            },
          );
        });
  }

  double _getTotalFoodDetail(
      Price price, int quantity, List<AddOnsType> addOnsTypes) {
    double totalAmount = 0;

    if (price == null || quantity == 0) {
      return 0;
    } else {
      totalAmount = price.discountedPrice * quantity;

      addOnsTypes.forEach((element) {
        totalAmount = totalAmount + element.getAmount();
      });
    }

    return totalAmount;
  }

  List<AddOn> _getAddOns(List<AddOnsType> addOnsTypes) {
    List<AddOn> list = List();

    addOnsTypes.forEach((element) {
      list = list + element.getSelectedAddOn();
    });

    return list;
  }

  Price _getSelectedPrice(Price selectedPrice, List<Price> prices) {
    Price p;
    prices.forEach((price) {
      if (selectedPrice.sizeId == price.sizeId) {
        p = price;
      }
    });

    return p;
  }
}

class FoodItemPlaceOrder extends StatelessWidget {
  final FoodCartItem foodCartItem;
  final int index;
  final Function onTapAdd;
  final Function onTapRemove;
  final Animation<double> scale;
  final int quantity;
  final Function onTapEditAddOns;
  final String currencyIcon;

  const FoodItemPlaceOrder({
    Key key,
    this.foodCartItem,
    this.index,
    this.onTapAdd,
    this.onTapRemove,
    this.scale,
    this.quantity,
    this.onTapEditAddOns,
    this.currencyIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 13,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodCartItem.food.title + " " + foodCartItem.price.size,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      foodCartItem.hasAddOns()
                          ? InkWell(
                              onTap: onTapEditAddOns,
                              child: Text(
                                foodCartItem.addOnsToString(),
                                style: TextStyle(color: primary3, fontSize: 12),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                foodCartItem.hasAddOns()
                    ? InkWell(
                        onTap: onTapEditAddOns,
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(
                            Icons.edit,
                            color: Colors.yellow[700],
                            size: 18,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              width: 110,
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: onTapRemove,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: Icon(Icons.remove)),
                  )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text("$quantity"))),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTapAdd,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SvgPicture.asset(
                  currencyIcon,
                  height: 10,
                  width: 10,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "${AppUtil.doubleRemoveZeroTrailing(foodCartItem.getAmount())}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
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
      {Key key,
      this.address,
      this.token,
      this.addressBloc,
      this.foodOrderBloc,
      this.contact,
      this.deliveryEstimation})
      : super(key: key);

  @override
  _FoodListDeliveryInformationState createState() =>
      _FoodListDeliveryInformationState();
}

class _FoodListDeliveryInformationState
    extends State<FoodListDeliveryInformation> {
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
            padding: EdgeInsets.symmetric(
                vertical: horizontalPaddingDraggable - 5,
                horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, -1)),
            ]),
            child: GestureDetector(
              onTap: () async {
                Address address = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AddressPage(
                    forcedDefault: false,
                  );
                }));

                if (address != null) {
                  BlocProvider.of<LoginBloc>(context)
                      .add(UpdateDefaultAddress(address));
                  widget.foodOrderBloc.add(ChangeAddress(address));
                }
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
                        margin: EdgeInsets.only(right: 10),
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
                ],
              ),
            ),
          )
        : Container(
            height: 145,
            width: AppUtil.getScreenWidth(context),
            padding: EdgeInsets.symmetric(
                vertical: horizontalPaddingDraggable - 5,
                horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, -1)),
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          widget.address.title,
                          maxLines: 1,
                          style: TextStyle(backgroundColor: Colors.yellow[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showChangeAddressSheet(
                            BlocProvider.of<LoginBloc>(context));
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
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
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
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
                        text: TextSpan(
                            text: "Contact Number: ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: widget.contact,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showChangeContactSheet();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
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

  void _showChangeAddressSheet(LoginBloc loginBloc) {
    BlocProvider.of<AddressBloc>(context).add(OpenListAddress(widget.token));

    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
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
                    onTap: () {
                      widget.foodOrderBloc.add(ChangeAddress(list[i]));
                      BlocProvider.of<LoginBloc>(context)
                          .add(UpdateDefaultAddress(list[i]));

                      Navigator.pop(context);
                    },
                  ));
                }

                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: kBottomNavigationBarHeight,
                              top: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32)),
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
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32)),
                                color: Colors.white),
                            padding:
                                EdgeInsets.only(top: 20, left: 20, bottom: 20),
                            child: Text(
                              "SELECT ADDRESS",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              Address address = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AddressPage(
                                  forcedDefault: false,
                                );
                              }));

                              if (address != null) {
                                loginBloc.add(UpdateDefaultAddress(address));
                                widget.foodOrderBloc
                                    .add(ChangeAddress(address));
                              }
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
  }

  void _showChangeContactSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: Colors.white),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "ENTER NUMBER",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingDraggable),
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
                                            child: SvgPicture.asset(
                                                "assets/india_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+91",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
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
                                            child: SvgPicture.asset(
                                                "assets/singapore_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+65",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
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
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.black12, width: 2))),
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
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingDraggable, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _isChangePrimaryNumber,
                            onChanged: (value) {
                              state(() {
                                _isChangePrimaryNumber = value;
                              });
                            },
                            visualDensity:
                                VisualDensity(vertical: 0, horizontal: 0),
                          ),
                          Expanded(
                              child: Text(
                                  "Do you want to make this number as your primary and login number?"))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _number != "" && _number != null
                          ? () {
                              widget.foodOrderBloc.add(RequestOtpChangeContact(
                                  _isChangePrimaryNumber,
                                  _contactPredicate + _number));
                              Navigator.pop(context);
                            }
                          : () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 32),
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
                                "UPDATE AND PROCEED",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity:
                                  _number != "" && _number != null ? 0.0 : 0.5,
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
  final Function onTap;

  const AddressItemWidget({Key key, this.address, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    String icon;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        icon = "assets/home address.svg";
        break;
      case AddressType.office:
        type = "OFFICE";
        icon = "assets/office address.svg";
        break;
      case AddressType.other:
        type = "OTHER";
        icon = "assets/others address.svg";
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      icon,
                      width: 20,
                      height: 20,
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            address.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
