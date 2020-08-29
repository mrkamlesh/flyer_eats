import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:shimmer/shimmer.dart';

enum FoodListViewType { list, grid, search }

class FoodListWidget extends StatefulWidget {
  final List<Food> listFood;
  final FoodListViewType type;
  final double scale;
  final FoodCart cart;
  final EdgeInsets padding;
  final Function(int) onRemove;
  final Function(int) onAdd;
  final String currencyCode;

  const FoodListWidget(
      {Key key,
      this.listFood,
      this.type = FoodListViewType.list,
      this.scale = 0.9,
      this.cart,
      this.padding,
      this.onAdd,
      this.onRemove,
      this.currencyCode})
      : super(key: key);

  @override
  _FoodListWidgetState createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget>
    with TickerProviderStateMixin {
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case FoodListViewType.list:
        return SliverPadding(
          padding: widget.padding,
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return FoodList(
                type: widget.type,
                currencyCode: widget.currencyCode,
                index: i,
                scale: _scaleAnimation,
                selectedIndex: _selectedFood,
                food: widget.listFood[i],
                quantity: widget.cart.getFoodQuantity(widget.listFood[i]),
                onTapRemove: () {
                  _onTapRemove(i);
                },
                onTapAdd: () {
                  _onTapAdd(i);
                },
              );
            },
            childCount: widget.listFood.length,
          )),
        );
      case FoodListViewType.grid:
        return SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return FoodList(
                      type: widget.type,
                      currencyCode: widget.currencyCode,
                      index: i,
                      quantity: widget.cart.getFoodQuantity(widget.listFood[i]),
                      scale: _scaleAnimation,
                      selectedIndex: _selectedFood,
                      food: widget.listFood[i],
                      onTapRemove: () {
                        _onTapRemove(i);
                      },
                      onTapAdd: () {
                        _onTapAdd(i);
                      },
                    );
                  },
                  childCount: widget.listFood.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio:
                        AppUtil.getScreenWidth(context) / 2 / 235)));
      case FoodListViewType.search:
        return SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return FoodList(
                      type: widget.type,
                      currencyCode: widget.currencyCode,
                      index: i,
                      quantity: widget.cart.getFoodQuantity(widget.listFood[i]),
                      scale: _scaleAnimation,
                      selectedIndex: _selectedFood,
                      food: widget.listFood[i],
                      onTapRemove: () {
                        _onTapRemove(i);
                      },
                      onTapAdd: () {
                        _onTapAdd(i);
                      },
                    );
                  },
                  childCount: widget.listFood.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio:
                        AppUtil.getScreenWidth(context) / 2 / 235)));
      default:
        return SliverToBoxAdapter();
    }
  }

  void _onTapAdd(int i) {
    setState(() {
      _selectedFood = i;
    });
    _animationController.forward().orCancel.whenComplete(() {
      _animationController.reverse().orCancel.whenComplete(() {
        widget.onAdd(i);
      });
    });
  }

  void _onTapRemove(int i) {
    setState(() {
      _selectedFood = i;
    });
    _animationController.forward().orCancel.whenComplete(() {
      _animationController.reverse().orCancel.whenComplete(() {
        widget.onRemove(i);
      });
    });
  }
}

class FoodList extends StatelessWidget {
  final Food food;
  final int index;
  final int selectedIndex;
  final Function onTapAdd;
  final Function onTapRemove;
  final Animation<double> scale;
  final int quantity;
  final FoodListViewType type;
  final String currencyCode;

  const FoodList(
      {Key key,
      this.food,
      this.index,
      this.selectedIndex,
      this.onTapAdd,
      this.onTapRemove,
      this.scale,
      this.quantity,
      this.type,
      this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool hasQuantity = !quantity.containsKey(index) ? add : quantity[index] == 0 ? add : quantityadd;

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

    switch (type) {
      case FoodListViewType.grid:
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  /*BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(2, 3))*/
                  BoxShadow(
                    color: shadow,
                    blurRadius: 7,
                    spreadRadius: -3,
                  )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        //margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: food.image,
                            width: (AppUtil.getScreenWidth(context) - 30) / 2,
                            height: 90,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                  child: Container(
                                    height: 90,
                                    width:
                                        (AppUtil.getScreenWidth(context) - 30) /
                                            2,
                                    color: Colors.black,
                                  ),
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100]);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    food.isVeg
                                        ? Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(
                                                right: 10, top: 3),
                                            child: SvgPicture.asset(
                                              "assets/box_circle.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                          )
                                        : Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(
                                                right: 10, top: 3),
                                            child: SvgPicture.asset(
                                              "assets/box_circle_red.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                          ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Scaffold.of(context)
                                              .hideCurrentSnackBar(
                                                  reason: SnackBarClosedReason
                                                      .dismiss);
                                          final snackBar = SnackBar(
                                            content: Text(food.title),
                                            duration: Duration(seconds: 2),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        child: Text(
                                          AppUtil.parseHtmlString(food.title),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*food.description != null && food.description != ""
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: Text(
                                        food.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black54, fontSize: 10),
                                      ),
                                    )
                                  : Container(),*/
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: (AppUtil.getScreenWidth(context) - 60) / 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      food.discount > 0
                                          ? Text(
                                              AppUtil.getCurrencyString(
                                                      currencyCode) +
                                                  " " +
                                                  AppUtil
                                                      .doubleRemoveZeroTrailing(
                                                          food.price.price),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          : SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            AppUtil.getCurrencyIcon(
                                                currencyCode),
                                            height: 8,
                                            width: 8,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice())}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            quantity == 0
                                ? Expanded(flex: 5, child: addButton)
                                : Expanded(
                                    flex: 5, child: changeQuantityButton),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            food.badge != null && food.badge != ""
                ? Positioned(
                    top: 7,
                    left: -5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                              color: food.getBadgeColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                  topRight: Radius.circular(2),
                                  bottomRight: Radius.circular(2))),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4),
                          child: Text(
                            food.badge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        CustomPaint(
                          size: Size(5, 5),
                          painter:
                              FoodTrianglePainter(color: food.getBadgeColor()),
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        );
        break;
      case FoodListViewType.list:
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: 125,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: food.image,
                          height: 125,
                          width: 125,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                                child: Container(
                                  height: 125,
                                  width: 125,
                                  color: Colors.black,
                                ),
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100]);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 3),
                                          child: SvgPicture.asset(
                                            food.isVeg
                                                ? "assets/box_circle.svg"
                                                : "assets/box_circle_red.svg",
                                            width: 12,
                                            height: 12,
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Scaffold.of(context)
                                                  .hideCurrentSnackBar(
                                                  reason: SnackBarClosedReason
                                                      .dismiss);
                                              final snackBar = SnackBar(
                                                content: Text(food.title),
                                                duration: Duration(seconds: 2),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            },
                                            child: Text(
                                              AppUtil.parseHtmlString(
                                                  food.title),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  food.description != null &&
                                          food.description != ""
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: 5,
                                              bottom: 10,
                                              right: 10,
                                              left: 32),
                                          child: Text(
                                            AppUtil.parseHtmlString(
                                                food.description),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            Container(
                              height: 43,
                              margin: EdgeInsets.only(left: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    flex: 9,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            food.discount > 0
                                                ? Text(
                                                    AppUtil.getCurrencyString(
                                                            currencyCode) +
                                                        " " +
                                                        AppUtil
                                                            .doubleRemoveZeroTrailing(
                                                                food.price
                                                                    .price),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  )
                                                : SizedBox(),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  AppUtil.getCurrencyIcon(
                                                      currencyCode),
                                                  height: 11,
                                                  width: 11,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice())}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  quantity == 0
                                      ? Expanded(flex: 11, child: addButton)
                                      : Expanded(
                                          flex: 11,
                                          child: changeQuantityButton),
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
            ),
            food.badge != null && food.badge != ""
                ? Positioned(
                    top: 7,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          //width: 125,
                          height: 25,
                          decoration: BoxDecoration(
                              color: food.getBadgeColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                  topRight: Radius.circular(2),
                                  bottomRight: Radius.circular(2))),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4),
                          child: Text(
                            food.badge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        CustomPaint(
                          size: Size(5, 5),
                          painter:
                              FoodTrianglePainter(color: food.getBadgeColor()),
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        );
        break;
      case FoodListViewType.search:
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  /*BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(2, 3))*/
                  BoxShadow(
                    color: shadow,
                    blurRadius: 7,
                    spreadRadius: -3,
                  )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        //margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: food.image,
                            width: (AppUtil.getScreenWidth(context) - 30) / 2,
                            height: 90,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                  child: Container(
                                    height: 90,
                                    width:
                                        (AppUtil.getScreenWidth(context) - 30) /
                                            2,
                                    color: Colors.black,
                                  ),
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100]);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    food.isVeg
                                        ? Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(
                                                right: 10, top: 3),
                                            child: SvgPicture.asset(
                                              "assets/box_circle.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                          )
                                        : Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(
                                                right: 10, top: 3),
                                            child: SvgPicture.asset(
                                              "assets/box_circle_red.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                          ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Scaffold.of(context)
                                              .hideCurrentSnackBar(
                                              reason: SnackBarClosedReason
                                                  .dismiss);
                                          final snackBar = SnackBar(
                                            content: Text(food.title),
                                            duration: Duration(seconds: 2),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        child: Text(
                                          AppUtil.parseHtmlString(food.title),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*food.description != null && food.description != ""
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: Text(
                                        food.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black54, fontSize: 10),
                                      ),
                                    )
                                  : Container(),*/
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: (AppUtil.getScreenWidth(context) - 60) / 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      food.discount > 0
                                          ? Text(
                                              AppUtil.getCurrencyString(
                                                      currencyCode) +
                                                  " " +
                                                  AppUtil
                                                      .doubleRemoveZeroTrailing(
                                                          food.price.price),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          : SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            AppUtil.getCurrencyIcon(
                                                currencyCode),
                                            height: 8,
                                            width: 8,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice())}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            quantity == 0
                                ? Expanded(flex: 5, child: addButton)
                                : Expanded(
                                    flex: 5, child: changeQuantityButton),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            food.badge != null && food.badge != ""
                ? Positioned(
                    top: 7,
                    left: -5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                              color: food.getBadgeColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                  topRight: Radius.circular(2),
                                  bottomRight: Radius.circular(2))),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4),
                          child: Text(
                            food.badge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        CustomPaint(
                          size: Size(5, 5),
                          painter:
                              FoodTrianglePainter(color: food.getBadgeColor()),
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        );
      default:
        return Container();
        break;
    }
  }
}

class FoodListLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
          left: horizontalPaddingDraggable - 5,
          right: horizontalPaddingDraggable - 5,
          top: 10,
          bottom: kBottomNavigationBarHeight),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
        return Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(top: 2, bottom: 18, left: 5, right: 5),
              height: 125,
              child: SizedBox.expand(),
            ),
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100]);
      }, childCount: 5)),
    );
  }
}

class FoodGridLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          top: 10,
          bottom: kBottomNavigationBarHeight),
      sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: AppUtil.getScreenWidth(context) / 2 / 240),
          delegate: SliverChildBuilderDelegate((context, i) {
            return Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          }, childCount: 5)),
    );
  }
}

class FoodTrianglePainter extends CustomPainter {
  final Color color;

  FoodTrianglePainter({this.color = const Color(0xFFCA9312)});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(5, 0);
    path.lineTo(5, 5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
