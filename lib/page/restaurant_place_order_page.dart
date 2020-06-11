import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/bloc.dart';
import 'package:flyereats/bloc/foodorder/bloc.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/voucher.dart';
import 'package:flyereats/page/address_page.dart';
import 'package:flyereats/page/apply_coupon_page.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:flyereats/widget/end_drawer.dart';
import 'package:flyereats/widget/place_order_bottom_navbar.dart';
import 'package:shimmer/shimmer.dart';

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
  AddressBloc _addressBloc;
  FoodOrderBloc _foodOrderBloc;

  @override
  void initState() {
    super.initState();
    _addressBloc = AddressBloc(AddressRepository());
    _foodOrderBloc = FoodOrderBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _addressBloc.close();
    _foodOrderBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<FoodOrderBloc>(
              create: (context) {
                return _foodOrderBloc
                  ..add(InitPlaceOrder(
                      widget.restaurant, widget.foodCart, loginState.user));
              },
            ),
            BlocProvider<AddressBloc>(
              create: (context) {
                return _addressBloc;
              },
            )
          ],
          child: Scaffold(
            endDrawer: EndDrawer(),
            body: BlocBuilder<FoodOrderBloc, FoodOrderState>(
              builder: (context, state) {
                if (state is InitialFoodOrderState) {
                  return Container();
                } else if (state is NoItemsInCart) {
                  return Container(
                      child: Center(child: Text("No Items in cart")));
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
                                title: widget.restaurant.name +
                                    " (" +
                                    state.placeOrder.foodCart.cart.length
                                        .toString() +
                                    ")",
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
                              SliverPersistentHeader(
                                delegate: DeliveryOptions(),
                                pinned: true,
                              ),
                              FoodListPlaceOrder(),
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: horizontalPaddingDraggable,
                                      horizontal: horizontalPaddingDraggable),
                                  margin: EdgeInsets.only(
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                      bottom: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "DELIVERY INSTRUCTION",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: Colors.black12,
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          _foodOrderBloc
                                              .add(ChangeInstruction(value));
                                        },
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                            hintText:
                                                "Enter your instruction here",
                                            hintStyle: TextStyle(fontSize: 12),
                                            border: InputBorder.none),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: state.placeOrder.voucher.id == null
                                    ? GestureDetector(
                                        onTap: () async {
                                          Voucher result = await Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) {
                                            return ApplyCouponPage(
                                              restaurant: widget.restaurant,
                                              totalOrder:
                                                  state.placeOrder.getTotal(),
                                            );
                                          }));

                                          _foodOrderBloc
                                              .add(ApplyVoucher(result));
                                        },
                                        child: Container(
                                          height: 55,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 17,
                                              horizontal:
                                                  horizontalPaddingDraggable),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  horizontalPaddingDraggable),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 55,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 17,
                                            horizontal:
                                                horizontalPaddingDraggable),
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                horizontalPaddingDraggable),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              "assets/check.svg",
                                              height: 24,
                                              width: 24,

                                            ),
                                            SizedBox(
                                              width: 17,
                                            ),
                                            Expanded(
                                              child: Text(
                                                state.placeOrder.voucher.name,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            /*Row(
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
                                      )*/
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
                                    borderRadius: BorderRadius.circular(10),
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
                              BlocBuilder<FoodOrderBloc, FoodOrderState>(
                                bloc: _foodOrderBloc,
                                builder: (context, state) {
                                  if (state is LoadingGetPayments) {
                                    return SliverToBoxAdapter(
                                        child: Container(
                                      margin: EdgeInsets.only(
                                          top: 20,
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom:
                                              kBottomNavigationBarHeight + 160),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: CircularProgressIndicator(),
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
                                          left: horizontalPaddingDraggable,
                                          right: horizontalPaddingDraggable,
                                          bottom:
                                              kBottomNavigationBarHeight + 160),
                                      child: Container(
                                        child: Text(state.placeOrder.message),
                                      ),
                                    ));
                                  } else {
                                    return SliverToBoxAdapter(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 20,
                                            left: horizontalPaddingDraggable,
                                            right: horizontalPaddingDraggable,
                                            bottom: kBottomNavigationBarHeight +
                                                160),
                                        padding: EdgeInsets.only(
                                            left: horizontalPaddingDraggable,
                                            right: horizontalPaddingDraggable,
                                            top: horizontalPaddingDraggable,
                                            bottom: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              amount: AppUtil
                                                  .doubleRemoveZeroTrailing(
                                                      state.placeOrder
                                                          .getOrderTotal()),
                                            ),
                                            OrderRowItem(
                                              title: "TAX",
                                              color: Colors.black,
                                              amount: "0",
                                            ),
                                            OrderRowItem(
                                              title: "PACKAGING",
                                              color: Colors.black,
                                              amount: "0",
                                            ),
                                            OrderRowItem(
                                              title: "DELIVERY FEE",
                                              color: Colors.black,
                                              amount: AppUtil
                                                  .doubleRemoveZeroTrailing(
                                                      state.placeOrder
                                                          .deliveryCharges),
                                            ),
                                            OrderRowItem(
                                              title: "DISCOUNT",
                                              color: Colors.green,
                                              amount: AppUtil
                                                  .doubleRemoveZeroTrailing(
                                                      state.placeOrder
                                                          .getDiscountTotal()),
                                            ),
                                            OrderRowItem(
                                              title: "OFFER/COUPON",
                                              color: Colors.green,
                                              amount: AppUtil
                                                  .doubleRemoveZeroTrailing(
                                                      state.placeOrder.voucher
                                                          .amount),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 13),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            OrderRowItem(
                                                title: "TOTAL",
                                                color: Colors.black,
                                                amount: AppUtil
                                                    .doubleRemoveZeroTrailing(
                                                        state.placeOrder
                                                            .getTotal())),
                                          ],
                                        ),
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
                          FoodListDeliveryInformation(
                            address: state.placeOrder.address,
                            token: state.placeOrder.user.token,
                            foodOrderBloc: _foodOrderBloc,
                            addressBloc: _addressBloc,
                            contact: state.placeOrder.contact,
                            deliveryEstimation:
                                widget.restaurant.deliveryEstimation,
                          ),
                          OrderBottomNavBar(
                            isValid: state.placeOrder.isValid,
                            onButtonTap:
                                state.placeOrder.isValid ? () {} : () {},
                            showRupee:
                                (state is LoadingGetPayments) ? false : true,
                            amount: (state is LoadingGetPayments)
                                ? "..."
                                : state.placeOrder.getTotal(),
                            buttonText: "PLACE ORDER",
                            description: (state is LoadingGetPayments)
                                ? "Calculating..."
                                : "Total Amount",
                          ),
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
  final String amount;

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
        return SliverPadding(
          padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
              right: horizontalPaddingDraggable - 5,
              left: horizontalPaddingDraggable - 5),
          sliver: SliverList(
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
          )),
        );
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
                                    "${AppUtil.doubleRemoveZeroTrailing(food.price)}",
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
  String contactPredicate = "+91";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Delivery To"),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(2)),
                child: Text(widget.address.title),
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<AddressBloc>(context)
                      .add(OpenListAddress(widget.token));

                  showModalBottomSheet(
                      isScrollControlled: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
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
                                  foodOrderBloc: widget.foodOrderBloc,
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
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 52),
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
                                          width:
                                              AppUtil.getScreenWidth(context),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  topRight:
                                                      Radius.circular(32)),
                                              color: Colors.white),
                                          padding: EdgeInsets.only(
                                              top: 20, left: 20, bottom: 20),
                                          child: Text(
                                            "SELECT ADDRESS",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return AddressPage();
                                            }));
                                          },
                                          child: Container(
                                            width:
                                                AppUtil.getScreenWidth(context),
                                            height: kBottomNavigationBarHeight,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (state is ErrorLoadingListAddress) {
                              return Text("Fail load addresses");
                            }
                            return Container();
                          },
                        );
                      });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 30,
                  width: 60,
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                  showModalBottomSheet(
                      isScrollControlled: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      context: context,
                      builder: (context) {
                        return Column(
                          children: <Widget>[
                            Container(
                                width: AppUtil.getScreenWidth(context),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32)),
                                    color: Colors.white),
                                padding: EdgeInsets.only(
                                    top: 20, left: 20, bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "ENTER NUMBER",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                  border: Border.all(
                                      color: Colors.black12, width: 2)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (i) {
                                        setState(() {
                                          _countrySelected = i;
                                          contactPredicate =
                                              i == 0 ? "+91" : "+65";
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: Colors.black12,
                                                  width: 2))),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextField(
                                        onSubmitted: (value) {
                                          if (value != "") {
                                            widget.foodOrderBloc.add(
                                                ChangeContactPhone(
                                                    contactPredicate + value));
                                            Navigator.pop(context);
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          border: InputBorder.none,
                                          hintText: "Enter phone number",
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 30,
                  width: 60,
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
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final FoodOrderBloc foodOrderBloc;

  const AddressItemWidget({Key key, this.address, this.foodOrderBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        break;
      case AddressType.office:
        type = "OFFICE";
        break;
      case AddressType.other:
        type = "OTHER";
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          foodOrderBloc.add(ChangeAddress(address));
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.home,
                      size: 25,
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
