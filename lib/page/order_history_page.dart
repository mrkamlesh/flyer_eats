import 'package:clients/bloc/orderhistory/food/bloc.dart';
import 'package:clients/bloc/orderhistory/pickup/bloc.dart';
import 'package:clients/bloc/orderhistory/pickup/pickup_order_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/order_detail_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/order_history_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with TickerProviderStateMixin {
  TabController tabController;
  OrderHistoryBloc foodOrderHistoryBloc;
  PickupOrderHistoryBloc pickupOrderHistoryBloc;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    foodOrderHistoryBloc = OrderHistoryBloc();
    pickupOrderHistoryBloc = PickupOrderHistoryBloc();
  }

  @override
  void dispose() {
    pickupOrderHistoryBloc.close();
    foodOrderHistoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<OrderHistoryBloc>(
              create: (context) {
                return foodOrderHistoryBloc..add(GetOrderHistory(loginState.user.token));
              },
            ),
            BlocProvider<PickupOrderHistoryBloc>(
              create: (context) {
                return pickupOrderHistoryBloc..add(GetPickupOrderHistory(loginState.user.token));
              },
            ),
          ],
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
                    controller.addListener(() {
                      double maxScroll = controller.position.maxScrollExtent;
                      double currentScroll = controller.position.pixels;

                      if (currentScroll == maxScroll) {
                        pickupOrderHistoryBloc.add(OnLoadMorePickup(loginState.user.token));
                      }
                    });

                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                      height: AppUtil.getScreenHeight(context),
                      width: AppUtil.getScreenWidth(context),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                            padding: EdgeInsets.only(
                                bottom: 10,
                                top: 15,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable),
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: 0,
                              child: TabBar(
                                controller: tabController,
                                onTap: (i) {
                                  if (i == 0) {
                                    foodOrderHistoryBloc..add(GetOrderHistory(loginState.user.token));
                                  } else if (i == 1) {
                                    pickupOrderHistoryBloc..add(GetPickupOrderHistory(loginState.user.token));
                                  }
                                },
                                isScrollable: false,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.black26,
                                indicatorColor: Colors.yellow[600],
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                                indicatorPadding: EdgeInsets.only(left: 0, right: 15, bottom: 2, top: 0),
                                labelPadding: EdgeInsets.only(left: 0, right: 15, bottom: 0),
                                tabs: [
                                  Tab(
                                    text: "Order",
                                  ),
                                  Tab(text: "Pickup and Delivery")
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: AppUtil.getScreenHeight(context),
                              width: AppUtil.getScreenWidth(context),
                              child: TabBarView(controller: tabController, children: [
                                BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
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
                                                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                        padding: EdgeInsets.only(
                                            left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: Center(
                                            child: Text("Error Get Order History"),
                                          ),
                                        ),
                                      );
                                    }
                                    if (state.listOrder.length == 0) {
                                      return Container(
                                        height: AppUtil.getDraggableHeight(context),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                                      return Container(
                                        alignment: Alignment.topCenter,
                                        child: ListView.builder(
                                          controller: controller,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 10),
                                          itemBuilder: (context, i) {
                                            if (state is LoadingMoreOrderHistoryState) {
                                              if (i == state.listOrder.length) {
                                                return Container(
                                                    margin: EdgeInsets.only(top: 20),
                                                    child: Center(child: CircularProgressIndicator()));
                                              }
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return DetailOrderPage(
                                                    orderId: state.listOrder[i].id,
                                                  );
                                                }));
                                              },
                                              child: FoodOrderHistoryWidget(
                                                order: state.listOrder[i],
                                              ),
                                            );
                                          },
                                          itemCount: state is LoadingMoreOrderHistoryState
                                              ? state.listOrder.length + 1
                                              : state.listOrder.length,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                BlocBuilder<PickupOrderHistoryBloc, PickupOrderHistoryState>(
                                  builder: (context, state) {
                                    if (state is LoadingPickupOrderHistoryState) {
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
                                    } else if (state is ErrorPickupOrderHistoryState) {
                                      return Container(
                                        height: AppUtil.getDraggableHeight(context),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                        padding: EdgeInsets.only(
                                            left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: Center(
                                            child: Text("Error Get Order History"),
                                          ),
                                        ),
                                      );
                                    }
                                    if (state.listOrder.length == 0) {
                                      return Container(
                                        height: AppUtil.getDraggableHeight(context),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
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
                                      return Container(
                                        alignment: Alignment.topCenter,
                                        child: ListView.builder(
                                          controller: controller,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 10),
                                          itemBuilder: (context, i) {
                                            if (state is LoadingMorePickupOrderHistoryState) {
                                              if (i == state.listOrder.length) {
                                                return Container(
                                                    margin: EdgeInsets.only(top: 20),
                                                    child: Center(child: CircularProgressIndicator()));
                                              }
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return DetailOrderPage(
                                                      orderId: state.listOrder[i].id,
                                                    );
                                                  }));*/
                                              },
                                              child: PickupOrderHistoryWidget(
                                                pickupOrder: state.listOrder[i],
                                              ),
                                            );
                                          },
                                          itemCount: state is LoadingMorePickupOrderHistoryState
                                              ? state.listOrder.length + 1
                                              : state.listOrder.length,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ]),
                            ),
                          ),
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
