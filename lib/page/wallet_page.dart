import 'package:clients/model/payment_method.dart';
import 'package:clients/widget/payment_method_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/wallet/wallet_bloc.dart';
import 'package:clients/bloc/wallet/wallet_event.dart';
import 'package:clients/bloc/wallet/wallet_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/wallet.dart';
import 'package:clients/page/scratch_card_list_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyWalletPage extends StatefulWidget {
  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  WalletBloc _bloc;
  Razorpay _razorpay;

  String _token;

  @override
  void initState() {
    super.initState();
    _bloc = WalletBloc();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    _bloc.close();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        _token = loginState.user.token;
        return BlocProvider<WalletBloc>(
          create: (context) {
            return _bloc..add(GetWalletInfo(loginState.user.token));
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
                        title: "My Wallet",
                        onTapLeading: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
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
                    return BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        if (state is LoadingWalletState) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(32),
                                    topLeft: Radius.circular(32))),
                            child: Center(
                              child: SpinKitCircle(
                                color: Colors.black38,
                                size: 30,
                              ),
                            ),
                          );
                        } else if (state is ErrorWalletState) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPaddingDraggable),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(32),
                                    topLeft: Radius.circular(32))),
                            child: Center(
                              child: Text(
                                state.message,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          child: Stack(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
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
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      margin: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom: horizontalPaddingDraggable,
                                          top: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 15),
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: SvgPicture.asset(
                                                      "assets/wallet.svg",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Total Wallet Amount",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      "Current Balance",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.black38),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    AppUtil.getCurrencyIcon(
                                                        state.wallet
                                                            .currencyCode),
                                                    color: primary3,
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    alignment:
                                                    Alignment.bottomRight,
                                                    child: Text(
                                                      AppUtil
                                                          .doubleRemoveZeroTrailing(
                                                          state.wallet
                                                              .walletAmount),
                                                      textAlign:
                                                      TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: primary3,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Added Money + Loyalty Reward Points + Scratch Card",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black45),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Colors.black12,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _showAddMoneySheet(
                                                  loginState.user,
                                                  state.wallet);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 15,
                                                  bottom:
                                                  horizontalPaddingDraggable),
                                              child: Text(
                                                "ADD MONEY",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: primary3,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return ScratchCardPage();
                                                }));

                                        _bloc.add(GetWalletInfo(
                                            loginState.user.token));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: shadow,
                                              blurRadius: 7,
                                              spreadRadius: -3,
                                            )
                                          ],
                                        ),
                                        margin: EdgeInsets.only(
                                            left: horizontalPaddingDraggable,
                                            right: horizontalPaddingDraggable,
                                            bottom: 20),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                              EdgeInsets.only(right: 15),
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: SvgPicture.asset(
                                                    "assets/wallet.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Scratch Card",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          "Current Balance",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black38),
                                                        ),
                                                      ),
                                                      SvgPicture.asset(
                                                        AppUtil.getCurrencyIcon(
                                                            state.wallet
                                                                .currencyCode),
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        AppUtil.doubleRemoveZeroTrailing(
                                                            state.wallet
                                                                .scratchAmount),
                                                        textAlign:
                                                        TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    "View in detailed",
                                                    style: TextStyle(
                                                        color: primary3,
                                                        fontSize: 13,
                                                        decoration:
                                                        TextDecoration
                                                            .underline),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (state is LoadingAddWallet)
                                  ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(32),
                                        topLeft: Radius.circular(32))),
                                child: Center(
                                  child: SpinKitCircle(
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              )
                                  : SizedBox()
                            ],
                          ),
                        );
                      },
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

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    _bloc..add(AddWallet(_token))..add(GetWalletInfo(_token));
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

  openRazorPayCheckOut(User user, Wallet wallet, double amount) {
    var options = {
      "key": wallet.razorpayKey,
      //"rzp_test_shynWbWngI8JsA", // change to placeOrder.razorKey
      "amount": (amount * 100.0).ceil().toString(),
      "name": "Flyer Eats",
      "description": "Payment Add Money to Wallet",
      "prefill": {
        "contact": user.phone,
        "email": user.username,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  bool amountIsValid(String amount) {
    if (amount == null || amount == "") {
      return false;
    } else {
      if (double.parse(amount) > 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _showAddMoneySheet(User user, Wallet wallet) {
    //var maskFormatter = new MaskTextInputFormatter(mask: "$currency # ### ### ", filter: {"#": RegExp(r'[0-9]')});

    String _money;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: AppUtil.getScreenWidth(context),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "ADD MONEY",
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom: 20),
                        child: Text(
                            "Enter how much money you want to add to wallet"),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom: 20),
                        child: Center(
                          child: TextField(
                            autofocus: true,
                            onChanged: (value) {
                              state(() {
                                _money = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 50),
                            decoration: InputDecoration(
                                hintText: AppUtil.getCurrencyString(
                                    wallet.currencyCode) +
                                    " 0",
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 15),
                                hintStyle: TextStyle(
                                    fontSize: 50, color: Colors.black12),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary2)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary2)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary2))),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: amountIsValid(_money)
                            ? () {
                          openRazorPayCheckOut(
                              user, wallet, double.parse(_money));
                          _bloc.add(InitAmount(double.parse(_money)));
                          Navigator.pop(context);
                        }
                            : () {},
                        child: Container(
                          margin: EdgeInsets.only(
                              left: horizontalPaddingDraggable,
                              right: horizontalPaddingDraggable,
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  32),
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
                                  "ADD",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: amountIsValid(_money) ? 0.0 : 0.5,
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
                ),
              );
            },
          );
        });
  }

  showPaymentMethodOptions(List<PaymentMethod> paymentMethodList, User user,
      Wallet wallet, double amount) {
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
                  paymentMethods: paymentMethodList,
                  onTap: (i) {
                    if (!isLoading) {
                      isLoading = true;
                      Navigator.pop(context);
                      _onPaymentOptionsSelected(
                          user, wallet, amount, wallet.paymentMethods[i].value);
                    }
                  },
                ),
              );
            },
          );
        });
  }

  void _onPaymentOptionsSelected(
      User user, Wallet wallet, double amount, String selectedPaymentMethod) {
    if (selectedPaymentMethod == "rzr") {
      openRazorPayCheckOut(user, wallet, amount);
    } else if (selectedPaymentMethod == "stp") {
    } else if (selectedPaymentMethod == "cfr") {

    }
  }
}
