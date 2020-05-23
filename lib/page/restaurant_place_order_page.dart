import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/food/detail_page_bloc.dart';
import 'package:flyereats/bloc/food/detail_page_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/delivery_information_widget.dart';
import 'package:flyereats/widget/food_list.dart';
import 'package:flyereats/widget/place_order_bottom_navbar.dart';

class RestaurantPlaceOrderPage extends StatefulWidget {
  final Restaurant restaurant;
  final FoodCart foodCart;

  const RestaurantPlaceOrderPage({Key key, this.restaurant, this.foodCart})
      : super(key: key);

  @override
  _RestaurantPlaceOrderPageState createState() =>
      _RestaurantPlaceOrderPageState();
}

class _RestaurantPlaceOrderPageState extends State<RestaurantPlaceOrderPage>
    with SingleTickerProviderStateMixin {
  List<Food> _listFood = [];
  FoodCart _foodCart;
  int _radioGroup = 0;
  bool _isUseWallet = false;
  FoodCart cart;

  @override
  void initState() {
    super.initState();
    _foodCart = widget.foodCart;
    widget.foodCart.cart.forEach((id, food) => _listFood.add(food.food));
  }

  @override
  void dispose() {
    super.dispose();
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
                child: CustomAppBar(
                  leading: "assets/back.svg",
                  drawer: "assets/drawer.svg",
                  title: widget.restaurant.name,
                  onTapLeading: () {
                    Navigator.pop(context);
                  },
                  onTapDrawer: () {},
                  backgroundColor: Colors.transparent,
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
                child: BlocBuilder<DetailPageBloc, DetailPageState>(
                  builder: (context, state) {
                    if (state is CartState) {
                      _foodCart = state.cart;
                    }

                    return CustomScrollView(
                      controller: controller,
                      slivers: <Widget>[
                        SliverPersistentHeader(
                          delegate: DeliveryOptions(
                              groupValue: _radioGroup,
                              onTapSelfPickup: (i) {
                                setState(() {
                                  _radioGroup = i;
                                });
                              },
                              onTapDeliveryOption: (i) {
                                setState(() {
                                  _radioGroup = i;
                                });
                              }),
                          pinned: true,
                        ),
                        FoodListWidget(
                          padding: EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                              right: horizontalPaddingDraggable,
                              left: horizontalPaddingDraggable),
                          type: FoodListViewType.list,
                          cart: _foodCart,
                          listFood: _listFood,
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(
                                vertical: 17,
                                horizontal: horizontalPaddingDraggable),
                            margin: EdgeInsets.symmetric(
                                horizontal: horizontalPaddingDraggable),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.orange[100],
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(2, 3)),
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
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(
                                top: 20,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable),
                            padding: EdgeInsets.only(
                                top: 17, bottom: 17, left: 17, right: 17),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.orange[100],
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(2, 3)),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 25,
                                  child: Checkbox(
                                      activeColor: Colors.green,
                                      value: _isUseWallet,
                                      onChanged: (value) {
                                        setState(() {
                                          _isUseWallet = value;
                                        });
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
                                      "30",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 20,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                                bottom: kBottomNavigationBarHeight + 130),
                            padding: EdgeInsets.only(
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                                top: horizontalPaddingDraggable,
                                bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.orange[100],
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(2, 3)),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                OrderRowItem(
                                  title: "ORDER",
                                  color: Colors.black,
                                  amount: 60,
                                ),
                                OrderRowItem(
                                  title: "TAX",
                                  color: Colors.black,
                                  amount: 10,
                                ),
                                OrderRowItem(
                                  title: "PACKAGING",
                                  color: Colors.black,
                                  amount: 0,
                                ),
                                OrderRowItem(
                                  title: "DELIVERY FEE",
                                  color: Colors.black,
                                  amount: 0,
                                ),
                                OrderRowItem(
                                  title: "DISCOUNT",
                                  color: Colors.green,
                                  amount: 10,
                                ),
                                OrderRowItem(
                                  title: "OFFER",
                                  color: Colors.green,
                                  amount: 0,
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
                                    amount: 60),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                DeliveryInformationWidget(
                  address: Address(
                    1,
                    "Home",
                    "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100",
                    AddressType.other,
                  ),
                  distance: "30 Min",
                  allAddresses: ExampleModel.getAddresses(),
                ),
                BlocBuilder<DetailPageBloc, DetailPageState>(
                  builder: (context, state) {
                    int amount = 0;
                    if (state is CartState) {
                      state.cart.cart.forEach((i, item) {
                        amount = amount + item.food.price * item.quantity;
                      });
                    }

                    return OrderBottomNavBar(
                      isValid: amount > 0 ? true : false,
                      amount: amount,
                      description: "Total Amount",
                      onButtonTap: () {},
                      buttonText: "PLACE ORDER",
                      showRupee: true,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DeliveryOptions extends SliverPersistentHeaderDelegate {
  final int groupValue;
  final Function(int) onTapDeliveryOption;
  final Function(int) onTapSelfPickup;

  DeliveryOptions(
      {this.groupValue, this.onTapDeliveryOption, this.onTapSelfPickup});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32))),
      padding: EdgeInsets.only(top: 10 + MediaQuery.of(context).padding.top),
      margin: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: RadioCustom(
              radio: Radio(
                  visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  activeColor: Colors.green,
                  value: 0,
                  groupValue: groupValue,
                  onChanged: (i) {
                    onTapDeliveryOption(i);
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
                  value: 1,
                  groupValue: groupValue,
                  onChanged: (i) {
                    onTapSelfPickup(i);
                  }),
              icon: "assets/selfpickup.svg",
              title: "Self Pickup",
              subtitle: "Go & Pickup The Order On Time",
            ),
          ),
        ],
      ),
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
  final int amount;

  const OrderRowItem({Key key, this.title, this.color, this.amount})
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
            "assets/rupee.svg",
            width: 10,
            height: 10,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 20,
            child: Text(
              "$amount",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
