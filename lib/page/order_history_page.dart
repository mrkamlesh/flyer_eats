import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/bloc/orderhistory/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/order_history_widget.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return BlocProvider<OrderHistoryBloc>(
          create: (context) {
            return OrderHistoryBloc()..add(GetOrderHistory(state.user.token));
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
                      padding: EdgeInsets.only(top: 20),
                      child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
                        builder: (context, state) {
                          if (state is LoadingOrderHistoryState) {
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
                          } else if (state is ErrorOrderHistoryState) {
                            return Container(
                              height: AppUtil.getDraggableHeight(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(32),
                                      topLeft: Radius.circular(32))),
                              padding: EdgeInsets.only(
                                  top: 20,
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable),
                              alignment: Alignment.center,
                              child: Container(
                                child: Center(
                                  child: Text("Error Get Order History"),
                                ),
                              ),
                            );
                          } else if (state is SuccessOrderHistoryState) {
                            if (state.listOrder.length == 0) {
                              return Container(
                                height: AppUtil.getDraggableHeight(context),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(32),
                                        topLeft: Radius.circular(32))),
                                padding: EdgeInsets.only(
                                    top: 20,
                                    left: horizontalPaddingDraggable,
                                    right: horizontalPaddingDraggable),
                                alignment: Alignment.center,
                                child: Container(
                                  child: Center(
                                    child: Text("No order history"),
                                  ),
                                ),
                              );
                            } else {
                              return CustomScrollView(
                                controller: controller,
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                              (context, i) {
                                            return OrderHistoryWidget(
                                              order: state.listOrder[i],
                                            );
                                          }, childCount: state.listOrder.length))
                                ],
                              );
                            }
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
}
