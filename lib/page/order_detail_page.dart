import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flyereats/bloc/detailorder/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/order.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';

class DetailOrderPage extends StatefulWidget {
  final Order order;

  const DetailOrderPage({Key key, this.order}) : super(key: key);

  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<DetailOrderBloc>(
          create: (context) {
            return DetailOrderBloc()
              ..add(GetDetailOrder(widget.order.id, loginState.user.token));
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
                      padding: EdgeInsets.only(
                          top: 20,
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable),
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
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(32),
                                      topLeft: Radius.circular(32))),
                              alignment: Alignment.center,
                              child: Container(
                                child: Center(
                                  child: Text(state.message),
                                ),
                              ),
                            );
                          } else if (state is SuccessDetailOrderState) {
                            return SingleChildScrollView(
                              controller: controller,
                              child: Container(
                                width: AppUtil.getScreenWidth(context),
                                height: AppUtil.getScreenHeight(context) -
                                    AppUtil.getToolbarHeight(context),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: CachedNetworkImage(
                                                imageUrl: state.detailOrder
                                                    .restaurant.image,
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
                                                      baseColor:
                                                          Colors.grey[300],
                                                      highlightColor:
                                                          Colors.grey[100]);
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  state.detailOrder.restaurant
                                                      .name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  state.detailOrder.restaurant
                                                      .address,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black26),
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
                                              "ORDER NO - " +
                                                  state.detailOrder.id,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
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
                                      children: _foodCartWidgets(
                                          state.detailOrder.foodCart),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
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

  //List<Widget> _feeWidgets()
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
                    item.food.price.toString() +
                    " )",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  "\u20b9 " + (item.quantity * item.food.price).toString(),
                  textAlign: TextAlign.end,
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
