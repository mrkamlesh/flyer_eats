import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/bloc/wallet/wallet_bloc.dart';
import 'package:flyereats/bloc/wallet/wallet_event.dart';
import 'package:flyereats/bloc/wallet/wallet_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/loyalty_reward_points_page.dart';
import 'package:flyereats/page/scratch_card_list_page.dart';
import 'package:flyereats/widget/app_bar.dart';

class MyWalletPage extends StatefulWidget {
  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  WalletBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WalletBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
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
                        title: "Order History",
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
                    return BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        if (state is LoadingWalletState) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                            child: Center(
                              child: SpinKitCircle(
                                color: Colors.black38,
                                size: 30,
                              ),
                            ),
                          );
                        } else if (state is ErrorWalletState) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                            child: Center(
                              child: Text(state.message),
                            ),
                          );
                        } else if (state is SuccessWalletState) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                            padding: EdgeInsets.only(top: 20),
                            child: SingleChildScrollView(
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
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                                    margin: EdgeInsets.only(
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable,
                                        bottom: horizontalPaddingDraggable),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 15),
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Total Wallet Amount",
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    "Current Balance",
                                                    style: TextStyle(fontSize: 13, color: Colors.black38),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                /*SizedBox(
                                                  width: 11,
                                                  height: 17,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: SvgPicture.asset(
                                                      "assets/rupee.svg",
                                                      color: primary3,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),*/
                                                Container(
                                                  alignment: Alignment.bottomRight,
                                                  child: Text(
                                                    state.wallet.currency +
                                                        " " +
                                                        AppUtil.doubleRemoveZeroTrailing(state.wallet.walletAmount),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 30, color: primary3, fontWeight: FontWeight.bold),
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
                                                style: TextStyle(fontSize: 12, color: Colors.black45),
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
                                        Container(
                                          padding: EdgeInsets.only(top: 15, bottom: horizontalPaddingDraggable),
                                          child: Text(
                                            "ADD MONEY",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: primary3,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return LoyaltyRewardPointsPage();
                                      }));
                                    },
                                    child: Container(
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
                                      margin: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom: 20),
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 15),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Loyalty Reward Points",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        "Current Balance",
                                                        style: TextStyle(fontSize: 13, color: Colors.black38),
                                                      ),
                                                    ),
                                                    /*SizedBox(
                                                      width: 5,
                                                      height: 8,
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: SvgPicture.asset(
                                                          "assets/rupee.svg",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),*/
                                                    Text(
                                                      "0",
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ScratchCardPage();
                                      }));
                                    },
                                    child: Container(
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
                                      margin: EdgeInsets.only(
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom: 20),
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 15),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Scratch Card",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        "Current Balance",
                                                        style: TextStyle(fontSize: 13, color: Colors.black38),
                                                      ),
                                                    ),
                                                    /*SizedBox(
                                                      width: 5,
                                                      height: 8,
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: SvgPicture.asset(
                                                          "assets/rupee.svg",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),*/
                                                    Text(
                                                      state.wallet.currency +
                                                          " " +
                                                          AppUtil.doubleRemoveZeroTrailing(state.wallet.scratchAmount),
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  /*Container(
                                    padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vel accumsan dolor. Nulla dignissim ante sed dapibus tincidunt. Fusce id pulvinar nibh. Fusce non fermentum metus. Suspendisse libero metus, finibus sit amet volutpat accumsan, rhoncus in magna. Etiam condimentum,",
                                      style: TextStyle(fontSize: 13, color: Colors.black38),
                                    ),
                                  )*/
                                ],
                              ),
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
}
