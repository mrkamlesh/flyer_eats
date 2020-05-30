import 'package:flutter/material.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/model/order.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/order_history_widget.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Order> orders = ExampleModel.getOrderHistory();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: CustomScrollView(
                  controller: controller,
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                      return OrderHistoryWidget(
                        order: orders[i],
                      );
                    }, childCount: orders.length))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
