import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/coupon/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../classes/app_util.dart';

class ApplyCouponPage extends StatefulWidget {
  final Restaurant restaurant;
  final double totalOrder;

  const ApplyCouponPage({Key key, this.restaurant, this.totalOrder})
      : super(key: key);

  @override
  _ApplyCouponPageState createState() => _ApplyCouponPageState();
}

class _ApplyCouponPageState extends State<ApplyCouponPage> {
  TextEditingController _couponController;
  CouponBloc _bloc;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
    _bloc = CouponBloc();
    _couponController.addListener(() {
      _bloc.add(UpdateCouponTyped(_couponController.text));
    });
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
        return BlocProvider<CouponBloc>(
          create: (context) {
            return _bloc
              ..add(GetCouponList(widget.restaurant, loginState.user.token));
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                            title: "Apply Coupons",
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
                  initialChildSize: (AppUtil.getScreenHeight(context) -
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
                          SliverToBoxAdapter(
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(
                                  vertical: horizontalPaddingDraggable,
                                  horizontal: horizontalPaddingDraggable),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: primary2),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary3,
                                    blurRadius: 7,
                                    spreadRadius: -3,
                                  )
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: horizontalPaddingDraggable,
                                  ),
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
                                    child: TextField(
                                      controller: _couponController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "ENTER COUPON",
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38),
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<CouponBloc, CouponState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: state.couponTyped != "" &&
                                                !(state is LoadingApplyCoupon)
                                            ? () {
                                                _bloc.add(ApplyCoupon(
                                                    widget.restaurant,
                                                    widget.totalOrder,
                                                    loginState.user.token));
                                              }
                                            : () {},
                                        child: AnimatedOpacity(
                                          opacity: state.couponTyped != "" &&
                                                  !(state is LoadingApplyCoupon)
                                              ? 1.0
                                              : 0.5,
                                          child: Container(
                                            height: 55,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: primary2),
                                                color: primary2,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child:
                                                    state is LoadingApplyCoupon
                                                        ? SpinKitCircle(
                                                            color: Colors.white,
                                                            size: 30,
                                                          )
                                                        : Text(
                                                            "Apply",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                          ),
                                          duration: Duration(milliseconds: 300),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: BlocConsumer<CouponBloc, CouponState>(
                              listener: (context, state) {
                                if (state is SuccessApplyCoupon) {
                                  Navigator.pop(context, state.voucher);
                                }
                              },
                              builder: (context, state) {
                                if (state is ErrorApplyCoupon) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable,
                                        bottom: 30),
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      state.message,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                          BlocBuilder<CouponBloc, CouponState>(
                            builder: (context, state) {
                              if (state is LoadingCouponList) {
                                return SliverToBoxAdapter(
                                  child: Container(
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: Colors.black38,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (state is ErrorCouponList) {
                                return SliverToBoxAdapter(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: horizontalPaddingDraggable,
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable),
                                      child: Text(state.message)),
                                );
                              }
                              return SliverList(
                                  delegate:
                                      SliverChildBuilderDelegate((context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    _couponController.text =
                                        state.couponList[i].code;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: horizontalPaddingDraggable,
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            imageUrl: state.couponList[i].image,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            placeholder: (context, url) {
                                              return Shimmer.fromColors(
                                                  child: Container(
                                                    height: 100,
                                                    color: Colors.black,
                                                  ),
                                                  baseColor: Colors.grey[300],
                                                  highlightColor:
                                                      Colors.grey[100]);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        /* Html(data: state.couponList[i].name),*/
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, left: 10, right: 10),
                                          child: Text(
                                            AppUtil.parseHtmlString(
                                                state.couponList[i].name),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Text(
                                            state.couponList[i].text,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }, childCount: state.couponList.length));
                            },
                          )
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
}
