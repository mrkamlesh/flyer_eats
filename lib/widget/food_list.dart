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

  const FoodListWidget(
      {Key key,
      this.listFood,
      this.type = FoodListViewType.list,
      this.scale = 0.9,
      this.cart,
      this.padding,
      this.onAdd,
      this.onRemove})
      : super(key: key);

  @override
  _FoodListWidgetState createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> with TickerProviderStateMixin {
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
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
                index: i,
                scale: _scaleAnimation,
                selectedPrice: widget.cart.getSelectedPrice(widget.listFood[i].id),
                selectedIndex: _selectedFood,
                food: widget.listFood[i],
                quantity: widget.cart.getQuantity(widget.listFood[i].id),
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
                      index: i,
                      quantity: widget.cart.getQuantity(widget.listFood[i].id),
                      selectedPrice: widget.cart.getSelectedPrice(widget.listFood[i].id),
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
                    childAspectRatio: AppUtil.getScreenWidth(context) / 2 / 235)));
      case FoodListViewType.search:
        return SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return FoodList(
                      type: widget.type,
                      index: i,
                      quantity: widget.cart.getQuantity(widget.listFood[i].id),
                      selectedPrice: widget.cart.getSelectedPrice(widget.listFood[i].id),
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
                    childAspectRatio: AppUtil.getScreenWidth(context) / 2 / 235)));
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
  final int selectedPrice;

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
      this.selectedPrice})
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: onTapRemove,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700], borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                child: Icon(Icons.remove)),
          )),
          Expanded(child: Container(alignment: Alignment.center, child: Text("$quantity"))),
          Expanded(
              child: GestureDetector(
            onTap: onTapAdd,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700], borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                child: Icon(Icons.add)),
          ))
        ],
      ),
    );

    switch (type) {
      case FoodListViewType.grid:
        return Container(
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                                width: (AppUtil.getScreenWidth(context) - 30) / 2,
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
                              children: <Widget>[
                                food.isAvailable
                                    ? Container(
                                        height: 12,
                                        width: 12,
                                        margin: EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                          "assets/box_circle.svg",
                                          width: 12,
                                          height: 12,
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Text(
                                    food.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                                          "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(food.prices[selectedPrice].price),
                                          style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                                        )
                                      : SizedBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        "assets/rupee.svg",
                                        height: 8,
                                        width: 8,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice(selectedPrice))}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                            : Expanded(flex: 5, child: changeQuantityButton),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;
      case FoodListViewType.list:
        return Container(
          height: 120,
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
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                            child: Container(
                              height: 120,
                              width: 120,
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Text(
                                  food.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),
                              food.description != null && food.description != ""
                                  ? Container(
                                      margin: EdgeInsets.only(top: 5, bottom: 10, right: 10),
                                      child: Text(
                                        AppUtil.parseHtmlString(food.description),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black54, fontSize: 10),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          height: 43,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    food.discount > 0
                                        ? Text(
                                            "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(food.prices[selectedPrice].price),
                                            style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                                          )
                                        : SizedBox(),
                                    Row(
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
                                          "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice(selectedPrice))}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(),
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
        break;
      case FoodListViewType.search:
        return Container(
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                                width: (AppUtil.getScreenWidth(context) - 30) / 2,
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
                              children: <Widget>[
                                food.isAvailable
                                    ? Container(
                                        height: 12,
                                        width: 12,
                                        margin: EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                          "assets/box_circle.svg",
                                          width: 12,
                                          height: 12,
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Text(
                                    food.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                                          "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(food.prices[selectedPrice].price),
                                          style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                                        )
                                      : SizedBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        "assets/rupee.svg",
                                        height: 8,
                                        width: 8,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "${AppUtil.doubleRemoveZeroTrailing(food.getRealPrice(selectedPrice))}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                            : Expanded(flex: 5, child: changeQuantityButton),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              height: 120,
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
