import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/foodorder/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/delivery_information_widget.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:shimmer/shimmer.dart';
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
  bool _isUseWallet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<FoodOrderBloc>(
          create: (context) {
            return FoodOrderBloc()
              ..add(InitPlaceOrder(
                  widget.restaurant, widget.foodCart, loginState.user));
          },
          child: Scaffold(
            endDrawer: EndDrawer(),
            body: BlocBuilder<FoodOrderBloc, FoodOrderState>(
              builder: (context, state) {
                if (state is InitialFoodOrderState) return Container();
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
                                drawer: "assets/drawer.svg",
                                title: widget.restaurant.name,
                                onTapLeading: () {
                                  Navigator.pop(context);
                                },
                                onTapDrawer: () {
                                  Scaffold.of(context).openEndDrawer();
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
                              SliverPersistentHeader(
                                delegate: DeliveryOptions(),
                                pinned: true,
                              ),
                              FoodListPlaceOrder(),
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
                              "1",
                              "Home",
                              "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100",
                              AddressType.other,
                            ),
                            distance: "30 Min",
                            allAddresses: ExampleModel.getAddresses(),
                          ),
                          /*BlocBuilder<DetailPageBloc, DetailPageState>(
                            builder: (context, state) {
                              double amount = 0;
                              if (state is CartState) {
                                state.cart.cart.forEach((i, item) {
                                  amount =
                                      amount + item.food.price * item.quantity;
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
                          ),*/
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
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
          padding:
              EdgeInsets.only(top: 10 + MediaQuery.of(context).padding.top),
          margin: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
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
                      value: "self-pickup",
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

class FoodListPlaceOrder extends StatefulWidget {
  @override
  _FoodListPlaceOrderState createState() => _FoodListPlaceOrderState();
}

class _FoodListPlaceOrderState extends State<FoodListPlaceOrder>
    with SingleTickerProviderStateMixin {
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodOrderBloc, FoodOrderState>(
      builder: (context, state) {
        List<Food> foodList = List();
        state.placeOrder.foodCart.cart
            .forEach((id, food) => foodList.add(food.food));
        return SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, i) {
            return FoodItemPlaceOrder(
              index: i,
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
                    BlocProvider.of<FoodOrderBloc>(context).add(
                        ChangeQuantityFoodCart(
                            foodList[i].id,
                            foodList[i],
                            (state.placeOrder.foodCart
                                    .getQuantity(foodList[i].id) -
                                1)));
                  });
                });
              },
              onTapAdd: () {
                setState(() {
                  _selectedFood = i;
                });
                _animationController.forward().orCancel.whenComplete(() {
                  _animationController.reverse().orCancel.whenComplete(() {
                    BlocProvider.of<FoodOrderBloc>(context).add(
                        ChangeQuantityFoodCart(
                            foodList[i].id,
                            foodList[i],
                            (state.placeOrder.foodCart
                                    .getQuantity(foodList[i].id) +
                                1)));
                  });
                });
              },
            );
          },
          childCount: foodList.length,
        ));
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

  const FoodItemPlaceOrder({
    Key key,
    this.food,
    this.index,
    this.selectedIndex,
    this.onTapAdd,
    this.onTapRemove,
    this.scale,
    this.quantity,
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: onTapRemove,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10))),
                child: Icon(Icons.remove)),
          )),
          Expanded(
              child: Container(
                  alignment: Alignment.center, child: Text("$quantity"))),
          Expanded(
              child: GestureDetector(
            onTap: onTapAdd,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10))),
                child: Icon(Icons.add)),
          ))
        ],
      ),
    );

    return Container(
      height: 100,
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
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: food.image,
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                        child: Container(
                          height: 80,
                          width: 100,
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
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        food.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10, right: 10),
                      child: Text(
                        food.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
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
                                    "${food.price}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
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
